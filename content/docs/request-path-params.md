---
title: "Request Path Params"
weight: 1
---

# Request Path Params

Resty provides easy-to-use dynamic request URL path params. It replaces the value of the key while composing the request URL. The value will be escaped using the [url.PathEscape](https://pkg.go.dev/net/url#PathEscape) function.

{{% hint info %}}
**NOTE:** Client-level settings can be overridden at the request level.
{{% /hint %}}

## Methods
* [Client.SetPathParam]()
* [Client.SetPathParams]()
* [Request.SetPathParam]()
* [Request.SetPathParams]()

### Single Path Param
```go
client := resty.New()
defer client.Close()

client.R().
    SetPathParam("userId", "sample@sample.com").
    Get("/v1/users/{userId}/details")

// Result:
//     /v1/users/sample@sample.com/details

```

### Multiple Path Params
```go
client := resty.New()
defer client.Close()

client.R().
    SetPathParams(map[string]string{
        "userId":       "sample@sample.com",
        "subAccountId": "100002",
        "path":         "groups/developers",
    }).
    Get("/v1/users/{userId}/{subAccountId}/{path}/details)

// Result:
//   /v1/users/sample@sample.com/100002/groups%2Fdevelopers/details
```

# Request Raw Path Params

Resty provides easy-to-use dynamic request URL **raw** path params. It replaces the value of the key while composing the request URL. The value used **as-is**, no escapes applied.

## Methods
* [Client.SetRawPathParam]()
* [Client.SetRawPathParams]()
* [Request.SetRawPathParam]()
* [Request.SetRawPathParams]()

### Single Raw Path Param
```go
client := resty.New()
defer client.Close()

client.R().
    SetRawPathParam("path", "groups/developers").
    Get("/v1/users/{userId}/details")

// Result:
//     /v1/users/groups/developers/details
```

### Multiple Raw Path Params
```go
client := resty.New()
defer client.Close()

client.R().
    SetRawPathParams(map[string]string{
        "userId":       "sample@sample.com",
        "subAccountId": "100002",
        "path":         "groups/developers",
    }).
    Get("/v1/users/{userId}/{subAccountId}/{path}/details")

// Result:
//     /v1/users/sample@sample.com/100002/groups/developers/details
```