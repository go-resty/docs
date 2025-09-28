---
weight: 4
---

# Request Body Types

Resty supports various request body types.

> [!NOTE]
> * Resty v3 streams the content in the request body for the `io.Reader` interface.
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
    SetError(&LoginError{}).     // or SetError(LoginError{}).
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
    SetError(&LoginError{}).     // or SetError(LoginError{}).
    Post("https://myapp.com/login")

fmt.Println(err, res)
```

## String

```go
res, err := client.R().
    SetContentType("application/json").
    SetBody(`{"username":"testuser", "password":"testpass"}`).
    SetResult(&LoginResponse{}). // or SetResult(LoginResponse{}).
    SetError(&LoginError{}).     // or SetError(LoginError{}).
    Post("https://myapp.com/login")

fmt.Println(err, res)
```

## Bytes

```go
res, err := client.R().
    SetContentType("application/json").
    SetBody([]byte(`{"username":"testuser", "password":"testpass"}`)).
    SetResult(&LoginResponse{}). // or SetResult(LoginResponse{}).
    SetError(&LoginError{}).     // or SetError(LoginError{}).
    Post("https://myapp.com/login")

fmt.Println(err, res)
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
    SetError(&LoginError{}).     // or SetError(LoginError{}).
    Post("https://myapp.com/login")

fmt.Println(err, res)
```

