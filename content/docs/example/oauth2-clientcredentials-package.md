

# Oauth2 Client Credentials Package

[![Go Reference](https://pkg.go.dev/badge/golang.org/x/oauth2/clientcredentials.svg)](https://pkg.go.dev/golang.org/x/oauth2/clientcredentials)


## Without Modifying TLSClientConfig

{{% hint info %}}
As per the GoDoc of [clientcredentials#Config.Client](https://pkg.go.dev/golang.org/x/oauth2/clientcredentials#Config.Client), The returned `Client` and its `Transport` should not be modified.
{{% /hint %}}

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


## Modifying TLSClientConfig

This scenario is applicable for adding Root CA, Client Root CA, and Client SSL auth.

{{% hint info %}}
Refer to the above section hint. To modify TLSClientConfig and use the oauth2 client credentials package together, a slight tweak is required.
{{% /hint %}}

```go
clientCredCfg := &clientcredentials.Config{
    /* initialize values ... */
}

// create a Resty client
c := resty.New()
defer c.Close()

// set request middleware
c.SetRequestMiddlewares(
    resty.PrepareRequestMiddleware,
    func(c *resty.Client, req *resty.Request) error {
        // pass request instance to set the auth header
        token := clientCredCfg.Token(req.Context())
	    token.SetAuthHeader(req.RawRequest)
        return nil
    },
)

// start using a resty client
```