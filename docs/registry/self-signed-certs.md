# How

To use the Registry with self-signed certificates it's important to add them to each node:

For Linux:

```bash
/etc/docker/certs.d/registry.${infra.domain}/ca.crt
```

For Windows:

```powershell
Import-Certificate -FilePath "C:\vagrant\..." -CertStoreLocation Cert:\LocalMachine\Root
```
