---
weight: 5
---

# Client and Client Root Certificates

Resty offers a convenient method to add `client` and `client root` certificates.

{{% hint info %}}
* Starting v3, Resty lets a watcher reload certificates dynamically at configured intervals.
* Default watcher reload interval is 24 hours
{{% /hint %}}

## Examples

### Client Certificates

#### From File

```go
// one pem file path
client.SetClientCertificates("/path/to/client/pemFile.pem")

// one or more pem file path(s)
client.SetClientCertificates(
    "/path/to/client/pemFile1.pem",
    "/path/to/client/pemFile2.pem"
    "/path/to/client/pemFile3.pem"
)

// if you happen to have string slices
client.SetClientCertificates(certs...)
```

#### From File with Watcher

```go
// create cert watcher options
certWatcherOpts := &resty.CertWatcherOptions{
    PoolInterval: 12 * time.Hour, // default value is 24 hours
}

// one pem file path
client.SetClientCertificatesWatcher(certWatcherOpts, "/path/to/client/pemFile.pem")

// one or more pem file path(s)
client.SetClientCertificatesWatcher(
    certWatcherOpts,
    "/path/to/client/pemFile1.pem",
    "/path/to/client/pemFile2.pem"
    "/path/to/client/pemFile3.pem"
)

// if you happen to have slices
client.SetClientCertificatesWatcher(certWatcherOpts, certs...)
```

#### From String

```go
myClientCertStr := `-----BEGIN CERTIFICATE-----
... cert content ...
-----END CERTIFICATE-----`

client.SetClientCertificateFromString(myClientCertStr)
```

### Client Root Certificates

#### From File

```go
// one pem file path
client.SetClientRootCertificates("/path/to/client-root/pemFile.pem")

// one or more pem file path(s)
client.SetClientRootCertificates(
    "/path/to/client-root/pemFile1.pem",
    "/path/to/client-root/pemFile2.pem"
    "/path/to/client-root/pemFile3.pem"
)

// if you happen to have slices
client.SetClientRootCertificates(certs...)
```

#### From File with Watcher

```go
// create cert watcher options
certWatcherOpts := &resty.CertWatcherOptions{
    PoolInterval: 12 * time.Hour, // default value is 24 hours
}

// one pem file path
client.SetClientRootCertificatesWatcher(certWatcherOpts, "/path/to/client-root/pemFile.pem")

// one or more pem file path(s)
client.SetClientRootCertificatesWatcher(
    certWatcherOpts,
    "/path/to/client-root/pemFile1.pem",
    "/path/to/client-root/pemFile2.pem"
    "/path/to/client-root/pemFile3.pem"
)

// if you happen to have slices
client.SetClientRootCertificatesWatcher(certWatcherOpts, certs...)
```

#### From String

```go
myClientRootCertStr := `-----BEGIN CERTIFICATE-----
... cert content ...
-----END CERTIFICATE-----`

client.SetClientRootCertificateFromString(myClientRootCertStr)
```

## Methods

### Client Certificates

* [Client.SetClientCertificates]({{% godoc v3 %}}Client.SetClientCertificates)
* [Client.SetClientCertificatesWatcher]({{% godoc v3 %}}Client.SetClientCertificatesWatcher)
* [Client.SetClientCertificateFromString]({{% godoc v3 %}}Client.SetClientCertificateFromString)

### Client Root Certificates

* [Client.SetClientRootCertificates]({{% godoc v3 %}}Client.SetClientRootCertificates)
* [Client.SetClientRootCertificatesWatcher]({{% godoc v3 %}}Client.SetClientRootCertificatesWatcher)
* [Client.SetClientRootCertificateFromString]({{% godoc v3 %}}Client.SetClientRootCertificateFromString)
