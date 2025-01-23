
# Request Tracing

Request tracing is often utilized to collect information about HTTP requests. Resty offers simple access to this information. These details include:

* DNS Lookup Time
* Connection Time
* TCP Connection Time
* TLS Handshake Time
* Server Time
* Response Time
* Total Time
* Is Connection Reused
* Is Connection Was Idle
* Connection IdleTime
* Request Attempt
* Remote Address

```go
// create a Resty client
client := resty.New()
defer client.Close()

res, _ = client.R().
    EnableTrace().
    Get("https://httpbin.org/get")

ti := res.Request.TraceInfo()

// Explore trace info
fmt.Println("Request Trace Info:")
fmt.Println("  DNSLookup     :", ti.DNSLookup)
fmt.Println("  ConnTime      :", ti.ConnTime)
fmt.Println("  TCPConnTime   :", ti.TCPConnTime)
fmt.Println("  TLSHandshake  :", ti.TLSHandshake)
fmt.Println("  ServerTime    :", ti.ServerTime)
fmt.Println("  ResponseTime  :", ti.ResponseTime)
fmt.Println("  TotalTime     :", ti.TotalTime)
fmt.Println("  IsConnReused  :", ti.IsConnReused)
fmt.Println("  IsConnWasIdle :", ti.IsConnWasIdle)
fmt.Println("  ConnIdleTime  :", ti.ConnIdleTime)
fmt.Println("  RequestAttempt:", ti.RequestAttempt)
fmt.Println("  RemoteAddr    :", ti.RemoteAddr.String())

// Output
// Request Trace Info:
//   DNSLookup     : 2.947333ms
//   ConnTime      : 198.844375ms
//   TCPConnTime   : 63.088834ms
//   TLSHandshake  : 132.341ms
//   ServerTime    : 64.945166ms
//   ResponseTime  : 74.625µs
//   TotalTime     : 263.774083ms
//   IsConnReused  : false
//   IsConnWasIdle : false
//   ConnIdleTime  : 0s
//   RequestAttempt: 1
//   RemoteAddr    : 3.210.94.60:443
```

## Methods

### Client

* [Client.SetTrace]({{% godoc v3 %}}Client.SetTrace)
* [Client.EnableTrace]({{% godoc v3 %}}Client.EnableTrace)
* [Client.DisableTrace]({{% godoc v3 %}}Client.DisableTrace)

### Request

* [Request.SetTrace]({{% godoc v3 %}}Request.SetTrace)
* [Request.EnableTrace]({{% godoc v3 %}}Request.EnableTrace)
* [Request.DisableTrace]({{% godoc v3 %}}Request.DisableTrace)

### Trace

* [TraceInfo.String]({{% godoc v3 %}}TraceInfo.String)
