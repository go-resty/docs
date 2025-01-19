
# Server-Sent Events

Resty v3 adds Server-Sent Events feature. It provides APIs similar to the specification and is easy to use.

## Examples

```go
es := NewEventSource().
    SetURL("https://sse.dev/test").
    OnMessage(func(a any) {
        fmt.Println(a.(*resty.Event))
    }, nil)

err := es.Get()
fmt.Println(err)
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
