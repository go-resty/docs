# Rate Limiting

Rate limiting helps control outbound request throughput and protects upstream services from overload.

In Resty v3, a rate limiter is configured at the client level and is consulted before every request.

{{% hintreqoverride %}}

## Default Behavior

* Rate limiting is disabled by default.
* Rate limiting is evaluated before each request execution.
* If the configured rate limiter returns an error, request execution is aborted with that error.
* Built-in rate limiters block until a slot/token is available or the request context is done.
* Built-in rate limiters return [ErrRateLimitExceeded]({{% godoc v3 %}}ErrRateLimitExceeded) when the request context is canceled or reaches its deadline before allowance is granted.

## Built-in Rate Limiters

Resty provides two ready-to-use rate limiter implementations.

### Token Bucket

Use [NewRateLimitTokenBucket]({{% godoc v3 %}}NewRateLimitTokenBucket) when you need average-rate control with burst tolerance.

* `requestsPerSecond` controls refill rate.
* `burst` controls how many requests can pass immediately.
* Defaults:
	* `requestsPerSecond <= 0` defaults to `5`
	* `burst <= 0` defaults to `1`

```go
rateLimiter := resty.NewRateLimitTokenBucket(100, 10)

client := resty.New().
	SetRateLimiter(rateLimiter)
```

### Sliding Window

Use [NewRateLimitSlidingWindow]({{% godoc v3 %}}NewRateLimitSlidingWindow) when you need stricter enforcement over a rolling time window.

* `limit` controls max requests in the window.
* `windowSize` controls window duration.
* Defaults:
	* `limit <= 0` defaults to `5`
	* `windowSize <= 0` defaults to `1s`

```go
rateLimiter := resty.NewRateLimitSlidingWindow(100, 10*time.Second)

client := resty.New().
	SetRateLimiter(rateLimiter)
```

## Using Request Context for Backpressure

Rate limit checks respect each request context. This is useful when you want bounded waiting.

```go
rateLimiter := resty.NewRateLimitTokenBucket(1, 1)

client := resty.New().
	SetRateLimiter(rateLimiter)

ctx, cancel := context.WithTimeout(context.Background(), 10*time.Millisecond)
defer cancel()

_, err := client.R().
	SetContext(ctx).
	Get("https://example.com")

if errors.Is(err, resty.ErrRateLimitExceeded) {
	// request was rejected because allowance did not become available in time
}
```

## Custom Rate Limiter

To implement custom rate limiting, implement [RateLimiter]({{% godoc v3 %}}RateLimiter) and configure it with [Client.SetRateLimiter]({{% godoc v3 %}}Client.SetRateLimiter).

```go
type MyLimiter struct{}

func (l *MyLimiter) Allow(ctx context.Context) error {
	// return nil to allow the request
	// return an error to reject it
	return nil
}

client := resty.New().
	SetRateLimiter(&MyLimiter{})
```

## Disable Rate Limiting

Pass `nil` to remove a previously configured limiter.

```go
client.SetRateLimiter(nil)
```

## Methods

### Package

* [ErrRateLimitExceeded]({{% godoc v3 %}}ErrRateLimitExceeded)
* [RateLimiter]({{% godoc v3 %}}RateLimiter)
* [NewRateLimitTokenBucket]({{% godoc v3 %}}NewRateLimitTokenBucket)
* [NewRateLimitSlidingWindow]({{% godoc v3 %}}NewRateLimitSlidingWindow)

### Client

* [Client.RateLimiter]({{% godoc v3 %}}Client.RateLimiter)
* [Client.SetRateLimiter]({{% godoc v3 %}}Client.SetRateLimiter)

### Token Bucket Accessors

* [RateLimitTokenBucket.Rate]({{% godoc v3 %}}RateLimitTokenBucket.Rate)
* [RateLimitTokenBucket.Burst]({{% godoc v3 %}}RateLimitTokenBucket.Burst)

### Sliding Window Accessors

* [RateLimitSlidingWindow.Limit]({{% godoc v3 %}}RateLimitSlidingWindow.Limit)
* [RateLimitSlidingWindow.WindowSize]({{% godoc v3 %}}RateLimitSlidingWindow.WindowSize)
