# Generating .htpasswd

You need to add a `-B` flag to force bcrypt

```bash
docker run --entrypoint htpasswd registry:2 -Bbn testuser testpassword > auth/htpasswd
```
