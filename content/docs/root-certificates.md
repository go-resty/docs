---
weight: 5
---

# Root Certificates

Resty offers a convenient method to add `root` certificates.

> [!NOTE]
> * Starting in v3, Resty can use a watcher to reload certificates dynamically at configured intervals when files are modified.
> * Default watcher reload interval is 24 hours.

## Examples

### From File

```go
// one pem file path
client.SetRootCertificates("/path/to/root/pemFile.pem")

// one or more PEM file paths
client.SetRootCertificates(
    "/path/to/root/pemFile1.pem",
    "/path/to/root/pemFile2.pem",
    "/path/to/root/pemFile3.pem"
)

// if you already have a string slice
client.SetRootCertificates(certs...)
```

### From File with Watcher

```go
// create cert watcher options
certWatcherOpts := &resty.CertWatcherOptions{
    PoolInterval: 12 * time.Hour, // default value is 24 hours
}

// one pem file path
client.SetRootCertificatesWatcher(certWatcherOpts, "/path/to/root/pemFile.pem")

// one or more PEM file paths
client.SetRootCertificatesWatcher(
    certWatcherOpts,
    "/path/to/root/pemFile1.pem",
    "/path/to/root/pemFile2.pem",
    "/path/to/root/pemFile3.pem"
)

// if you already have a string slice
client.SetRootCertificatesWatcher(certWatcherOpts, certs...)
```

### From String

```go
myRootCertStr := `-----BEGIN CERTIFICATE-----
... cert content ...
-----END CERTIFICATE-----`

client.SetRootCertificateFromString(myRootCertStr)
```

## Methods

* [Client.SetRootCertificates]({{% godoc v3 %}}Client.SetRootCertificates)
* [Client.SetRootCertificatesWatcher]({{% godoc v3 %}}Client.SetRootCertificatesWatcher)
* [Client.SetRootCertificateFromString]({{% godoc v3 %}}Client.SetRootCertificateFromString)
