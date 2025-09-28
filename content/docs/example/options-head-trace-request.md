---
title: OPTIONS, HEAD, TRACE Request
weight: 2
---

# OPTIONS, HEAD, TRACE Request

This page discusses simple OPTIONS, HEAD, and TRACE requests. Users can utilize Resty features across nearly all HTTP methods.

> [!NOTE]
> * Explore the documentation to fulfill all use cases.
> * Examples use request-level methods; however, Resty also includes client-level methods to configure settings for all requests.

## Examples

```go
// create a Resty client
client := resty.New()
defer client.Close()
```

### OPTIONS

Commonly used to determine permitted HTTP methods or CORS preflight requests.

```go
res, err := client.R().
    SetAuthToken("bc594900518b4f7eac75bd37f019e08fbc594900518b4f7eac75bd37f019e08f").
    Options("https://myapp.com/servers/nyc-dc-01")

fmt.Println(err, res)
fmt.Println(res.Header())
```

### HEAD

```go
res, err = client.R().
    SetAuthToken("bc594900518b4f7eac75bd37f019e08fbc594900518b4f7eac75bd37f019e08f").
    Head("https://myapp.com/videos/hi-res-video")

fmt.Println(err, res)
fmt.Println(res.Header())
```

### TRACE

```go
res, err = client.R().
    SetAuthToken("bc594900518b4f7eac75bd37f019e08fbc594900518b4f7eac75bd37f019e08f").
    Trace("https://myapp.com/test")

fmt.Println(err, res)
```