$server = ${Env:INFRA_FS_SERVER}
$root = ${Env:INFRA_FS_ROOT}

Import-Module ServerManager
Install-WindowsFeature -Name FS-NFS-Service
Install-WindowsFeature -Name NFS-Client

New-PSDrive W -PsProvider FileSystem -Root \\{server}\exports\${root}\windows -Persist
New-Item -Path "C:\ProgramData\docker" -type directory
New-Item -Path "C:\ProgramData\docker\volumes" -ItemType SymbolicLink -Value "W:\"
