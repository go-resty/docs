---
title: TLS Client Config on Custom http.RoundTripper
---

# TLS Client Config on Custom http.RoundTripper

Resty v3 provides the [TLSClientConfiger]({{% godoc v3 %}}TLSClientConfiger) interface to configure TLS client configuration for custom transports implemented using the [http.RoundTripper]({{% godoc %}}/net/http#RoundTripper) interface.

## Implement `TLSClientConfiger` interface

```go
type CustomTransport struct {
   http.RoundTripper
   resty.TLSClientConfiger
}

func (t *CustomTransport) RoundTrip(r *http.Request) (*http.Response, error) {
   // custom round trip implementation here ...

   return resp, err
}

func (t *CustomTransport) TLSClientConfig() *tls.Config {
   // return TLS config instance

   return t.tlsConfig
}

func (t *CustomTransport) SetTLSClientConfig(tlsConfig *tls.Config) error {
   // handle TLS client config here

   return nil
}
```

## Assign it to the Resty client

Subsequently, construct a transport instance and assign it to the Resty client via the method [Client.SetTransport]({{% godoc v3 %}}Client.SetTransport).

```go
transport := &CustomTransport{
    /* initialize values */
}

c := resty.New().
    SetTransport(transport)

defer c.Close()

// ...
```