
# Circuit Breaker

A circuit breaker is used to improve system stability and resiliency. It is different from the retry mechanism.

{{% hint info %}}
**Hint:** Combining the Circuit Breaker with [Retry Mechanism]({{% relref "retry-mechanism" %}}) typically provides a comprehensive approach to handling failures.
{{% /hint %}}

## Default Values

* Timeout is `10s`
* Failure threshold is `3`
* Success threshold is `1`
* Circuir break policy
    * Status Code `500` and above


## Example

```go
// create circuit breaker with required values, override as required
cb := resty.NewCircuitBreaker().
	SetTimeout(15 * time.Second).
	SetFailureThreshold(10).
	SetSuccessThreshold(5)

// create Resty client
c := resty.New().
    SetCircuitBreaker(cb)
defer c.Close()

// start using the client ...
```


## Methods

* [CircuitBreaker.SetTimeout]({{% godoc v3 %}}CircuitBreaker.SetTimeout)
* [CircuitBreaker.SetFailureThreshold]({{% godoc v3 %}}CircuitBreaker.SetFailureThreshold)
* [CircuitBreaker.SetSuccessThreshold]({{% godoc v3 %}}CircuitBreaker.SetSuccessThreshold)
* [CircuitBreaker.SetPolicies]({{% godoc v3 %}}CircuitBreaker.SetPolicies)
* [CircuitBreaker.AddPolicies]({{% godoc v3 %}}CircuitBreaker.AddPolicies)