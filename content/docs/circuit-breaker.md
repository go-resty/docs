
# Circuit Breaker

A circuit breaker is used to improve system stability and resiliency. It is different from the retry mechanism.

Out-of-the-box, Resty v3 provides:

* [Count-based]({{% relref "#count-based" %}})
* [Ratio-based]({{% relref "#ratio-based" %}})

> [!NOTE]
> **HINT:** Combining the Circuit Breaker with [Retry Mechanism]({{% relref "retry" %}}) typically provides a comprehensive approach to handling failures.

## Default Values

* Circuit break policy
    * Status Code `500` and above

## Count-based

```go
// create count-based circuit breaker instance with values
cb := resty.NewCircuitBreakerWithCount(
	3, // failure threshold count
	1, // success threshold count
	5*time.Second, // reset timeout
)

// create Resty client
c := resty.New().
    SetCircuitBreaker(cb)
defer c.Close()

// start using the client ...
```

### Count-based with Policies

```go
// create count-based circuit breaker instance with values
cb := resty.NewCircuitBreakerWithCount(
	3, // failure threshold count
	1, // success threshold count
	5*time.Second, // reset timeout
	resty.CircuitBreaker5xxPolicy,
	CustomCircuitBreakerPolicy,
)

// create Resty client
c := resty.New().
    SetCircuitBreaker(cb)
defer c.Close()

// start using the client ...
```

## Ratio-based

```go
// create ratio-based circuit breaker instance with values
cb := resty.NewCircuitBreakerWithRatio(
	0.3, // Threshold, e.g., 0.3 for 30% failure
	10,   // Minimum number of requests to consider failure ratio
	5*time.Second, // reset timeout
)

// create Resty client
c := resty.New().
    SetCircuitBreaker(cb)
defer c.Close()

// start using the client ...
```

### Ratio-based with Policies

```go
// create ratio-based circuit breaker instance with values
cb := resty.NewCircuitBreakerWithRatio(
	0.3, // Threshold, e.g., 0.3 for 30% failure
	10,   // Minimum number of requests to consider failure ratio
	5*time.Second, // reset timeout
	resty.CircuitBreaker5xxPolicy,
	CustomCircuitBreakerPolicy,
)

// create Resty client
c := resty.New().
    SetCircuitBreaker(cb)
defer c.Close()

// start using the client ...
```

## Hooks

Resty provides [OnTrigger]({{% godoc v3 %}}CircuitBreaker.OnTrigger) and [OnStateChange]({{% godoc v3 %}}CircuitBreaker.OnStateChange) hooks capabilities.

### OnTrigger Hook

```go
cbTriggerHook1 := func(req *resty.Request, err error) {
	// logic goes here ...
}

cbTriggerHook2 := func(req *resty.Request, err error) {
	// logic goes here ...
}

// create count-based circuit breaker instance with values
cb := resty.NewCircuitBreakerWithCount(
	3, // failure threshold count
	1, // success threshold count
	5*time.Second, // reset timeout
).
OnTrigger(cbTriggerHook1, cbTriggerHook2)

// create Resty client
c := resty.New().
    SetCircuitBreaker(cb)
defer c.Close()

// start using the client ...
```

### OnStateChange Hook

```go
cbStateChangeHook1 := func(oldState, newState resty.CircuitBreakerState) {
	// logic goes here ...
}

cbStateChangeHook2 := func(oldState, newState resty.CircuitBreakerState) {
	// logic goes here ...
}

// create count-based circuit breaker instance with values
cb := resty.NewCircuitBreakerWithCount(
	3, // failure threshold count
	1, // success threshold count
	5*time.Second, // reset timeout
).
OnStateChange(cbStateChangeHook1, cbStateChangeHook2)

// create Resty client
c := resty.New().
    SetCircuitBreaker(cb)
defer c.Close()

// start using the client ...
```


## Methods

* [CircuitBreaker5xxPolicy]({{% godoc v3 %}}CircuitBreaker5xxPolicy)
* [CircuitBreaker.OnTrigger]({{% godoc v3 %}}CircuitBreaker.OnTrigger)
* [CircuitBreaker.OnStateChange]({{% godoc v3 %}}CircuitBreaker.OnStateChange)
