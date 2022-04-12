# Docker Registry Clean Up

To clean up untagged images, deleted from the interface you can run:

```bash
docker exec <container_id> bin/registry garbage-collect /etc/docker/registry/config.yml -m
```
