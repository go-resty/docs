---
weight: 8
---

# Request Middleware

Resty provides request middleware that enables logic execution during the request preparation phase.

Out of the box, Resty provides:

* [MiddlewareRequestCreate]({{% godoc v3 %}}MiddlewareRequestCreate)

> [!NOTE]
> * v3 introduces a fully composable middleware feature that allows the registration of request middleware in any order to accommodate practical use cases.
> * v3 introduces the [Request.Funcs]({{% godoc v3 %}}Request.Funcs) feature, which can help with request instance manipulation.
> * The `Request.RawRequest` instance is available after `MiddlewareRequestCreate` middleware execution.

## Examples

### Typical Use

* Adds middleware before the default request middleware.
* `non-nil` error return value terminates the request preparation phase.

```go
client.AddRequestMiddleware(func(c *resty.Client, req *resty.Request) error {
    // perform logic here

    return nil
})
```

### Advanced Use

* Users can register `N` request middleware functions in an order appropriate for the use case.
* `non-nil` error return value terminates the request preparation phase.

```go
c := resty.New()
defer c.Close()

c.SetRequestMiddlewares(
    Custom1RequestMiddleware,
    Custom2RequestMiddleware,
    resty.MiddlewareRequestCreate, // after this, `Request.RawRequest` instance is available
    Custom3RequestMiddleware,
    Custom4RequestMiddleware,
)
```


## Methods

* [RequestMiddleware]({{% godoc v3 %}}RequestMiddleware)
* [RequestFunc]({{% godoc v3 %}}RequestFunc)

### Client

* [Client.AddRequestMiddleware]({{% godoc v3 %}}Client.AddRequestMiddleware)
* [Client.SetRequestMiddlewares]({{% godoc v3 %}}Client.SetRequestMiddlewares)

### Request

* [Request.Funcs]({{% godoc v3 %}}Request.Funcs)