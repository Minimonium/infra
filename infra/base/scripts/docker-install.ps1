Write-Host "Installing Docker..."

#Find-PackageProvider DockerMsftProvider | Install-PackageProvider -Force
Install-PackageProvider -Name NuGet -Force
#Install-Module -Name DockerMsftProvider -Force
New-Item -ItemType Directory -Force -Path C:\Users\vagrant\AppData\Local\Temp\DockerMsftProvider\
Write-Host "Start-BitsTransfer..."
Start-BitsTransfer -Source https://dockermsft.blob.core.windows.net/dockercontainer/docker-19-03-1.zip -Destination C:\Users\vagrant\AppData\Local\Temp\DockerMsftProvider\Docker-19-03-1.zip
Write-Host "Get-FileHash..."
Get-FileHash -Path C:\Users\vagrant\AppData\Local\Temp\DockerMsftProvider\Docker-19-03-1.zip -Algorithm SHA256

Install-Package -Name docker -ProviderName DockerMsftProvider -Force -Verbose

Set-Service docker -StartupType Automatic
Start-Service docker
