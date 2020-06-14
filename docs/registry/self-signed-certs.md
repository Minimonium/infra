# Certificates

## Creation

To create a certificate - run:

```bash
openssl req -x509 -sha256 -nodes -newkey rsa:4096 -keyout infra.key -out infra.crt -days 365
```

> Note that we use `-nodes` to not require a password to not pass it to Traefik

## Usage

To use the Registry with self-signed certificates it's important to add them to each node:

For Linux:

```bash
/etc/docker/certs.d/registry.${infra.domain}/ca.crt
```

For Windows:

```powershell
Import-Certificate -FilePath "C:\vagrant\..." -CertStoreLocation Cert:\LocalMachine\Root
```
