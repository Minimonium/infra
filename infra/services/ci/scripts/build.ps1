docker build -t gitlab-runner-base:1809 -m 2GB ${workdir}/docker/images/win/1809/gitlab-runner-base
docker build -t gitlab-runner:1809 -m 2GB ${workdir}/docker/images/win/1809/gitlab-runner
docker build -t gitlab-runner-dind:1809 -m 2GB ${workdir}/docker/images/win/1809/gitlab-runner-dind
