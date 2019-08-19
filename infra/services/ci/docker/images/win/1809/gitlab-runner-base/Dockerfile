FROM mcr.microsoft.com/windows/servercore:1809

LABEL maintainer="Alexandr Timofeev <alexandr.p.timofeev@gmail.com>"

SHELL ["powershell.exe", "-ExecutionPolicy", "Bypass", "-Command"]

ENV chocolateyUseWindowsCompression=false \
    PYTHONIOENCODING=UTF-8

# Install Choco
RUN Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Gitlab-Runner
RUN choco install --no-progress --yes gitlab-runner --params '"/InstallDir:C:\gitlab-runner"';

# Fix to make Gitlab-Runner Run work
RUN net accounts /MaxPWAge:unlimited; \
    net user build_user /add; \
    net localgroup Administrators /add build_user
USER build_user
WORKDIR "C:/Users/build_user"
