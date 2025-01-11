
# Timeout

Resty v3 allows users to modify all timeout values utilized in the implementation.

{{% hintreqoverride %}}

## Examples

### Transport Timeouts

{{% hint info %}}
Refer to `godoc` to know all supported fields and their default values, [TransportSettings]({{% godoc v3 %}}TransportSettings).
{{% /hint %}}

```go
// create transport with timeouts
// supply only required values; the rest will use default values
transportSettings := &resty.TransportSettings{
    IdleConnTimeout:     120 * time.Second,
    TLSHandshakeTimeout: 60 * time.Second,
}

c := resty.NewWithTransportSettings(transportSettings)
defer c.Close()

// start using the client ...
```

### Client Timeout

{{% hint info %}}
Resty v3 does not use `http.Client.Timeout`.
{{% /hint %}}

```go
client.SetTimeout(2 * time.Minute)
```

### Request Timeout

{{% hint info %}}
* It overrides the client-level timeout value.
* It does not set a timeout if the user has already set a timeout/deadline.
{{% /hint %}}

```go
// set timeout for current request
client.R().
    SetTimeout(3 * time.Minute)
```

## Methods

### Transport

* [NewWithTransportSettings]({{% godoc v3 %}}NewWithTransportSettings)

### Client

* [Client.SetTimeout]({{% godoc v3 %}}Client.SetTimeout)

### Request

* [Request.SetTimeout]({{% godoc v3 %}}Request.SetTimeout)
