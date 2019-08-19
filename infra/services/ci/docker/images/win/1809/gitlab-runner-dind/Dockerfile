FROM gitlab-runner-base:1809

LABEL maintainer="Alexandr Timofeev <alexandr.p.timofeev@gmail.com>"

SHELL ["powershell.exe", "-ExecutionPolicy", "Bypass", "-Command"]

# Docker
RUN (New-Object System.Net.WebClient).DownloadFile('https://dockermsft.blob.core.windows.net/dockercontainer/docker-19-03-1.zip', 'docker-19.03.1.zip'); \
    #RUN Start-BitsTransfer -Source https://dockermsft.blob.core.windows.net/dockercontainer/docker-19-03-1.zip -Destination docker-19.03.1.zip; \
    Expand-Archive 'docker-19.03.1.zip' -DestinationPath $Env:ProgramFiles -Force; \
    Remove-Item -Force 'docker-19.03.1.zip'; \
    $env:path += (';' + $env:ProgramFiles + '\\docker'); \
    $newPath = ($env:ProgramFiles + '\\docker;') + [Environment]::GetEnvironmentVariable('PATH', [EnvironmentVariableTarget]::Machine); \
    [Environment]::SetEnvironmentVariable('PATH', $newPath, [EnvironmentVariableTarget]::Machine);
#     dockerd --register-service; \
#     Set-Service docker -StartupType Automatic; \
#     Start-Service docker; \
#     docker version;

ENTRYPOINT ["gitlab-runner.exe"]
CMD ["run"]
