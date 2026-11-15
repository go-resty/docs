
# Retry

Retry plays a crucial role in modern system integration by helping handle failures effectively.

Resty provides exponential backoff with a jitter strategy out of the box; a custom retry strategy can be used to override this default.

> [!NOTE]
> Combining retry with [Circuit Breaker]({{% relref "circuit-breaker" %}}) provides a comprehensive approach to transient and sustained failures.

{{% hintreqoverride %}}

## Default Values

* Retry count is `0`
    * Total retry attempts = `first attempt + retry count`
* Retry minimum wait time is `100ms`
* Retry maximum wait time is `2000ms`
* Retry strategy is exponential backoff with a jitter


## Default Behavior

* Request values are inherited from the client upon creation; they do not refresh during a retry attempt. Therefore, value updates are performed on the request instance via [Response.Request]({{% godoc v3 %}}Response).
* Applies [default retry conditions]({{% relref "#default-conditions" %}}) before user-defined retry conditions.
    * This can be disabled via [Client.SetRetryDefaultConditions]({{% godoc v3 %}}Client.SetRetryDefaultConditions) or [Request.SetRetryDefaultConditions]({{% godoc v3 %}}Request.SetRetryDefaultConditions)
* Executes request retry conditions first, then client retry conditions, until one returns `true`. Remaining conditions are not executed.
* Executes request retry hooks first, then client retry hooks.
* Respects header `Retry-After` if present.
* Resets the reader automatically before a retry request if the `io.ReadSeeker` interface is supported. Otherwise it throws [ErrReaderNotSeekable]({{% godoc v3 %}}ErrReaderNotSeekable)
* Retries only idempotent HTTP verbs: GET, HEAD, PUT, DELETE, OPTIONS, and TRACE ([RFC 9110](https://datatracker.ietf.org/doc/html/rfc9110.html#name-method-registration), [RFC 5789](https://datatracker.ietf.org/doc/html/rfc5789.html))
    * Use [Client.SetRetryAllowNonIdempotent]({{% godoc v3 %}}Client.SetRetryAllowNonIdempotent) or [Request.SetRetryAllowNonIdempotent]({{% godoc v3 %}}Request.SetRetryAllowNonIdempotent). If additional control is necessary, use a custom retry condition.
* [Request.CorrelationID]({{% godoc v3 %}}Request) - a GUID is generated when retry count > 0

## Retrying Non-Idempotent Requests

By default, Resty retries only idempotent HTTP methods. Setting `SetRetryCount` on a client that mostly sends `POST` or `PATCH` requests will not retry those requests unless non-idempotent retries are explicitly enabled.

```go
client.
    SetRetryCount(2).
    SetRetryAllowNonIdempotent(true)
```

You can enable this per request when only one endpoint is safe to retry.

```go
res, err := client.R().
    SetRetryCount(2).
    SetRetryAllowNonIdempotent(true).
    SetBody(payload).
    Post("/v1/messages")
```

Only enable non-idempotent retries for operations that are safe for your API, such as requests protected by idempotency keys or endpoints where duplicate processing is acceptable.

## Retrying Request Bodies

Resty automatically resets request bodies that implement `io.ReadSeeker` before a retry. Non-seekable reader bodies cannot be replayed safely, so Resty returns `ErrReaderNotSeekable` instead of sending a retry with an empty or partially-consumed body.

For retried requests with bodies, prefer `[]byte`, `string`, `*bytes.Reader`, `*strings.Reader`, or another `io.ReadSeeker`. For multipart uploads, prefer `FilePath` or ensure `MultipartField.Reader` implements `io.ReadSeeker`.

> [!WARNING]
> Retried reader bodies must be rewindable. Resty returns `ErrReaderNotSeekable` when a retry needs to reuse a non-seekable `io.Reader` set with `SetBody` or a non-seekable `MultipartField.Reader`.


## Default Conditions

* Conditions are applied in the following order:
    * No Retry
        * TLS certificate verification error
        * Too many redirects error
        * Scheme error
        * Invalid header error
        * Response is nil
    * Retry
        * Temporary URL error


## Examples

```go
// Retry configuration can be set at the client or request level
client.
    SetRetryCount(3).
    SetRetryWaitTime(2 * time.Second).
    SetRetryMaxWaitTime(5 * time.Second)
```

### Constant Delay

There are two ways to use a constant retry delay.

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

Use retry hooks to run logic between retries.

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

If a specific use case requires retry hooks only for a particular request and should not use the client retry hooks, use [Request.SetRetryHooks]({{% godoc v3 %}}Request.SetRetryHooks).

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

Use retry conditions to determine whether a retry is required.

- Retry conditions are executed in the order in which they are added.
- Once a retry condition returns `true`, the remaining retry conditions are not executed.
- Retry conditions are executed on each retry attempt.
- Default retry conditions are executed first; they do not check HTTP status codes.
- Client-level retry conditions are applied to all requests.
- Request-level retry conditions are executed before client-level retry conditions.

Out-of-the-box, Resty v3 provides:

* [RetryConditionStatusTooManyRequests]({{% godoc v3 %}}RetryConditionStatusTooManyRequests)
* [RetryConditionStatus5XX]({{% godoc v3 %}}RetryConditionStatus5XX)
* [RetryConditionStatusZero]({{% godoc v3 %}}RetryConditionStatusZero)


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

If a specific use case requires retry conditions only for a particular request and should not use the client retry conditions, use [Request.SetRetryConditions]({{% godoc v3 %}}Request.SetRetryConditions).

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

#### Retry Counts per Status Code

Use a request-level condition to give each HTTP status code its own retry count. This example allows one retry after HTTP 401 and three after HTTP 428, with a total limit of four retries (five attempts).

```go
func requestWithRetryCounts(client *resty.Client) *resty.Request {
    remaining := map[int]int{
        http.StatusUnauthorized:         1,
        http.StatusPreconditionRequired: 3,
    }

    return client.R().
        SetRetryCount(4).
        SetRetryDefaultConditions(false).
        SetRetryConditions(func(res *resty.Response, err error) bool {
            if err != nil || res == nil {
                return false
            }
            code := res.StatusCode()
            if remaining[code] == 0 {
                return false
            }
            remaining[code]--
            return true
        })
}
```

The example uses `net/http` and `resty.dev/v3`. Call `requestWithRetryCounts(client)` for each new request so its counters start fresh, then execute it with a method such as `Get`. `SetRetryConditions` replaces inherited conditions, and `SetRetryDefaultConditions(false)` disables the default transport-error retries.

A sequence of `401, 428, 428, 428, 200` succeeds on the fifth attempt. A sequence of `428, 401, 428, 401` stops at the second 401, even though the total retry limit has not been reached. An unconfigured status ends the request. The [token refresh example]({{% relref "#refreshing-a-token-and-returning-errors" %}}) shows how to obtain a new token before retrying a 401.

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

#### Refreshing a Token and Returning Errors

A custom delay strategy can return an error to stop retrying and propagate that error to the caller. Use it to handle a failed token refresh before another attempt is sent.

```go
func requestWithTokenRefresh(
    client *resty.Client,
    accessToken string,
    refresh func() (string, error),
) *resty.Request {
    return client.R().
        SetAuthToken(accessToken).
        SetRetryCount(1).
        SetRetryDefaultConditions(false).
        SetRetryConditions(func(res *resty.Response, err error) bool {
            return err == nil && res != nil &&
                res.StatusCode() == http.StatusUnauthorized
        }).
        SetRetryDelayStrategy(func(res *resty.Response, _ error) (time.Duration, error) {
            token, err := refresh()
            if err != nil {
                return 0, fmt.Errorf("refresh token: %w", err)
            }
            res.Request.SetAuthToken(token)
            return 0, nil
        })
}
```

The example uses `fmt`, `net/http`, `time`, and `resty.dev/v3`. Supply the current access token and your application's refresh function, then execute the returned request, for example with `Get`. The refresh function returns a new token or an error. The wrapped error is returned by `Get` and can be checked with `errors.Is`.

The condition restricts refresh to HTTP 401. After a successful refresh, the zero delay retries immediately with the new token set on the request. An initial success skips refresh, and another 401 ends the request after two attempts and one refresh. This count applies to each request independently.

## Methods

### Client

* [Client.SetRetryCount]({{% godoc v3 %}}Client.SetRetryCount)
* [Client.SetRetryWaitTime]({{% godoc v3 %}}Client.SetRetryWaitTime)
* [Client.SetRetryMaxWaitTime]({{% godoc v3 %}}Client.SetRetryMaxWaitTime)
* [Client.SetRetryDelayStrategy]({{% godoc v3 %}}Client.SetRetryDelayStrategy)
* [Client.SetRetryDefaultConditions]({{% godoc v3 %}}Client.SetRetryDefaultConditions)
* [Client.SetRetryAllowNonIdempotent]({{% godoc v3 %}}Client.SetRetryAllowNonIdempotent)
* [Client.AddRetryHooks]({{% godoc v3 %}}Client.AddRetryHooks)
* [Client.AddRetryConditions]({{% godoc v3 %}}Client.AddRetryConditions)


### Request

* [Request.SetRetryCount]({{% godoc v3 %}}Request.SetRetryCount)
* [Request.SetRetryWaitTime]({{% godoc v3 %}}Request.SetRetryWaitTime)
* [Request.SetRetryMaxWaitTime]({{% godoc v3 %}}Request.SetRetryMaxWaitTime)
* [Request.SetRetryDelayStrategy]({{% godoc v3 %}}Request.SetRetryDelayStrategy)
* [Request.SetRetryDefaultConditions]({{% godoc v3 %}}Request.SetRetryDefaultConditions)
* [Request.SetRetryAllowNonIdempotent]({{% godoc v3 %}}Request.SetRetryAllowNonIdempotent)
* [Request.AddRetryHooks]({{% godoc v3 %}}Request.AddRetryHooks)
* [Request.SetRetryHooks]({{% godoc v3 %}}Request.SetRetryHooks)
* [Request.AddRetryConditions]({{% godoc v3 %}}Request.AddRetryConditions)
* [Request.SetRetryConditions]({{% godoc v3 %}}Request.SetRetryConditions)
