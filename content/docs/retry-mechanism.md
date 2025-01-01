
# Retry Mechanism

The retry mechanism plays a crucial role in modern system integration by enabling effective handling of failures.

Resty provides exponential backoff with a jitter strategy out of the box; a custom retry strategy could be employed to override this default.

{{% hint info %}}
**Hint:** Combining the Retry strategy with [Circuit Breaker]({{% relref "circuit-breaker" %}}) typically provides a comprehensive approach to handling failures.
{{% /hint %}}


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
    * Use [Client.SetAllowNonIdempotentRetry]({{% param Resty.V3.GoDocLinkPrefix %}}Client.SetAllowNonIdempotentRetry) or [Request.SetAllowNonIdempotentRetry]({{% param Resty.V3.GoDocLinkPrefix %}}Request.SetAllowNonIdempotentRetry). If additional control is necessary, utilize the custom retry condition.
* Applies [default retry conditions]({{% relref "#default-conditions" %}})
    * It can be disabled via [Client.SetRetryDefaultConditions]({{% param Resty.V3.GoDocLinkPrefix %}}Client.SetRetryDefaultConditions) or [Request.SetRetryDefaultConditions]({{% param Resty.V3.GoDocLinkPrefix %}}Request.SetRetryDefaultConditions)


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

* [Client.SetRetryCount]({{% param Resty.V3.GoDocLinkPrefix %}}Client.SetRetryCount)
* [Client.SetRetryWaitTime]({{% param Resty.V3.GoDocLinkPrefix %}}Client.SetRetryWaitTime)
* [Client.SetRetryMaxWaitTime]({{% param Resty.V3.GoDocLinkPrefix %}}Client.SetRetryMaxWaitTime)
* [Client.SetRetryStrategy]({{% param Resty.V3.GoDocLinkPrefix %}}Client.SetRetryStrategy)
* [Client.SetRetryDefaultConditions]({{% param Resty.V3.GoDocLinkPrefix %}}Client.SetRetryDefaultConditions)
* [Client.AddRetryHook]({{% param Resty.V3.GoDocLinkPrefix %}}Client.AddRetryHook)
* [Client.AddRetryCondition]({{% param Resty.V3.GoDocLinkPrefix %}}Client.AddRetryCondition)


### Request

* [Request.SetRetryCount]({{% param Resty.V3.GoDocLinkPrefix %}}Request.SetRetryCount)
* [Request.SetRetryWaitTime]({{% param Resty.V3.GoDocLinkPrefix %}}Request.SetRetryWaitTime)
* [Request.SetRetryMaxWaitTime]({{% param Resty.V3.GoDocLinkPrefix %}}Request.SetRetryMaxWaitTime)
* [Request.SetRetryStrategy]({{% param Resty.V3.GoDocLinkPrefix %}}Request.SetRetryStrategy)
* [Request.SetRetryDefaultConditions]({{% param Resty.V3.GoDocLinkPrefix %}}Request.SetRetryDefaultConditions)
* [Request.AddRetryHook]({{% param Resty.V3.GoDocLinkPrefix %}}Request.AddRetryHook)
* [Request.AddRetryCondition]({{% param Resty.V3.GoDocLinkPrefix %}}Request.AddRetryCondition)
