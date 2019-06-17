# Using a Standalone Private Registry

You need to create a CI variable `DOCKER_AUTH_CONFIG` and copy the contents of the `docker/config.json` file:

```json
{
        "auths": {
                "registry.${infra.domain}": {
                        "auth": "TOKEN"
                }
        }
}
```

Reference:
[Gitlab Documentation](https://docs.gitlab.com/runner/configuration/advanced-configuration.html#using-a-private-container-registry)
