

# Authentication

Resty supports the following authentication/authorization mechanism for requests.

* [Basic Auth]({{% relref "#basic-auth" %}})
* [Digest Auth]({{% relref "#digest-auth" %}})
* [Bearer Auth Token]({{% relref "#bearer-auth-token" %}})
* [Custom Auth Header]({{% relref "#custom-auth-header" %}})
* [Custom Auth using Request Middleware]({{% relref "#custom-auth-using-request-middleware" %}})

## Basic Auth

```go
// for all requests
client.SetBasicAuth("username", "password")

// for a particular request
client.R().
    SetBasicAuth("username", "password")
```

## Digest Auth

{{% hint info %}}
Digest auth is supported only at the client level; create a dedicated client to utilize it.
{{% /hint %}}

Supported QOP -
* `auth`
* `auth-int`

Supported Hash Functions

* `MD5`
* `MD5-sess`
* `SHA-256`
* `SHA-256-sess`
* `SHA-512`
* `SHA-512-sess`
* `SHA-512-256`
* `SHA-512-256-sess`

```go
// for all requests
client.SetDigestAuth("username", "password")
```

## Bearer Auth Token

{{% hint info %}}
The default auth scheme is `Bearer`, which can be changed with [Client.SetAuthScheme]({{% godoc v3 %}}Client.SetAuthScheme) or [Request.SetAuthScheme]({{% godoc v3 %}}Request.SetAuthScheme)
{{% /hint %}}

```go
// for all requests
client.SetAuthToken("bc594900518b4f7eac75bd37f019e08fbc594900518b4f7eac75bd37f019e08f")

// for a particular request
client.R().
    SetAuthToken("bc594900518b4f7eac75bd37f019e08fbc594900518b4f7eac75bd37f019e08f")

// outcome:
// Authorization: Bearer bc594900518b4f7eac75bd37f019e08fbc594900518b4f7eac75bd37f019e08f
```

## Custom Auth Header

For application/service that user custom HTTP header for authentication/authorization.

{{% hint info %}}
* The default authorization key is `Authorization`.
* The default auth scheme is `Bearer`, which can be changed with [Client.SetAuthScheme]({{% godoc v3 %}}Client.SetAuthScheme) or [Request.SetAuthScheme]({{% godoc v3 %}}Request.SetAuthScheme)
{{% /hint %}}

```go
client.SetHeaderAuthorizationKey("X-Custom-Auth")

// outcome:
// X-Custom-Auth: Bearer bc594900518b4f7eac75bd37f019e08fbc594900518b4f7eac75bd37f019e08f
```

## Custom Auth using Request Middleware

Use request middleware to perform sophisticated authentication/authorization logic.

```go
client.AddRequestMiddleware(func(c *resty.Client, req *resty.Request) error {
    // perform authentication/authorization logic here
    // set it on the Request instance

    return nil
})
```

## Methods

### Client

* [Client.SetBasicAuth]({{% godoc v3 %}}Client.SetBasicAuth)
* [Client.SetAuthToken]({{% godoc v3 %}}Client.SetAuthToken)
* [Client.SetAuthScheme]({{% godoc v3 %}}Client.SetAuthScheme)
* [Client.SetDigestAuth]({{% godoc v3 %}}Client.SetDigestAuth)
* [Client.SetHeaderAuthorizationKey]({{% godoc v3 %}}Client.SetHeaderAuthorizationKey)

### Request

* [Request.SetBasicAuth]({{% godoc v3 %}}Request.SetBasicAuth)
* [Request.SetAuthToken]({{% godoc v3 %}}Request.SetAuthToken)
* [Request.SetAuthScheme]({{% godoc v3 %}}Request.SetAuthScheme)
