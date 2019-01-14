FROM microsoft/dotnet-framework:latest

LABEL maintainer="Alexandr Timofeev <alexandr.p.timofeev@gmail.com>"

SHELL ["powershell.exe", "-ExecutionPolicy", "Bypass", "-Command"]

ENV chocolateyUseWindowsCompression=false \
    PYTHONIOENCODING=UTF-8

# Tools
RUN iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1')); \
    $env:Path += '";C:\tools\python3;C:\tools\python3\Scripts"'; \
    choco install --no-progress --yes git --params '"/InstallDir:C:\tools\git"'; \
    choco install --no-progress --yes nsis --params '"/InstallDir:C:\tools\nsis"'; \
    choco install --no-progress --yes cmake --params '"/InstallDir:C:\tools\cmake"' --installargs 'ADD_CMAKE_TO_PATH=""System""'; \
    choco install --no-progress --yes python3 --params '"/InstallDir:C:\tools\python3"'

# MSVC
RUN choco install --no-progress --yes visualstudio2017buildtools --params "--includeOptional"; \
    choco install --no-progress --yes --execution-timeout=0 visualstudio2017-workload-vctools --params "--includeOptional";

# Conan
RUN python -m pip install --quiet --upgrade pip; \
    python -m pip install win-unicode-console --quiet --upgrade --force-reinstall --no-cache; \
    python -m pip install conan --quiet --upgrade --force-reinstall --no-cache; \
    python -m pip install conan_package_tools --quiet --upgrade --force-reinstall --no-cache

# Gitlab-Runner
RUN choco install -y gitlab-runner

WORKDIR "C:/Users/ContainerAdministrator"

ENTRYPOINT ["gitlab-runner", "run", "-c", "C:\config.toml"]
