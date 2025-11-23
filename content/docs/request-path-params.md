---
weight: 3
---

# Request Path Params

Resty provides easy-to-use dynamic request URL path params. It replaces the value of the key while composing the request URL. The value will be escaped using the [url.PathEscape](https://pkg.go.dev/net/url#PathEscape) function.

{{% hintreqoverride %}}

## Examples

### Single Path Param

```go
c := resty.New()
defer c.Close()

c.R().
    SetPathParam("userId", "sample@sample.com").
    Get("/v1/users/{userId}/details")

// Result:
//     /v1/users/sample@sample.com/details

```

### Multiple Path Params

```go
c := resty.New()
defer c.Close()

c.R().
    SetPathParams(map[string]string{
        "userId":       "sample@sample.com",
        "subAccountId": "100002",
        "path":         "groups/developers",
    }).
    Get("/v1/users/{userId}/{subAccountId}/{path}/details)

// Result:
//   /v1/users/sample@sample.com/100002/groups%2Fdevelopers/details
```

## Methods

### Client

* [Client.SetPathParam]({{% godoc v3 %}}Client.SetPathParam)
* [Client.SetPathParams]({{% godoc v3 %}}Client.SetPathParams)

### Request

* [Request.SetPathParam]({{% godoc v3 %}}Request.SetPathParam)
* [Request.SetPathParams]({{% godoc v3 %}}Request.SetPathParams)


# Request Raw Path Params

Resty provides easy-to-use dynamic request URL **raw** path params. It replaces the value of the key while composing the request URL. The value used **as-is**, no escapes applied.

## Examples

### Single Raw Path Param

```go
c := resty.New()
defer c.Close()

c.R().
    SetRawPathParam("path", "groups/developers").
    Get("/v1/users/{path}/details")

// Result:
//     /v1/users/groups/developers/details
```

### Multiple Raw Path Params

```go
c := resty.New()
defer c.Close()

c.R().
    SetRawPathParams(map[string]string{
        "userId":       "sample@sample.com",
        "subAccountId": "100002",
        "path":         "groups/developers",
    }).
    Get("/v1/users/{userId}/{subAccountId}/{path}/details")

// Result:
//     /v1/users/sample@sample.com/100002/groups/developers/details
```

## Methods

### Client

* [Client.SetRawPathParam]({{% godoc v3 %}}Client.SetRawPathParam)
* [Client.SetRawPathParams]({{% godoc v3 %}}Client.SetRawPathParams)

### Request

* [Request.SetRawPathParam]({{% godoc v3 %}}Request.SetRawPathParam)
* [Request.SetRawPathParams]({{% godoc v3 %}}Request.SetRawPathParams)
