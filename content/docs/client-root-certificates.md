---
weight: 6
---

# Client Root Certificates

Resty offers a convenient method to add `client root` certificates.

> [!NOTE]
> * Starting in v3, Resty can use a watcher to reload certificates dynamically at configured intervals when files are modified.
> * Default watcher reload interval is 24 hours.

## Examples

### From File

```go
// one pem file path
client.SetClientRootCertificates("/path/to/client-root/pemFile.pem")

// one or more PEM file paths
client.SetClientRootCertificates(
    "/path/to/client-root/pemFile1.pem",
    "/path/to/client-root/pemFile2.pem",
    "/path/to/client-root/pemFile3.pem"
)

// if you already have a string slice
client.SetClientRootCertificates(certs...)
```

### From File with Watcher

```go
// create cert watcher options
certWatcherOpts := &resty.CertWatcherOptions{
    PoolInterval: 12 * time.Hour, // default value is 24 hours
}

// one pem file path
client.SetClientRootCertificatesWatcher(certWatcherOpts, "/path/to/client-root/pemFile.pem")

// one or more PEM file paths
client.SetClientRootCertificatesWatcher(
    certWatcherOpts,
    "/path/to/client-root/pemFile1.pem",
    "/path/to/client-root/pemFile2.pem",
    "/path/to/client-root/pemFile3.pem"
)

// if you already have a string slice
client.SetClientRootCertificatesWatcher(certWatcherOpts, certs...)
```

### From String

```go
myClientRootCertStr := `-----BEGIN CERTIFICATE-----
... cert content ...
-----END CERTIFICATE-----`

client.SetClientRootCertificateFromString(myClientRootCertStr)
```

## Methods

* [Client.SetClientRootCertificates]({{% godoc v3 %}}Client.SetClientRootCertificates)
* [Client.SetClientRootCertificatesWatcher]({{% godoc v3 %}}Client.SetClientRootCertificatesWatcher)
* [Client.SetClientRootCertificateFromString]({{% godoc v3 %}}Client.SetClientRootCertificateFromString)
