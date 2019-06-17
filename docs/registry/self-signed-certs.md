# How

To use the Registry with self-signed certificates it's important to add them to each node:

For Linux:

```shell
/etc/docker/certs.d/registry.${infra.domain}/ca.crt
```

For Windows:

```shell
#import cert chain
$p7b = '\\dc2012\CertEnroll\FoxDeployCAChain.p7b'
Import-Certificate -FilePath $p7b -CertStoreLocation Cert:\LocalMachine\Root
```
