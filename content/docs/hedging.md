
# Hedging

Hedging is a latency reduction technique that sends multiple concurrent requests and returns the first response to complete. It addresses tail latency at scale by not waiting for slow requests.

Inspired by [hedgedhttp](https://github.com/cristalhq/hedgedhttp) and the paper [Tail at Scale](https://research.google/pubs/the-tail-at-scale/) by Jeffrey Dean, Luiz André Barroso.

> [!NOTE]
> **Hint:** Hedging is complementary to [Retry Mechanism]({{% relref "retry-mechanism" %}}). Hedging optimizes latency while retry handles failures. When hedging is enabled, retry is disabled by default, you must enable explicitly retry to avoid overloading your services.

## Default Values

* Hedging is disabled
* Delay is `50ms`
* Maximum concurrent requests is `3`
* Only read-only HTTP methods are hedged (GET, HEAD, OPTIONS, TRACE)

## Default Behavior

* Sends the first request immediately
* If the first request doesn't complete within the delay, sends additional hedged requests
* Returns the first response to complete, then cancels remaining requests
* If all hedged requests fail, falls back to retry logic (if enabled)
* Non-read-only methods require explicit opt-in via [Client.SetHedgingAllowNonReadOnly]({{% godoc v3 %}}Client.SetHedgingAllowNonReadOnly)

## Examples

```go
// enable hedging at client level
client.EnableHedging(
    50*time.Millisecond, // delay before sending next hedged request
    5,                   // maximum concurrent requests
    10.0,                // rate limit (requests per second)
)
```

### Delay

`SetHedgingDelay()` controls how long to wait before sending the next hedged request. If the first request doesn't complete within this delay, a second request is sent, and so on.

```go
// wait 100ms before sending next hedged request
client.SetHedgingDelay(50 * time.Millisecond)
```

### Maximum Concurrent Requests

`SetHedgingUpTo()` limits how many concurrent hedged requests can be in-flight. For example, `3` means at most 3 requests (1 original + 2 hedged) will be active simultaneously.

```go
// allow up to 5 concurrent requests
client.SetHedgingUpTo(3)
```

### Rate Limiting

`SetHedgingMaxPerSecond()` prevents overwhelming the server with hedged requests. It limits how many hedged requests can be issued per second across all in-flight requests. For example, `10.0` means at most 10 hedged requests per second.

```go
// allow max 10 hedged requests per second
client.SetHedgingMaxPerSecond(10.0)
```

### Allow Non-Read-Only Methods

Use with caution as it may cause duplicate writes.

```go
// allow hedging on POST, PUT, PATCH, DELETE
client.SetHedgingAllowNonReadOnly(true)
```

### Combining with Retry

```go
client.
    EnableHedging(50*time.Millisecond, 5, 10.0).
    SetRetryCount(2).
    SetRetryWaitTime(2 * time.Second).
    SetRetryMaxWaitTime(5 * time.Second)
```

### Disable Hedging

```go
client.DisableHedging()
```

## Methods

* [Client.EnableHedging]({{% godoc v3 %}}Client.EnableHedging)
* [Client.DisableHedging]({{% godoc v3 %}}Client.DisableHedging)
* [Client.SetHedgingDelay]({{% godoc v3 %}}Client.SetHedgingDelay)
* [Client.SetHedgingUpTo]({{% godoc v3 %}}Client.SetHedgingUpTo)
* [Client.SetHedgingMaxPerSecond]({{% godoc v3 %}}Client.SetHedgingMaxPerSecond)
* [Client.SetHedgingAllowNonReadOnly]({{% godoc v3 %}}Client.SetHedgingAllowNonReadOnly)
* [Client.IsHedgingEnabled]({{% godoc v3 %}}Client.IsHedgingEnabled)
* [Client.HedgingDelay]({{% godoc v3 %}}Client.HedgingDelay)
* [Client.HedgingUpTo]({{% godoc v3 %}}Client.HedgingUpTo)
* [Client.HedgingMaxPerSecond]({{% godoc v3 %}}Client.HedgingMaxPerSecond)
* [Client.IsHedgingAllowNonReadOnly]({{% godoc v3 %}}Client.IsHedgingAllowNonReadOnly)
