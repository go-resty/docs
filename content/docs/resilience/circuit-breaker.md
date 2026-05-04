# Circuit Breaker

Circuit breaker helps prevent cascading failures by temporarily stopping requests to unhealthy upstream services and probing for recovery.

In Resty v3, the circuit breaker is configured at the client level and checked before each request execution.

> [!NOTE]
> Combining circuit breaker with [Retry]({{% relref "retry" %}}) provides a comprehensive approach to transient and sustained failures.

## Default Behavior

* Circuit breaker is disabled by default.
* When configured, [Client.SetCircuitBreaker]({{% godoc v3 %}}Client.SetCircuitBreaker) applies to all requests from that client.
* If [CircuitBreaker.Allow]({{% godoc v3 %}}CircuitBreaker.Allow) rejects a request, Resty returns [ErrCircuitBreakerOpen]({{% godoc v3 %}}ErrCircuitBreakerOpen) immediately and does not execute request middlewares or issue a network call.
* Resty applies breaker policies only when an HTTP response is available.
* In half-open state, only one probe request is allowed in flight at a time.
* On any state transition, breaker counters are reset.

## Built-in Circuit Breaker

Resty provides two built-in circuit breaker implementations.

### Count-Based Breaker

Use [NewCircuitBreakerCount]({{% godoc v3 %}}NewCircuitBreakerCount).

Parameters:

* failureThreshold: open breaker when tracked failures in the sliding window reach this value.
* successThreshold: in half-open, number of successful probe requests needed to close.
* resetTimeout: open duration before transitioning to half-open.
* policies: optional response classification policies.

```go
cb := resty.NewCircuitBreakerCount(
    5,              // failureThreshold
    2,              // successThreshold
    30*time.Second, // resetTimeout
)

c := resty.New().
    SetCircuitBreaker(cb)
defer c.Close()
```

### Ratio-Based Breaker

Use [NewCircuitBreakerRatio]({{% godoc v3 %}}NewCircuitBreakerRatio).

Parameters:

* failureRatio: open breaker when failure ratio is greater than or equal to this value.
* minRequests: minimum requests required in window before ratio evaluation.
* resetTimeout: open duration before transitioning to half-open.
* policies: optional response classification policies.

Notes:

* Ratio mode uses one successful half-open probe to close.

```go
cb := resty.NewCircuitBreakerRatio(
    0.5,            // failureRatio
    20,             // minRequests
    30*time.Second, // resetTimeout
)

c := resty.New().
    SetCircuitBreaker(cb)
defer c.Close()
```

## Failure Classification Policy

A [CircuitBreakerPolicy]({{% godoc v3 %}}CircuitBreakerPolicy) decides whether a response counts as a failure.

* If no policy is provided, Resty uses [CircuitBreaker5xxPolicy]({{% godoc v3 %}}CircuitBreaker5xxPolicy).
* With multiple policies, a response is considered failed if any policy returns true.

```go
policy5xxOr429 := func(resp *resty.Response) bool {
    status := resp.StatusCode()
    return status >= 500 || status == 429
}

cb := resty.NewCircuitBreakerCount(5, 1, 30*time.Second, policy5xxOr429)

c := resty.New().SetCircuitBreaker(cb)
defer c.Close()
```

## Hooks and Observability

Breakers that implement [CircuitBreakerObserver]({{% godoc v3 %}}CircuitBreakerObserver) support trigger and state-change hooks.

* OnTrigger hook runs when request is blocked in open state.
* OnStateChange hook runs on state transitions.

```go
cb := resty.NewCircuitBreakerCount(3, 1, 10*time.Second)

cb.OnTrigger(func(req *resty.Request, err error) {
    // err is typically resty.ErrCircuitBreakerOpen
    // add metrics/logging here
})

cb.OnStateChange(func(oldState, newState resty.CircuitBreakerState) {
    // add state transition metrics/logging here
})

c := resty.New().SetCircuitBreaker(cb)
defer c.Close()
```

## Error Semantics

* Open-state rejection returns [ErrCircuitBreakerOpen]({{% godoc v3 %}}ErrCircuitBreakerOpen).
* In half-open, if the probe request fails before a response is produced (for example, request middleware error or transport error), breaker transitions back to open.
* Response-policy failures are applied after receiving the response.

## Disable Circuit Breaker

Pass nil to remove a previously configured breaker.

```go
client.SetCircuitBreaker(nil)
```

## Methods

### Package

* [NewCircuitBreakerCount]({{% godoc v3 %}}NewCircuitBreakerCount)
* [NewCircuitBreakerRatio]({{% godoc v3 %}}NewCircuitBreakerRatio)
* [ErrCircuitBreakerOpen]({{% godoc v3 %}}ErrCircuitBreakerOpen)
* [CircuitBreaker]({{% godoc v3 %}}CircuitBreaker)
* [CircuitBreakerObserver]({{% godoc v3 %}}CircuitBreakerObserver)
* [CircuitBreakerPolicy]({{% godoc v3 %}}CircuitBreakerPolicy)
* [CircuitBreaker5xxPolicy]({{% godoc v3 %}}CircuitBreaker5xxPolicy)
* [CircuitBreakerState]({{% godoc v3 %}}CircuitBreakerState)
* [CircuitBreakerStateClosed]({{% godoc v3 %}}CircuitBreakerStateClosed)
* [CircuitBreakerStateOpen]({{% godoc v3 %}}CircuitBreakerStateOpen)
* [CircuitBreakerStateHalfOpen]({{% godoc v3 %}}CircuitBreakerStateHalfOpen)

### Client

* [Client.SetCircuitBreaker]({{% godoc v3 %}}Client.SetCircuitBreaker)

### CircuitBreakerCount Accessors

* [CircuitBreakerCount.Allow]({{% godoc v3 %}}CircuitBreakerCount.Allow)
* [CircuitBreakerCount.ApplyPolicies]({{% godoc v3 %}}CircuitBreakerCount.ApplyPolicies)
* [CircuitBreakerCount.OnTrigger]({{% godoc v3 %}}CircuitBreakerCount.OnTrigger)
* [CircuitBreakerCount.OnStateChange]({{% godoc v3 %}}CircuitBreakerCount.OnStateChange)

### CircuitBreakerRatio Accessors

* [CircuitBreakerRatio.Allow]({{% godoc v3 %}}CircuitBreakerRatio.Allow)
* [CircuitBreakerRatio.ApplyPolicies]({{% godoc v3 %}}CircuitBreakerRatio.ApplyPolicies)
* [CircuitBreakerRatio.OnTrigger]({{% godoc v3 %}}CircuitBreakerRatio.OnTrigger)
* [CircuitBreakerRatio.OnStateChange]({{% godoc v3 %}}CircuitBreakerRatio.OnStateChange)
