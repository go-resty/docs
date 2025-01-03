---
weight: 6
---

# Client Certificates

Resty provides a convenient method to add `client` certificates for SSL Client authentication.

## Examples

### From File

```go
// pass the public/private key pair file paths.
// the files must contain PEM-encoded data
client.SetCertificateFromFile("certs/client.pem", "certs/client.key")
```

### From String

```go
myClientCertStr := `-----BEGIN CERTIFICATE-----
... cert content ...
-----END CERTIFICATE-----`

myClientCertKeyStr := `-----BEGIN CERTIFICATE-----
... cert key content ...
-----END CERTIFICATE-----`

client.SetCertificateFromString(myClientCertStr, myClientCertKeyStr)
```

### From Certificates

```go
// loading public/private key pair from files. The files must contain PEM-encoded data.
cert, err := tls.LoadX509KeyPair("certs/client.pem", "certs/client.key")
if err != nil {
    log.Printf("ERROR while loading client certificate: %v", err)
    return
}

// add client certificate
client.SetCertificates(cert)

// ...
// add one or more certificates
client.SetCertificates(cert1, cert2, cert3)
```

## Methods

* [Client.SetCertificates](Client.SetCertificates)
* [Client.SetCertificateFromFile](Client.SetCertificateFromFile)
* [Client.SetCertificateFromString](Client.SetCertificateFromString)