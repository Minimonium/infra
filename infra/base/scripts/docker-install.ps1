Write-Host "Installing Docker..."

# See: https://docs.docker.com/install/windows/docker-ee/

# ----------------------------------------

docker swarm leave --force

Stop-Service docker

dockerd --unregister-service

Get-HNSNetwork | Remove-HNSNetwork
Remove-Item -Path "$env:ProgramFiles\docker" -Recurse -Force

# See versions at: https://dockermsft.blob.core.windows.net/dockercontainer/DockerMsftIndex.json
Start-BitsTransfer -Source https://dockermsft.blob.core.windows.net/dockercontainer/docker-19-03-1.zip -Destination docker-19.03.1.zip
#Invoke-WebRequest -UseBasicParsing -OutFile "docker-19.03.1.zip" "https://download.docker.com/components/engine/windows-server/19.03/docker-19.03.1.zip"

Expand-Archive "docker-19.03.1.zip" -DestinationPath $Env:ProgramFiles -Force

Remove-Item -Force "docker-19.03.1.zip"

# Install Docker. This requires rebooting.
$null = Install-WindowsFeature containers

# Add Docker to the path for the current session.
$env:path += ";$env:ProgramFiles\docker"

# Optionally, modify PATH to persist across sessions.
$newPath = "$env:ProgramFiles\docker;" +
[Environment]::GetEnvironmentVariable("PATH",
[EnvironmentVariableTarget]::Machine)

[Environment]::SetEnvironmentVariable("PATH", $newPath,
[EnvironmentVariableTarget]::Machine)

# Register the Docker daemon as a service.
dockerd --register-service

# ----------------------------------------

#Find-PackageProvider DockerMsftProvider | Install-PackageProvider -Force
#Install-PackageProvider -Name NuGet -Force

#Find-PackageProvider DockerMsftProvider | Install-PackageProvider -Force
#Install-Package -Name docker -ProviderName DockerMsftProvider -Force -Verbose

# ----------------------------------------

Set-Service docker -StartupType Automatic
Start-Service docker

docker version
