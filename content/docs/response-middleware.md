---
weight: 8
---

# Response Middleware

Resty provides response middleware that enables the execution of logic after receiving the request response.

Out of the box, it has -

* [AutoParseResponseMiddleware]({{% godoc v3 %}}AutoParseResponseMiddleware)
* [SaveToFileResponseMiddleware]({{% godoc v3 %}}SaveToFileResponseMiddleware)

> [!NOTE]
> * v3 introduces a fully composable middleware feature that allows the registration of response middleware in any order to accommodate practical use cases.
> * v3 introduces the capability to cascade an error within the response middleware execution chain.

## Examples

### Typical Use

* Adds after the default response middleware.
* Cascades response middleware returned `error` downstream via `Respose.Err`

```go
client.AddResponseMiddleware(func(c *resty.Client, res *resty.Response) error {
    // perform logic here

    // cascade error downstream
    // return errors.New("hey error occurred")

    return nil
})
```

### Advanced Use

* Cascades response middleware returned `error` downstream via `Respose.Err`

```go
c := resty.New()
defer c.Close()

c.SetResponseMiddlewares(
    Custom1ResponseMiddleware,
    Custom2ResponseMiddleware,
    resty.AutoParseResponseMiddleware, // before this, the body is not read except on the debug flow
    Custom3ResponseMiddleware,
    resty.SaveToFileResponseMiddleware, // See, Request.SetOutputFileName & Request.SetSaveResponse
    Custom4ResponseMiddleware,
    Custom5ResponseMiddleware,
)
```

## Methods

* [ResponseMiddleware]({{% godoc v3 %}}ResponseMiddleware)

### Cilent

* [Client.AddResponseMiddleware]({{% godoc v3 %}}Client.AddResponseMiddleware)
* [Client.SetResponseMiddlewares]({{% godoc v3 %}}Client.SetResponseMiddlewares)