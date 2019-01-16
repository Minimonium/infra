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
RUN choco install --no-progress --yes --execution-timeout=0 visualstudio2017buildtools; \
    choco install --no-progress --yes --execution-timeout=0 visualstudio2017-workload-vctools; \
    choco install --no-progress --yes --execution-timeout=0 visualstudio2017-workload-nativedesktop; \
    choco install --no-progress --yes --execution-timeout=0 visualstudio2017-workload-visualstudioextension --params "--includeRecommended --includeOptional";
# RUN choco install visualstudio2017buildtools --no-progress --yes --package-parameters "--passive --add Microsoft.VisualStudio.Workload.MSBuildTools --add Microsoft.VisualStudio.Workload.VCTools --includeRecommended --includeOptional --locale en-US"

# Conan
RUN python -m pip install --quiet --upgrade pip; \
    python -m pip install win-unicode-console --quiet --upgrade --force-reinstall --no-cache; \
    python -m pip install conan --quiet --upgrade --force-reinstall --no-cache; \
    python -m pip install conan_package_tools --quiet --upgrade --force-reinstall --no-cache

# Gitlab-Runner
RUN choco install --no-progress --yes gitlab-runner --params '"/InstallDir:C:\gitlab-runner"';

# Fix to make Gitlab-Runner Run work
RUN net accounts /MaxPWAge:unlimited; \
    net user build_user /add; \
    net localgroup Administrators /add build_user
USER build_user
WORKDIR "C:/Users/build_user"

ENTRYPOINT ["gitlab-runner.exe"]
CMD ["run"]
