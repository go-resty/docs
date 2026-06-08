
# Server-Sent Events

Resty v3 adds Server-Sent Events feature. It provides APIs similar to the [specification](https://html.spec.whatwg.org/multipage/server-sent-events.html) and is easy to use.

## Examples

### Get Started

```go
sse := resty.NewSSESource().
    SetURL("https://sse.dev/test").
    OnMessage(func(e any) {
        fmt.Println(e.(*resty.SSE))
    }, nil)

err := sse.Get()
fmt.Println(err)
```

### Auto Unmarshalling

```go
// https://sse.dev/test returns
// {"testing":true,"sse_dev":"is great","msg":"It works!","now":1737508994502}
type Data struct {
    Testing bool   `json:"testing"`
    SSEDev  string `json:"sse_dev"`
    Message string `json:"msg"`
    Now     int64  `json:"now"`
}

sse := resty.NewSSESource().
    SetURL("https://sse.dev/test").
    OnMessage(
        func(e any) {
            d := e.(*Data)
            fmt.Println("Testing:", d.Testing)
            fmt.Println("SSEDev:", d.SSEDev)
            fmt.Println("Message:", d.Message)
            fmt.Println("Now:", d.Now)
            fmt.Println("")
        },
        Data{},
    )

err := sse.Get()
fmt.Println(err)

// Output:
//     Testing: true
//     SSEDev: is great
//     Message: It works!
//     Now: 1737509497652

//     Testing: true
//     SSEDev: is great
//     Message: It works!
//     Now: 1737509499652

//     ...
```


### Multiple Event Types

```go
type UserEvent struct {
    UserName string    `json:"username"`
    Message  string    `json:"msg"`
    Time     time.Time `json:"time"`
}

sse := resty.NewSSESource().
    SetURL("https://sse.dev/test").
    OnMessage(
        func(e any) {
            fmt.Println(e.(*resty.SSE))
        },
        nil,
    ).
    AddEventListener(
        "user_connect",
        func(e any) {
            fmt.Println(e.(*UserEvent))
        },
        UserEvent{},
    ).
    AddEventListener(
        "user_message",
        func(e any) {
            fmt.Println(e.(*UserEvent))
        },
        UserEvent{},
    )

err := sse.Get()
fmt.Println(err)
```

### TLS Client Config

The method sets TLSClientConfig for underlying SSE client Transport. Values supported by {{% param Resty.GoDoc %}}/crypto/tls#Config can be configured.

```go
cer, err := tls.LoadX509KeyPair("server.crt", "server.key")
if err != nil {
    log.Println(err)
    return
}

es.SetTLSClientConfig(&tls.Config{
    Certificates: []tls.Certificate{cer}
})
```


### OnOpen, OnError Events

```go
sse := resty.NewSSESource().
    SetURL("https://sse.dev/test").
    OnMessage(
        func(e any) {
            fmt.Println(e.(*resty.SSE))
        },
        nil,
    ).
    OnError(
        func(err error) {
			fmt.Println("Error occurred:", err)
		},
    ).
    OnOpen(
        func(url string, resHdr http.Header) {
            fmt.Println("I'm connected:", url, resHdr)
        },
    )

err := sse.Get()
fmt.Println(err)

// Output:
// I'm connected: https://sse.dev/test map[Access-Control-Allow-Origin:[*] Cache-Control:[no-cache] Connection:[keep-alive] Content-Type:[text/event-stream] Date:[Sun, 14 Dec 2025 06:29:46 GMT] Server:[nginx/1.27.5]]
// &{  {"testing":true,"sse_dev":"is great","msg":"It works!","now":1765693786165}}
// &{  {"testing":true,"sse_dev":"is great","msg":"It works!","now":1765693788165}}
// &{  {"testing":true,"sse_dev":"is great","msg":"It works!","now":1765693790165}}
//  ...
```

### OnRequestFailure Event

The OnRequestFailure callback gets triggered when the HTTP request fails while establishing an SSE connection.

> [!NOTE]
> **NOTE:**
> * Do not forget to close the HTTP response body.
> * HTTP response may be nil.

```go
sse := resty.NewSSESource().
    SetURL("https://sse.dev/test").
    OnRequestFailure(
        func(err error, res *http.Response) {
            defer res.Body.Close()
            resBody, _ := io.ReadAll(res.Body)

            fmt.Println(err, string(resBody))
        },
    )

err := sse.Get()
fmt.Println(err)
```


## Methods

### SSESource

* [NewSSESource]({{% godoc v3 %}}NewSSESource)
* [SSESource.SetURL]({{% godoc v3 %}}SSESource.SetURL)
* [SSESource.SetHeader]({{% godoc v3 %}}SSESource.SetHeader)
* [SSESource.AddHeader]({{% godoc v3 %}}SSESource.AddHeader)
* [SSESource.SetRetryCount]({{% godoc v3 %}}SSESource.SetRetryCount)
* [SSESource.SetRetryWaitTime]({{% godoc v3 %}}SSESource.SetRetryWaitTime)
* [SSESource.SetRetryMaxWaitTime]({{% godoc v3 %}}SSESource.SetRetryMaxWaitTime)
* [SSESource.SetSizeMaxBuffer]({{% godoc v3 %}}SSESource.SetSizeMaxBuffer)
* [SSESource.TLSClientConfig]({{% godoc v3 %}}SSESource.TLSClientConfig)
* [SSESource.SetTLSClientConfig]({{% godoc v3 %}}SSESource.SetTLSClientConfig)
* [SSESource.Logger]({{% godoc v3 %}}SSESource.Logger)
* [SSESource.SetLogger]({{% godoc v3 %}}SSESource.SetLogger)
* [SSESource.OnOpen]({{% godoc v3 %}}SSESource.OnOpen)
* [SSESource.OnError]({{% godoc v3 %}}SSESource.OnError)
* [SSESource.OnRequestFailure]({{% godoc v3 %}}SSESource.OnRequestFailure)
* [SSESource.OnMessage]({{% godoc v3 %}}SSESource.OnMessage)
* [SSESource.AddEventListener]({{% godoc v3 %}}SSESource.AddEventListener)
* [SSESource.Get]({{% godoc v3 %}}SSESource.Get)
* [SSESource.Close]({{% godoc v3 %}}SSESource.Close)
