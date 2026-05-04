
# Redirect Policy

Resty provides easy-to-use redirect policy implementations and can be extended for custom use cases.

Out of the box, it provides the following redirect policies:

* [RedirectNoPolicy]({{% godoc v3 %}}RedirectNoPolicy)
* [RedirectFlexiblePolicy]({{% godoc v3 %}}RedirectFlexiblePolicy)
* [RedirectDomainCheckPolicy]({{% godoc v3 %}}RedirectDomainCheckPolicy)
* [RedirectHeaderStripSensitivePolicy]({{% godoc v3 %}}RedirectHeaderStripSensitivePolicy)

> [!NOTE]
> * v3 [RedirectNoPolicy]({{% godoc v3 %}}RedirectNoPolicy) returns the error `http.ErrUseLastResponse`.
> * v3 does not strip the port from the request URL host for comparison; the request URL host is used as-is.

## Example

```go
// The default Go client allows up to 10 redirects.
// In Resty, configure it as follows.
client.SetRedirectPolicy(resty.RedirectFlexiblePolicy(5))

// set one or more redirect policies together
client.SetRedirectPolicy(resty.RedirectFlexiblePolicy(5),
    resty.RedirectDomainCheckPolicy("host1.com", "host2.org", "host3.net"))
```

### Custom Redirect Policy

There are two ways to implement a redirect policy.

#### Simple

Create a simple function that implements a redirect policy by using [RedirectPolicyFunc]({{% godoc v3 %}}RedirectPolicyFunc).

```go
client.SetRedirectPolicy(
    resty.RedirectPolicyFunc(func(req *http.Request, via []*http.Request) error {
        // perform redirect logic here

        // return nil to continue; otherwise, return error to exit
        return nil
    }),
)
```

#### Advanced

Implement an advanced redirect policy by using the [RedirectPolicy]({{% godoc v3 %}}RedirectPolicy) interface.

```go
var _ resty.RedirectPolicy = (*AdvancedRedirectPolicy)(nil)

type AdvancedRedirectPolicy struct {
	// ... fields here
}

func (a *AdvancedRedirectPolicy) Apply(req *http.Request, via []*http.Request) error {
	// perform redirect logic here

	// return nil to continue; otherwise, return error to exit
	return nil
}

// set the redirect policy
client.SetRedirectPolicy(&AdvancedRedirectPolicy{
    // initialize fields here
})
```

## Methods

### Client

* [Client.SetRedirectPolicy]({{% godoc v3 %}}Client.SetRedirectPolicy)

### Response

* [Response.RedirectHistory]({{% godoc v3 %}}Response.RedirectHistory)


