# scripts

Scripts that I used more than once, thus worth keeping

## scp

scp file_to_transfer user@hostname:location
e.g.
scp ./file.txt user@192.168.1.1:/home/user

## ssh tunnel

ssh -L remote_port:localhost:local_port user@hostname -p sshport
e.g. ssh -L 5432:localhost:5432 user@192.168.1.1 -p 20022

## Reverse tunnel

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
ExecStart=/usr/bin/ssh reverse-tunnel
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
