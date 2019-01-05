$workdir = "C:/vagrant/infra/base/scripts"

Write-Host "Joining the Docker Swarm..."
. $workdir/docker-swarm-join.ps1

Write-Host "Setting up the Swarm Volumes..."
. $workdir/docker-swarm-volumes-init.ps1

# Write-Host "Installing Chocolatey..."
# . $workdir/chocolatey-install.ps1