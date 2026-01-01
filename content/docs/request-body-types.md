---
weight: 4
---

# Request Body Types

Resty supports various request body types.

> [!NOTE]
> * Resty v3 streams the content in the request body for the `io.Reader` interface.
> * Resty v3 uses a streaming approach by default to handle JSON and XML content types, improving memory efficiency. Resty also provides the [In-Memory Marshal and Unmarshal]({{% relref "content-type-encoder-and-decoder#in-memory-marshal-and-unmarshal" %}}) section.
> * Setting the Content-Type header in the request skips the auto-detect computation.
> * It does request body automatic marshaling for `struct` and `map` data types.

## Struct

> [!NOTE]
> For the `XML` request body, set Content-Type as `application/xml`.

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
```

## Map

```go
res, err := client.R().
    SetBody(map[string]string{
        "username": "testuser",
        "password": "testpass",
    }). // default request content type is JSON
    SetResult(&LoginResponse{}). // or SetResult(LoginResponse{}).
    SetResultError(&LoginError{}).     // or SetResultError(LoginError{}).
    Post("https://myapp.com/login")

fmt.Println(err)
fmt.Println(res.Result().(*LoginResponse))  // success: status code > 199 && status code < 300
fmt.Println(res.ResultError().(*LoginError))      // error: status code > 399
```

## String

```go
res, err := client.R().
    SetContentType("application/json").
    SetBody(`{"username":"testuser", "password":"testpass"}`).
    SetResult(&LoginResponse{}). // or SetResult(LoginResponse{}).
    SetResultError(&LoginError{}).     // or SetResultError(LoginError{}).
    Post("https://myapp.com/login")

fmt.Println(err)
fmt.Println(res.Result().(*LoginResponse))  // success: status code > 199 && status code < 300
fmt.Println(res.ResultError().(*LoginError))      // error: status code > 399
```

## Bytes

```go
res, err := client.R().
    SetContentType("application/json").
    SetBody([]byte(`{"username":"testuser", "password":"testpass"}`)).
    SetResult(&LoginResponse{}). // or SetResult(LoginResponse{}).
    SetResultError(&LoginError{}).     // or SetResultError(LoginError{}).
    Post("https://myapp.com/login")

fmt.Println(err)
fmt.Println(res.Result().(*LoginResponse))  // success: status code > 199 && status code < 300
fmt.Println(res.ResultError().(*LoginError))      // error: status code > 399
```

## io.Reader

> [!NOTE]
> Resty v3,
> * Streams the content in the request body for the `io.Reader` interface.
> * The content length option no longer applies to the `io.Reader` flow.

```go
res, err := client.R().
    SetContentType("application/json").
    SetBody(strings.NewReader(`{"username":"testuser", "password":"testpass"}`)).
    SetResult(&LoginResponse{}). // or SetResult(LoginResponse{}).
    SetResultError(&LoginError{}).     // or SetResultError(LoginError{}).
    Post("https://myapp.com/login")

fmt.Println(err)
fmt.Println(res.Result().(*LoginResponse))  // success: status code > 199 && status code < 300
fmt.Println(res.ResultError().(*LoginError))      // error: status code > 399
```

