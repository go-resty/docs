
# Retry Mechanism

The retry mechanism plays a crucial role in modern system integration by enabling effective handling of failures.

Resty provides exponential backoff with a jitter strategy out of the box; a custom retry strategy could be employed to override this default.

{{% hint info %}}
**Hint:** Combining the Retry strategy with [Circuit Breaker]({{% relref "circuit-breaker" %}}) typically provides a comprehensive approach to handling failures.
{{% /hint %}}

{{% hintreqoverride %}}

## Default Values

* Retry count is `0`
    * Total retry attempts = `first attempt + retry count`
* Retry minimum wait time is `100ms`
* Retry maximum wait time is `2000ms`
* Retry strategy is exponential backoff with a jitter


## Default Behavior

* Respects header `Retry-After` if present
* Resets reader on retry request if the `io.ReadSeeker` interface is supported.
* Retries only on Idempotent HTTP Verb - GET, HEAD, PUT, DELETE, OPTIONS, and TRACE ([RFC 9110](https://datatracker.ietf.org/doc/html/rfc9110.html#name-method-registration), [RFC 5789](https://datatracker.ietf.org/doc/html/rfc5789.html))
    * Use [Client.SetAllowNonIdempotentRetry]({{% godoc v3 %}}Client.SetAllowNonIdempotentRetry) or [Request.SetAllowNonIdempotentRetry]({{% godoc v3 %}}Request.SetAllowNonIdempotentRetry). If additional control is necessary, utilize the custom retry condition.
* Applies [default retry conditions]({{% relref "#default-conditions" %}})
    * It can be disabled via [Client.SetRetryDefaultConditions]({{% godoc v3 %}}Client.SetRetryDefaultConditions) or [Request.SetRetryDefaultConditions]({{% godoc v3 %}}Request.SetRetryDefaultConditions)
* [Request.RetryTraceID]({{% godoc v3 %}}Request) - GUID generated for retry count > 0


## Default Conditions

* Condition gets applied in the following order
    * No Retry
        * TLS certificate verification error
        * Too many redirects error
        * Scheme error
        * Invalid header error
        * Response is nil
    * Retry
        * Status Code is 429 Too Many Requests
        * Status Code is 500 or above (but not Status Code 501 Not Implemented)
        * Status Code is 0


## Examples

```go
// Retry configuration can be set at the client or request level
client.
    SetRetryCount(3).
    SetRetryWaitTime(2 * time.Second).
    SetRetryMaxWaitTime(5 * time.Second)
```

### Constant Delay

Use a custom retry strategy approach to perform constant/fixed delay.

```go
// Retry configuration can be set at the client or request level
client.
    SetRetryStrategy(func(_ *resty.Response, _ error) (time.Duration, error) {
        return 3 * time.Second, nil
    })
```

### Retry Hook

Utilize the retry hook(s) to perform logic between retries.

```go
// Retry configuration can be set at the client or request level
client.
    AddRetryHook(func(res *resty.Response, err error) {
        // perform logic here
    })
```

### Retry Conditions

```go
// Retry configuration can be set at the client or request level
// NOTE: first default retry conditions get applied
//       before user-defined retry conditions
client.
    AddRetryCondition(func(res *resty.Response, err error) bool {
        // perform logic here

        // return true if retry is required otherwise, return false
        return true
    })
```


## Methods

### Client

* [Client.SetRetryCount]({{% godoc v3 %}}Client.SetRetryCount)
* [Client.SetRetryWaitTime]({{% godoc v3 %}}Client.SetRetryWaitTime)
* [Client.SetRetryMaxWaitTime]({{% godoc v3 %}}Client.SetRetryMaxWaitTime)
* [Client.SetRetryStrategy]({{% godoc v3 %}}Client.SetRetryStrategy)
* [Client.SetRetryDefaultConditions]({{% godoc v3 %}}Client.SetRetryDefaultConditions)
* [Client.AddRetryHook]({{% godoc v3 %}}Client.AddRetryHook)
* [Client.AddRetryCondition]({{% godoc v3 %}}Client.AddRetryCondition)


### Request

* [Request.SetRetryCount]({{% godoc v3 %}}Request.SetRetryCount)
* [Request.SetRetryWaitTime]({{% godoc v3 %}}Request.SetRetryWaitTime)
* [Request.SetRetryMaxWaitTime]({{% godoc v3 %}}Request.SetRetryMaxWaitTime)
* [Request.SetRetryStrategy]({{% godoc v3 %}}Request.SetRetryStrategy)
* [Request.SetRetryDefaultConditions]({{% godoc v3 %}}Request.SetRetryDefaultConditions)
* [Request.AddRetryHook]({{% godoc v3 %}}Request.AddRetryHook)
* [Request.AddRetryCondition]({{% godoc v3 %}}Request.AddRetryCondition)
