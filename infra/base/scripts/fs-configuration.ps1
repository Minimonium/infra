$server = ${env:INFRA_FS_SERVER}
$root = ${env:INFRA_FS_ROOT}

Write-Host "Installing the NFS tools..."
Import-Module ServerManager
Install-WindowsFeature -Name FS-NFS-Service
Install-WindowsFeature -Name NFS-Client

# $line = "mklink /D C:\external \\${server}\exports\${root}\windows"
# $string = $ExecutionContext.InvokeCommand.ExpandString($line)
# cmd /c $string

# Remove-Item -r "C:\external\volumes"
# Copy-Item -r "C:\ProgramData\docker\volumes" "C:\external"
# cmd /c "mklink /D C:\ProgramData\docker\volumes_t C:\external\volumes"

# Write-Host "Mounting the folder for the user ${env:UserName}..."
# New-PSDrive -Name W -Scope Global -Persist -PsProvider FileSystem -Root \\${server}\exports\${root}\windows

# Write-Host "Stoping the Docker before linking the volumes folder..."
# Stop-Service docker

# Write-Host "Checking the previously installed link..."
# $remote = "W:\volumes"
# if (Test-Path ${remote}) {
#     Write-Host "Cleaning up the remote volumes folder..."
#     rm -r ${remote}
# }
# Write-Host "Setting up the remote volumes folder..."
# $local = "C:\ProgramData\docker\volumes"
# mv ${local} "W:\"
# rm -r ${local}

# Write-Host "Symlinking the remote volumes folder..."
# New-Item -Path ${local} -ItemType SymbolicLink -Value ${remote}

# Write-Host "Enabling back the Docker..."
# Start-Service docker
