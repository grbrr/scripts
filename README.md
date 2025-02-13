# scripts

Scripts that I used more than once, thus worth keeping

## 1. scp

scp file_to_transfer user@hostname:location
e.g.
scp ./file.txt user@192.168.1.1:/home/user

## 2. ssh tunnel

ssh -L remote_port:localhost:local_port user@hostname -p sshport
e.g. ssh -L 5432:localhost:5432 user@192.168.1.1 -p 20022

## 3. Reverse tunnel

### Setup

Edit `~/.ssh/config`:

```text
Host reverse-tunnel
    HostName server.com
    User user
    IdentityFile ~/.ssh/id_rsa
    RemoteForward 2222 localhost:22
    RemoteForward 8080 localhost:8080
    ServerAliveInterval 60
    ServerAliveCountMax 3
```

- `HostName`: Proxy server.
- `User`: Proxy server user.
- `IdentityFile`: SSH key which is authorized on server.
- `RemoteForward`: Port mapping.
- `ServerAliveInterval` and `ServerAliveCountMax`: Timeout settings.

### Automation

`sudo nano /etc/systemd/system/reverse-ssh.service`

```ini
[Unit]
Description=Reverse SSH Tunnel
After=network.target

[Service]
User=pi
ExecStart=/usr/bin/ssh -N -T reverse-tunnel
Restart=always
RestartSec=10
Environment="DISPLAY=:0"

[Install]
WantedBy=multi-user.target
```

```bash
sudo systemctl daemon-reload
sudo systemctl enable reverse-ssh
sudo systemctl start reverse-ssh
```

`sudo systemctl status reverse-ssh`

## 4. Reverse proxy with duckdns and nginx behind router (443 forwarding)

`sudo apt update && sudo apt install nginx -y`

```bash
systemctl start nginx
systemctl enable nginx
```

`sudo nano /etc/nginx/sites-available/reverse_proxy`

```nginx
server {
    listen 443 ssl;
    server_name device.duckdns.org;

    ssl_certificate /etc/letsencrypt/live/device.duckdns.org/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/device.duckdns.org/privkey.pem;

    location / {
        proxy_pass https://192.168.1.100;  # IP of device in LAN
        proxy_ssl_verify off;  # ignore self-signed cert of device behind proxy
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
```

```bash
sudo ln -s /etc/nginx/sites-available/reverse_proxy /etc/nginx/sites-enabled/
sudo systemctl restart nginx
```

Get let's encrypt cert

`sudo apt install certbot python3-certbot-nginx -y`

`sudo certbot --nginx -d device.duckdns.org`

autorefresh:

`echo "0 3 * * * certbot renew --quiet" | sudo tee -a /etc/crontab`

manual using txt record:

`sudo certbot certonly --manual --preferred-challenges dns -d device.duckdns.org`
