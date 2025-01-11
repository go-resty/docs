---
weight: 8
---

# Request Middleware

Resty provides request middleware that enables logic execution during the request preparation phase.

Out of the box, it has -

* [PrepareRequestMiddleware]({{% godoc v3 %}}PrepareRequestMiddleware)

{{% hint info %}}
* v3 introduces a fully composable middleware feature that allows the registration of request middleware in any order to accommodate practical use cases.
* v3 introduces [Request.Funcs]({{% godoc v3 %}}Request.Funcs) feature that could help to perform Request instance manipulation.
* `Request.RawRequest` instance available after `PrepareRequestMiddleware` middleware execution.
{{% /hint %}}

## Examples

### Typical Use

* Adds before the default request middleware.
* `non-nil` error return value terminates the request preparation phase.

```go
client.AddRequestMiddleware(func(c *resty.Client, req *resty.Request) error {
    // perform logic here

    return nil
})
```

### Advanced Use

* Users can register `N` of request middlewares in an appropriate order based on the use case.
* `non-nil` error return value terminates the request preparation phase.

```go
c := resty.New()
defer c.Close()

c.SetRequestMiddlewares(
    Custom1RequestMiddleware,
    Custom2RequestMiddleware,
    resty.PrepareRequestMiddleware, // after this, `Request.RawRequest` instance is available
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