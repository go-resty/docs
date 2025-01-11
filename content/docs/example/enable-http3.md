
# Enable HTTP3

HTTP3 is not yet included in the Go standard packages. However, the HTTP3 package is available from the community.

Package: https://github.com/quic-go/quic-go

Documentation: https://quic-go.net/docs/

## Example

```go
c := resty.New()
defer c.Close()

// Refer to quic-go docs to customize configuration
// https://quic-go.net/docs/
roundTripper := &http3.RoundTripper{
    TLSClientConfig: &tls.Config{}, // set a TLS client config, if desired
    QUICConfig: &quic.Config{ // QUIC connection options
        MaxIdleTimeout:  45 * time.Second,
        KeepAlivePeriod: 30 * time.Second,
    },
}
defer roundTripper.Close()

c.SetTransport(roundTripper)

// You're ready to use HTTP3 with Resty
```

