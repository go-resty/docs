
# Server-Sent Events

Resty v3 adds Server-Sent Events feature. It provides APIs similar to the specification and is easy to use.

## Examples

### Get Started

```go
es := resty.NewEventSource().
    SetURL("https://sse.dev/test").
    OnMessage(func(e any) {
        fmt.Println(e.(*resty.Event))
    }, nil)

err := es.Get()
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

es := resty.NewEventSource().
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

err := es.Get()
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

es := resty.NewEventSource().
    SetURL("https://sse.dev/test").
    OnMessage(
        func(e any) {
            fmt.Println(e.(*resty.Event))
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

err := es.Get()
fmt.Println(err)
```

### OnOpen, OnError Events

```go
es := resty.NewEventSource().
    SetURL("https://sse.dev/test").
    OnMessage(
        func(e any) {
            fmt.Println(e.(*resty.Event))
        },
        nil,
    ).
    OnError(
        func(err error) {
			fmt.Println("Error occurred:", err)
		},
    ).
    OnOpen(
        func(url string) {
			fmt.Println("I'm connected:", url)
		},
    )

err := es.Get()
fmt.Println(err)

// Output:
//  I'm connected: https://sse.dev/test
//  &{  {"testing":true,"sse_dev":"is great","msg":"It works!","now":1737510458794}}
//  &{  {"testing":true,"sse_dev":"is great","msg":"It works!","now":1737510460794}}
//  &{  {"testing":true,"sse_dev":"is great","msg":"It works!","now":1737510462794}}
//  ...
```


## Methods

### EventSource

* [NewEventSource](NewEventSource)
* [EventSource.SetURL](EventSource.SetURL)
* [EventSource.SetHeader](EventSource.SetHeader)
* [EventSource.AddHeader](EventSource.AddHeader)
* [EventSource.SetRetryCount](EventSource.SetRetryCount])
* [EventSource.SetRetryWaitTime](EventSource.SetRetryWaitTime)
* [EventSource.SetRetryMaxWaitTime](EventSource.SetRetryMaxWaitTime)
* [EventSource.SetMaxBufSize](EventSource.SetMaxBufSize)
* [EventSource.SetLogger](EventSource.SetLogger)
* [EventSource.OnOpen](EventSource.OnOpen)
* [EventSource.OnError](EventSource.OnError)
* [EventSource.OnMessage](EventSource.OnMessage)
* [EventSource.AddEventListener](EventSource.AddEventListener)
* [EventSource.Get](EventSource.Get)
* [EventSource.Close](EventSource.Close)
