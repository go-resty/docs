---
weight: 8
---

# Response Middleware

Resty provides response middleware that enables the execution of logic after receiving the request response.

Out of the box, it has -

* [MiddlewareResponseAutoParse]({{% godoc v3 %}}MiddlewareResponseAutoParse)
* [MiddlewareResponseSaveToFile]({{% godoc v3 %}}MiddlewareResponseSaveToFile)

> [!NOTE]
> * v3 introduces a fully composable middleware feature that allows the registration of response middleware in any order to accommodate practical use cases.
> * v3 introduces the capability to cascade an error within the response middleware execution chain.

## Examples

### Typical Use

* Adds after the default response middleware.
* Cascades response middleware returned `error` downstream via `Response.CascadeError`

```go
client.AddResponseMiddleware(func(c *resty.Client, res *resty.Response) error {
    // perform logic here

    // cascade error downstream
    // return errors.New("hey error occurred")

    return nil
})
```

### Advanced Use

* Cascades response middleware returned `error` downstream via `Response.CascadeError`

```go
c := resty.New()
defer c.Close()

c.SetResponseMiddlewares(
    Custom1ResponseMiddleware,
    Custom2ResponseMiddleware,
    resty.MiddlewareResponseAutoParse, // before this, the body is not read except on the debug flow
    Custom3ResponseMiddleware,
    resty.MiddlewareResponseSaveToFile, // See, Request.SetResponseSaveFileName & Request.SetResponseSaveToFile
    Custom4ResponseMiddleware,
    Custom5ResponseMiddleware,
)
```

## Methods

* [ResponseMiddleware]({{% godoc v3 %}}ResponseMiddleware)

### Client

* [Client.AddResponseMiddleware]({{% godoc v3 %}}Client.AddResponseMiddleware)
* [Client.SetResponseMiddlewares]({{% godoc v3 %}}Client.SetResponseMiddlewares)