---
title: OAuth2 Client Credentials
---

# OAuth2 Client Credentials

[![Go Reference](https://pkg.go.dev/badge/golang.org/x/oauth2/clientcredentials.svg)](https://pkg.go.dev/golang.org/x/oauth2/clientcredentials)


## Without Modifying

> [!NOTE]
> As per the GoDoc of [clientcredentials#Config.Client](https://pkg.go.dev/golang.org/x/oauth2/clientcredentials#Config.Client)
> * The returned `Client` and its `Transport` should not be modified.

```go
clientCredCfg := &clientcredentials.Config{
    /* initialize values ... */
}

// create a client
credClient := clientCredCfg.Client(context.Background())

// create a Resty client
c := resty.NewWithClient(credClient)
defer c.Close()

// start using a resty client
```


## Modifying

This scenario applies to any client and transport-related configurations, such as adding Root CA, Client Root CA, Client SSL certificates, transport timeouts, and so on.

> [!NOTE]
> * As per the GoDoc of [clientcredentials#Config.Client](https://pkg.go.dev/golang.org/x/oauth2/clientcredentials#Config.Client)
>     * The returned `Client` and its `Transport` should not be modified.
> * To use the oauth2 client credentials package and make modifications to it, a minor adjustment is necessary.

```go
clientCredCfg := &clientcredentials.Config{
    /* initialize values ... */
}

// create a Resty client
c := resty.New()
defer c.Close()

// configure required Root CA, Client Root CA, or Client SSL certs
// c.SetRootCertificates("/path/to/root/pemFile.pem")
// c.SetClientRootCertificates("/path/to/client-root/pemFile.pem")
// c.SetCertificateFromFile("/path/to/certs/client.pem", "/path/to/certs/client.key")

// add custom auth request middleware
c.AddRequestMiddleware(func(c *resty.Client, req *resty.Request) error {
    // get the token from client credentials
    token, err := clientCredCfg.Token(req.Context())
    if err != nil {
        return err
    }

    // set it on the request
    req.SetAuthScheme(token.Type()). // if it is "Bearer", you can skip this line
        SetAuthToken(token.AccessToken)

    return nil
})

// start using a resty client
```