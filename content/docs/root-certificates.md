---
weight: 4
---

# Root Certificates

Resty offers a convenient method to add `root` certificates.

{{% hint info %}}
* Starting v3, Resty lets a watcher reload certificates dynamically at configured intervals if modified.
* Default watcher reload interval is 24 hours
{{% /hint %}}

## Examples

### From File

```go
// one pem file path
client.SetRootCertificates("/path/to/root/pemFile.pem")

// one or more pem file path(s)
client.SetRootCertificates(
    "/path/to/root/pemFile1.pem",
    "/path/to/root/pemFile2.pem"
    "/path/to/root/pemFile3.pem"
)

// if you happen to have string slices
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

// one or more pem file path(s)
client.SetRootCertificatesWatcher(
    certWatcherOpts,
    "/path/to/root/pemFile1.pem",
    "/path/to/root/pemFile2.pem"
    "/path/to/root/pemFile3.pem"
)

// if you happen to have string slices
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
