
# Circuit Breaker

A circuit breaker improves system stability and resiliency by short-circuiting requests when failure conditions are met.

Resty v3 provides extensible interfaces such as [CircuitBreaker]({{% godoc v3 %}}CircuitBreaker) and [CircuitBreakerObserver]({{% godoc v3 %}}CircuitBreakerObserver).

Out-of-the-box, Resty v3 supports:

* [Count-based circuit breaker]({{% relref "#count-based" %}})
* [Ratio-based circuit breaker]({{% relref "#ratio-based" %}})

> [!NOTE]
> Combining circuit breaker with [Retry]({{% relref "retry" %}}) provides a comprehensive approach to transient and sustained failures.


## Default Values

* Circuit breaker policy
	* Status code `>= 500`

## Policies

Circuit breaker policies determine whether a response/error should be treated as a failure by the breaker.

Resty provides:

* [CircuitBreaker5xxPolicy]({{% godoc v3 %}}CircuitBreaker5xxPolicy)

You can also provide one or more custom policies.

## Count-based

Use count-based circuit breaker when you want the breaker to open after a fixed number of failures.

```go
// create count-based circuit breaker instance with values
cb := resty.NewCircuitBreakerCount(
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
customPolicy := func(res *resty.Response, err error) bool {
	if err != nil {
		return true
	}
	return res != nil && res.StatusCode() == 429
}

// create count-based circuit breaker instance with values
cb := resty.NewCircuitBreakerCount(
	3, // failure threshold count
	1, // success threshold count
	5*time.Second, // reset timeout
	resty.CircuitBreaker5xxPolicy,
	customPolicy,
)

// create Resty client
c := resty.New().
	SetCircuitBreaker(cb)
defer c.Close()

// start using the client ...
```

## Ratio-based

Use ratio-based circuit breaker when you want failures to be evaluated by percentage over a request sample.

```go
// create ratio-based circuit breaker instance with values
cb := resty.NewCircuitBreakerRatio(
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
customPolicy := func(res *resty.Response, err error) bool {
	if err != nil {
		return true
	}
	return res != nil && res.StatusCode() == 429
}

// create ratio-based circuit breaker instance with values
cb := resty.NewCircuitBreakerRatio(
	0.3, // Threshold, e.g., 0.3 for 30% failure
	10,   // Minimum number of requests to consider failure ratio
	5*time.Second, // reset timeout
	resty.CircuitBreaker5xxPolicy,
	customPolicy,
)

// create Resty client
c := resty.New().
	SetCircuitBreaker(cb)
defer c.Close()

// start using the client ...
```

## Hooks

Resty provides [OnTrigger]({{% godoc v3 %}}CircuitBreaker.OnTrigger) and [OnStateChange]({{% godoc v3 %}}CircuitBreaker.OnStateChange) hook capabilities.

* `OnTrigger` runs when the breaker blocks a request.
* `OnStateChange` runs when the breaker transitions between states.

### OnTrigger Hook

```go
cbTriggerHook1 := func(req *resty.Request, err error) {
	// logic goes here ...
}

cbTriggerHook2 := func(req *resty.Request, err error) {
	// logic goes here ...
}

// create count-based circuit breaker instance with values
cb := resty.NewCircuitBreakerCount(
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
cb := resty.NewCircuitBreakerCount(
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

* [Client.SetCircuitBreaker]({{% godoc v3 %}}Client.SetCircuitBreaker)
* [NewCircuitBreakerCount]({{% godoc v3 %}}NewCircuitBreakerCount)
* [NewCircuitBreakerRatio]({{% godoc v3 %}}NewCircuitBreakerRatio)
* [CircuitBreaker5xxPolicy]({{% godoc v3 %}}CircuitBreaker5xxPolicy)


### CircuitBreakerCount

* [CircuitBreakerCount.OnTrigger]({{% godoc v3 %}}CircuitBreakerCount.OnTrigger)
* [CircuitBreakerCount.OnStateChange]({{% godoc v3 %}}CircuitBreakerCount.OnStateChange)

### CircuitBreakerRatio

* [CircuitBreakerRatio.OnTrigger]({{% godoc v3 %}}CircuitBreakerRatio.OnTrigger)
* [CircuitBreakerRatio.OnStateChange]({{% godoc v3 %}}CircuitBreakerRatio.OnStateChange)
