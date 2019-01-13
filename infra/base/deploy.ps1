$workdir = "C:/vagrant/infra/base/scripts"

Write-Host "infra: Extending the trial..."
. $workdir/extend-the-trial.ps1

Write-Host "infra: Configurating File System..."
. $workdir/fs-configuration.ps1

Write-Host "infra: Installing Docker..."
. $workdir/docker-install.ps1

Write-Host "infra: Joining the Docker Swarm..."
. $workdir/docker-swarm-join.ps1

# Hangs on up
# Write-Host "infra: Installing Chocolatey..."
# . $workdir/chocolatey-install.ps1