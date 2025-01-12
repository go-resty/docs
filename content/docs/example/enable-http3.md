---
title: Enable HTTP3
---

# Enable HTTP3

HTTP3 is not yet included in the Go standard packages. However, the HTTP3 package is available from the community.

Package: [github.com/quic-go/quic-go](https://github.com/quic-go/quic-go)

Documentation: https://quic-go.net/docs/

## Example

```go
// Refer to quic-go docs to customize configuration
// https://quic-go.net/docs/
http3Transport := &http3.Transport{
    TLSClientConfig: &tls.Config{}, // set a TLS client config, if desired
    QUICConfig: &quic.Config{ // QUIC connection options
        MaxIdleTimeout:  45 * time.Second,
        KeepAlivePeriod: 30 * time.Second,
    },
}
defer http3Transport.Close()

c := resty.New().
    SetTransport(http3Transport)
defer c.Close()

// You're ready to use HTTP3 with Resty
```

