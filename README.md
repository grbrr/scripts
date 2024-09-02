# scripts
Scripts that I used more than once, thus worth keeping

scp:
scp file_to_transfer user@hostname:location
e.g.
scp ./file.txt user@192.168.1.1:/home/user


ssh tunnel
ssh -L remote_port:localhost:local_port user@hostname -p sshport
e.g. ssh -L 5432:localhost:5432 user@192.168.1.1 -p 20022
