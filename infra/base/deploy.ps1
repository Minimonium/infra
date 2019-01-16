$workdir = "C:/vagrant/infra/base"

Write-Host "infra: Extending the trial..."
. $workdir/scripts/extend-the-trial.ps1

# Docker don't want to work with NFS on windows
# Write-Host "infra: Configurating File System..."
# . $workdir/scripts/fs-configuration.ps1

Write-Host "infra: Installing Docker..."
. $workdir/scripts/docker-install.ps1

Write-Host "infra: Joining the Docker Swarm..."
. $workdir/scripts/docker-swarm-join.ps1

# Hangs on up
# Write-Host "infra: Installing Chocolatey..."
# . $workdir/chocolatey-install.ps1