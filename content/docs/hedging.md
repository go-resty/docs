
# Hedging

Hedging is a latency reduction technique that sends multiple concurrent requests and returns the first response to complete. This approach is particularly effective for handling "tail latency" - the occasional slow responses that can significantly impact application performance.

Inspired by [hedgedhttp](https://github.com/cristalhq/hedgedhttp) and the paper [Tail at Scale](https://research.google/pubs/the-tail-at-scale/) by Jeffrey Dean, Luiz André Barroso.

> [!NOTE]
> **Hint:** Hedging is complementary to [Retry Mechanism]({{% relref "retry" %}}). Hedging optimizes latency while retry handles failures. When hedging is enabled, retry is disabled by default; you must enable retry explicitly to avoid overloading your services.

## Default Values

* Hedging is disabled
* Delay is `50ms`
* Maximum concurrent requests is `3`
* Maximum requests per second is `3`
* Only read-only HTTP methods are hedged (GET, HEAD, OPTIONS, TRACE)

## Default Behavior

* Sends the first request immediately
* If the first request doesn't complete within the delay, sends additional hedged requests
* Returns the first response to complete, then cancels remaining requests
* If all hedged requests fail, falls back to retry logic (if enabled)
* Non-read-only methods require explicit opt-in via [Hedging.SetNonReadOnlyAllowed]({{% godoc v3 %}}Hedging.SetNonReadOnlyAllowed)

## Examples

### Quick Start with Default Values

```go
// Create a Resty client with hedging
c1 := resty.New().
	SetHedging(resty.NewHedging())

defer c.Close()
```

### Customize Hedging Settings
```go
// Create a heading instance with appropriate values
h := resty.NewHedging().
		SetDelay(10 * time.Millisecond).    // delay between requests
		SetMaxRequest(10).                  // maximum concurrent requests
		SetMaxRequestPerSecond(5.0)         // maximum requests per second (rate limit)

c := resty.New().
    SetHedging(h)

defer c.Close()

// start using the resty client with hedging feature ...
```

## Delay

[Hedging.SetDelay]({{% godoc v3 %}}Hedging.SetDelay) controls how long to wait before sending the next hedged request. If the first request doesn't complete within this delay, a second request is sent, and so on.

```go
// wait 50ms before sending next hedged request
h := resty.NewHedging().
	SetDelay(50 * time.Millisecond)

// If you already have the hedging activated
client.Hedging().SetDelay(50 * time.Millisecond)
```

## Maximum Concurrent Requests

[Hedging.SetMaxRequest]({{% godoc v3 %}}Hedging.SetMaxRequest) limits how many concurrent hedged requests can be in-flight. For example, `3` means at most 3 requests (1 original + 2 hedged) will be active simultaneously.

```go
// allow up to 5 concurrent requests
h := resty.NewHedging().
	SetMaxRequest(5)

// If you already have the hedging activated
client.Hedging().SetMaxRequest(5)
```

## Rate Limiting

[Hedging.SetMaxRequestPerSecond]({{% godoc v3 %}}Hedging.SetMaxRequestPerSecond) prevents overwhelming the server with hedged requests. It limits how many hedged requests can be issued per second across all in-flight requests. For example, `10.0` means at most 10 hedged requests per second.

```go
// allow max 10 hedged requests per second
h := resty.NewHedging().
	SetMaxRequestPerSecond(10.0)

// If you already have the hedging activated
client.Hedging().SetMaxRequestPerSecond(10.0)
```

## Allow Non-Read-Only Methods

> [!WARNING]
> Use with caution as it may cause duplicate writes or side effects.

```go
// allow hedging on POST, PUT, PATCH, DELETE
h := resty.NewHedging().
	SetNonReadOnlyAllowed(true)

// If you already have the hedging activated
client.Hedging().SetNonReadOnlyAllowed(true)
```

## Disable Hedging

```go
client.SetHedging(nil)
```

## Methods

### Client

* [Client.SetHedging]({{% godoc v3 %}}Client.SetHedging)
* [Client.Hedging]({{% godoc v3 %}}Client.Hedging)


### Hedging

* [Hedging.SetDelay]({{% godoc v3 %}}Hedging.SetDelay)
* [Hedging.Delay]({{% godoc v3 %}}Hedging.Delay)
* [Hedging.SetMaxRequest]({{% godoc v3 %}}Hedging.SetMaxRequest)
* [Hedging.MaxRequest]({{% godoc v3 %}}Hedging.MaxRequest)
* [Hedging.SetMaxRequestPerSecond]({{% godoc v3 %}}Hedging.SetMaxRequestPerSecond)
* [Hedging.MaxRequestPerSecond]({{% godoc v3 %}}Hedging.MaxRequestPerSecond)
* [Hedging.SetNonReadOnlyAllowed]({{% godoc v3 %}}Hedging.SetNonReadOnlyAllowed)
* [Hedging.IsNonReadOnlyAllowed]({{% godoc v3 %}}Hedging.IsNonReadOnlyAllowed)
