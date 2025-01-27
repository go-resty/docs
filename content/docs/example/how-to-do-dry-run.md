---
title: How to do Dry-Run?
---

# How to do Dry-Run?

The appropriate way to do Dry-Run implementation with Resty is to implement custom transport using the `http.RoundTripper` interface.

With custom transport, the user could perform any use case handling for Dry-Run.

```go
type DryRunTransport struct {
    http.RoundTripper
}

func (dr *DryRunTransport) RoundTrip(r *http.Request) (*http.Response, error) {
    // implement Dry-Run logic here ...

    return resp, err
}

c := resty.New().
    SetTransport(&DryRunTransport{
        // initialize dry-run fields
    })

defer c.Close()

// start using the Resty client with dry-run ...
```