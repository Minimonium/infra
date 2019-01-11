$workdir = "C:/vagrant/infra/base/scripts"

Write-Host "infra: Mounting the Cache..."
. $workdir/nfs-mount.ps1

Write-Host "infra: Installing Docker..."
. $workdir/docker-install.ps1

Write-Host "infra: Joining the Docker Swarm..."
. $workdir/docker-swarm-join.ps1

# Write-Host "infra: Installing Chocolatey..."
# . $workdir/chocolatey-install.ps1