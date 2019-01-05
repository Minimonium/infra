param( $address = "127.0.0.1", $port = "55985" )

# default creds
$secpasswd = ConvertTo-SecureString "vagrant" -AsPlainText -Force;
$vagrantcred = New-Object System.Management.Automation.PSCredential ("vagrant", $secpasswd);

Enter-PSSession -ComputerName $address -Port $port -Credential $vagrantcred;