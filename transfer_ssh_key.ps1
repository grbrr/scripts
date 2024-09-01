$user = Read-Host "Enter SSH account username"
$address = Read-Host "Enter remote IP address or fully qualified domain name"
$port = Read-Host -Prompt 'Enter remote ssh port (press ENTER for default 22)'
if ([string]::IsNullOrWhiteSpace($port))
{
    $port = 22
}

Get-Content ~/.ssh/id_rsa.pub | ssh $user@$address -p $port "mkdir -p ~/.ssh && chmod 700 ~/.ssh && cat >>  ~/.ssh/authorized_keys"