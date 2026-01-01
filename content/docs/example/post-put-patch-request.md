---
title: POST, PUT, PATCH Request
weight: 1
---

# POST, PUT, PATCH Request

This page discusses simple POST, PUT, and PATCH requests. Users can utilize Resty features across nearly all HTTP methods.

> [!NOTE]
> * Explore the documentation to fulfill all use cases.
> * Examples use request-level methods; however, Resty also includes client-level methods to configure settings for all requests.

## Examples

See [Request Body Types]({{% relref "request-body-types" %}}), [Multipart]({{% relref "multipart" %}}), [Form Data]({{% relref "form-data" %}}), etc.

```go
// create a Resty client
client := resty.New()
defer client.Close()
```

### POST

```go
res, err := client.R().
    SetBody(User{
        Username: "testuser",
        Password: "testpass",
    }). // default request content type is JSON
    SetResult(&LoginResponse{}). // or SetResult(LoginResponse{}).
    SetResultError(&LoginError{}).     // or SetResultError(LoginError{}).
    Post("https://myapp.com/login")

fmt.Println(err, res)
fmt.Println(res.Result().(*LoginResponse))
fmt.Println(res.ResultError().(*LoginError))
```

### PUT

```go
res, err := client.R().
    SetBody(Article{
        Title: "Resty",
        Content: "This is my article content, oh ya!",
        Author: "Jeevanandam M",
        Tags: []string{"article", "sample", "resty"},
    }). // default request content type is JSON
    SetAuthToken("bc594900518b4f7eac75bd37f019e08fbc594900518b4f7eac75bd37f019e08f").
    SetResultError(&Error{}). // or SetResultError(Error{}).
    Put("https://myapp.com/articles/123456")

fmt.Println(err, res)
fmt.Println(res.ResultError().(*Error))
```

### PATCH

```go
resp, err := client.R().
    SetBody(Article{
        Tags: []string{"new tag1", "new tag2"},
    }). // default request content type is JSON
    SetAuthToken("bc594900518b4f7eac75bd37f019e08fbc594900518b4f7eac75bd37f019e08f").
    SetResultError(&Error{}). // or SetResultError(Error{}).
    Patch("https://myapp.com/articles/123456")

fmt.Println(err, res)
fmt.Println(res.ResultError().(*Error))
```