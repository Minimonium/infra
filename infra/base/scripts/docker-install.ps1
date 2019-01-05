Install-PackageProvider -Name NuGet -Force
Install-Module -Name DockerMsftProvider -Force
Install-Package -Name docker -ProviderName DockerMsftProvider -Force -Verbose
Start-Service docker 
