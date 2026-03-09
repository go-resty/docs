
# Redirect Policy

Resty provides easy-to-use redirect policy implementation and is flexible to extend for custom use cases.

Out of the box, it has following redirect polices:

* [RedirectNoPolicy]({{% godoc v3 %}}RedirectNoPolicy)
* [RedirectFlexiblePolicy]({{% godoc v3 %}}RedirectFlexiblePolicy)
* [RedirectDomainCheckPolicy]({{% godoc v3 %}}RedirectDomainCheckPolicy)

> [!NOTE]
> v3 [RedirectNoPolicy]({{% godoc v3 %}}RedirectNoPolicy) returns an error `http.ErrUseLastResponse`.

## Example

```go
// default golang client does maximum redirect count as 10,
// in the Resty, simply set
client.SetRedirectPolicy(resty.RedirectFlexiblePolicy(5))

// set one or more redirect policies together
client.SetRedirectPolicy(resty.RedirectFlexiblePolicy(5),
    resty.RedirectDomainCheckPolicy("host1.com", "host2.org", "host3.net"))
```

### Custom Redirect Policy

There are two ways users can implement redirect policy.

#### Simple

Create a simple function to implement redirect policy using [RedirectPolicyFunc]({{% godoc v3 %}}RedirectPolicyFunc).

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

Implement advanced redirect policy usage by utilizing the [RedirectPolicy]({{% godoc v3 %}}RedirectPolicy) interface.

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
    // initialize field here
})
```

## Methods

### Client

* [Client.SetRedirectPolicy]({{% godoc v3 %}}Client.SetRedirectPolicy)

### Response

* [Response.RedirectHistory]({{% godoc v3 %}}Response.RedirectHistory)


