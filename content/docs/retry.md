
# Retry

The retry plays a crucial role in modern system integration by enabling effective handling of failures.

Resty provides exponential backoff with a jitter strategy out of the box; a custom retry strategy could be employed to override this default.

{{% hintreqoverride %}}

## Default Values

* Retry count is `0`
    * Total retry attempts = `first attempt + retry count`
* Retry minimum wait time is `100ms`
* Retry maximum wait time is `2000ms`
* Retry strategy is exponential backoff with a jitter


## Default Behavior

* Request values are inherited from the client upon creation; they do not refresh during a retry attempt. Therefore, value updates are performed on the request instance via [Response.Request]({{% godoc v3 %}}Response).
* Applies [default retry conditions]({{% relref "#default-conditions" %}}) first before user-defined retry conditions.
    * It can be disabled via [Client.SetRetryDefaultConditions]({{% godoc v3 %}}Client.SetRetryDefaultConditions) or [Request.SetRetryDefaultConditions]({{% godoc v3 %}}Request.SetRetryDefaultConditions)
* Executes request retry conditions first, then the client retry conditions, until it gets the return value `true`. Then, it doesn't proceed to execute the remaining conditions.
* Executes request retry hooks first, and then the client retry hooks.
* Respects header `Retry-After` if present.
* Resets reader automatically on retry request if the `io.ReadSeeker` interface is supported.
* Retries only on Idempotent HTTP Verb - GET, HEAD, PUT, DELETE, OPTIONS, and TRACE ([RFC 9110](https://datatracker.ietf.org/doc/html/rfc9110.html#name-method-registration), [RFC 5789](https://datatracker.ietf.org/doc/html/rfc5789.html))
    * Use [Client.SetAllowNonIdempotentRetry]({{% godoc v3 %}}Client.SetAllowNonIdempotentRetry) or [Request.SetAllowNonIdempotentRetry]({{% godoc v3 %}}Request.SetAllowNonIdempotentRetry). If additional control is necessary, utilize the custom retry condition.
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

There are two possible approaches to perform constant delay retry.

#### Using Wait Time

 ```go
 // Retry configuration can be set at the client or request level
// set same value for both min and max wait time
constantDelay := 2 * time.Second
client.
    SetRetryCount(3).
    SetRetryWaitTime(constantDelay).
    SetRetryMaxWaitTime(constantDelay)
```

#### Using Delay Strategy

```go
// Retry configuration can be set at the client or request level
client.
    SetRetryCount(3).
    SetRetryDelayStrategy(resty.RetryConstantDelayStrategy(2 * time.Second))
```

### Retry Hooks

Utilize the retry hook(s) to perform logic between retries.

- Retry hooks are executed in the order in which they are added.
- Retry hooks are executed on each retry attempt.
- Request-level retry hooks are executed before client-level hooks.

#### Add at Client

```go
// Retry configuration can be set at the client or request level
client.
    AddRetryHooks(
        func(res *resty.Response, err error) {
            // client retry hook 1
            // perform logic here
            // access Request instance via res.Request e.g. res.Request.Attempt
        },
        func(res *resty.Response, err error) {
            // client retry hook 2
            // perform logic here
            // access Request instance via res.Request e.g. res.Request.Attempt
        },
    )
```

#### Add at Request

```go
client.R().
    AddRetryHooks(
        func(res *resty.Response, err error) {
            // request retry hook
            // perform logic here
            // access Request instance via res.Request e.g. res.Request.Attempt
        },
    )
```

#### Overwrite at Request

If a specific use case requires certain retry hooks only for a particular request and does not want the client to retry hooks, use [Request.SetRetryHooks]({{% godoc v3 %}}Request.SetRetryHooks).

```go
client.R().
    SetRetryHooks(
        func(res *resty.Response, err error) {
            // request retry hook 1
            // perform logic here
            // access Request instance via res.Request e.g. res.Request.Attempt
        },
        func(res *resty.Response, err error) {
            // request retry hook 2
            // perform logic here
            // access Request instance via res.Request e.g. res.Request.Attempt
        },
    )
```

### Retry Conditions

Utilize the retry condition(s) to determine whether a retry is required.

- Retry conditions are executed in the order in which they are added.
- Once a retry condition returns `true`, the remaining retry conditions are not executed.
- Retry conditions are executed on each retry attempt.
- Default retry conditions are executed first.
- Client-level retry conditions are applied to all requests.
- Request-level retry conditions are executed before client-level retry conditions.

#### Add at Client

```go
// Retry configuration can be set at the client or request level
client.
    AddRetryConditions(
        func(res *resty.Response, err error) bool {
            // client retry condition 1
            // perform logic here
            // access Request instance via res.Request e.g. res.Request.Attempt

            // return true if retry is required otherwise, return false
            return false
        },
        func(res *resty.Response, err error) bool {
            // client retry condition 1
            // perform logic here
            // access Request instance via res.Request e.g. res.Request.Attempt

            // return true if retry is required otherwise, return false
            return true
        },
    )
```

#### Add at Request

```go
client.R().
    AddRetryConditions(
        func(res *resty.Response, err error) bool {
            // request retry condition
            // perform logic here
            // access Request instance via res.Request e.g. res.Request.Attempt

            // return true if retry is required otherwise, return false
            return true
        },
    )
```

#### Overwrite at Request

If a specific use case requires certain retry conditions only for a particular request and does not want the client to retry conditions, use [Request.SetRetryConditions]({{% godoc v3 %}}Request.SetRetryConditions).

```go
client.R().
    SetRetryConditions(
        func(res *resty.Response, err error) bool {
            // request retry condition 1
            // perform logic here
            // access Request instance via res.Request e.g. res.Request.Attempt

            // return true if retry is required otherwise, return false
            return false
        },
        func(res *resty.Response, err error) bool {
            // request retry condition 2
            // perform logic here
            // access Request instance via res.Request e.g. res.Request.Attempt

            // return true if retry is required otherwise, return false
            return true
        },
    )
```

### Retry Delay Strategy

By default, Resty uses a capped exponential backoff with a jitter delay strategy to calculate the delay between retries. It also provides an option to use a custom retry delay strategy. See [Client.SetRetryDelayStrategy]({{% godoc v3 %}}Request.SetRetryDelayStrategy), [Request.SetRetryDelayStrategy]({{% godoc v3 %}}Request.SetRetryDelayStrategy).

And ready to use retry delay strategies are available:

* [RetryConstantDelayStrategy]({{% godoc v3 %}}RetryConstantDelayStrategy)

```go
// create custom retry delay strategy
customRetryDelayStrategy := func(*Response, error) (time.Duration, error) {
    // perform logic here
    // access Request instance via res.Request e.g. res.Request.Attempt

    return 2 * time.Second, nil
}

// Retry configuration can be set at the client or request level
client.
    SetRetryDelayStrategy(customRetryDelayStrategy)
```

## Methods

### Client

* [Client.SetRetryCount]({{% godoc v3 %}}Client.SetRetryCount)
* [Client.SetRetryWaitTime]({{% godoc v3 %}}Client.SetRetryWaitTime)
* [Client.SetRetryMaxWaitTime]({{% godoc v3 %}}Client.SetRetryMaxWaitTime)
* [Client.SetRetryDelayStrategy]({{% godoc v3 %}}Client.SetRetryDelayStrategy)
* [Client.SetRetryDefaultConditions]({{% godoc v3 %}}Client.SetRetryDefaultConditions)
* [Client.AddRetryHooks]({{% godoc v3 %}}Client.AddRetryHooks)
* [Client.AddRetryConditions]({{% godoc v3 %}}Client.AddRetryConditions)


### Request

* [Request.SetRetryCount]({{% godoc v3 %}}Request.SetRetryCount)
* [Request.SetRetryWaitTime]({{% godoc v3 %}}Request.SetRetryWaitTime)
* [Request.SetRetryMaxWaitTime]({{% godoc v3 %}}Request.SetRetryMaxWaitTime)
* [Request.SetRetryDelayStrategy]({{% godoc v3 %}}Request.SetRetryDelayStrategy)
* [Request.SetRetryDefaultConditions]({{% godoc v3 %}}Request.SetRetryDefaultConditions)
* [Request.AddRetryHooks]({{% godoc v3 %}}Request.AddRetryHooks)
* [Request.SetRetryHooks]({{% godoc v3 %}}Request.SetRetryHooks)
* [Request.AddRetryConditions]({{% godoc v3 %}}Request.AddRetryConditions)
* [Request.SetRetryConditions]({{% godoc v3 %}}Request.SetRetryConditions)
