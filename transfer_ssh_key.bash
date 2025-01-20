#!/bin/bash

read -p "Enter SSH account username: " user
read -p "Enter remote IP address or fully qualified domain name: " address
read -p "Enter remote ssh port (press ENTER for default 22): " port

if [ -z "$port" ]; then
    port=22
fi

cat ~/.ssh/id_rsa.pub | ssh -p $port $user@$address "mkdir -p ~/.ssh && chmod 700 ~/.ssh && cat >> ~/.ssh/authorized_keys"