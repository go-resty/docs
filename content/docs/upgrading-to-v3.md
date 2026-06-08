---
bookHidden: true
---

# v3 Upgrade Guide

Resty v3 release brings many new features, enhancements, and breaking changes. This page outlines upgrading Resty to v3.

> [!NOTE]
> Minimum required go version is `{{% param Resty.V3.GoMinVersion %}}`

## Update go.mod and imports

Resty v3 provides a Go vanity URL.

```bash
require resty.dev/v3 {{% param Resty.V3.Version %}}
```

Update imports from v2 to the v3 vanity import path.

```go
import "resty.dev/v3"
```

## Common Migration Patterns

Common v2-to-v3 changes for client wrappers and API integrations.

### Client lifecycle

Resty v2 did not have a `Client.Close` method. Resty v3 adds one to run close hooks and stop client-owned background resources, such as certificate watchers and load balancers. Do not close the client after each request; for long-lived clients, close it during application shutdown.

```go
client := resty.New()
defer client.Close()
```

### API error responses

`SetError` and `Response.IsError` were renamed to make a clearer distinction between transport/request errors and HTTP status failures.

```go
var result APIResponse
var apiErr APIError

res, err := client.R().
    SetResult(&result).
    SetResultError(&apiErr).
    Post("/v1/messages")
if err != nil {
    return err // connection, timeout, request preparation, unmarshalling, etc.
}
if res.IsStatusFailure() {
    return apiErr // HTTP status code >= 400
}
```

### Response body access

`Response.Body()` was removed. Use [Response.Bytes]({{% godoc v3 %}}Response.Bytes) or [Response.String]({{% godoc v3 %}}Response.String) for the buffered response body. When automatic unmarshalling consumes the body, enable `SetResponseBodyUnlimitedReads(true)` if you also need `Bytes` or `String` afterward. Use the [Response.Body]({{% godoc v3 %}}Response) field only when response parsing is disabled with `SetResponseDoNotParse(true)`, and close it yourself.

### Request and response hooks

`OnBeforeRequest` and `OnAfterResponse` are now request and response middleware.

```go
client.
    AddRequestMiddleware(func(c *resty.Client, req *resty.Request) error {
        // inspect or mutate req before Resty creates the http.Request
        return nil
    }).
    AddResponseMiddleware(func(c *resty.Client, res *resty.Response) error {
        if res.CascadeError != nil {
            return nil
        }
        // inspect response status, headers, and parsed results
        return nil
    })
```

### Retrying POST, PATCH, and other non-idempotent methods

`SetRetryCount` only enables retries for idempotent methods by default. If your v2 client intentionally retried POST/PATCH requests, opt in explicitly and ensure the request body can be reused safely.

```go
client.
    SetRetryCount(2).
    SetRetryAllowNonIdempotent(true)
```

For `io.Reader` request bodies, use a reader that supports `io.ReadSeeker` so Resty can rewind it before retrying.

> [!WARNING]
> Retried reader bodies must be rewindable. Resty returns `ErrReaderNotSeekable` when a retry needs to reuse a non-seekable `io.Reader` set with `SetBody` or a non-seekable `MultipartField.Reader`. Use `FilePath` or a reader that implements `io.ReadSeeker` for retried multipart uploads.

## Breaking Changes

Resty v3 includes necessary breaking changes to improve the project and support future growth.

### Changed

* All Resty errors start with the `resty: ...` prefix, and sub-feature errors include the feature name, for example, `resty: digest: ...`
* Add `defer client.Close()` after creating the client.

#### Behavior

* By default, the content length value is not set. However, Go’s `net/http` package automatically sets the Content-Length for types `*bytes.Buffer`, `*bytes.Reader`, and `*strings.Reader`, which covers all cases. Therefore, Resty v3 removes the previous boolean method and introduces a new method `SetContentLength(v int64)` at the request level, allowing users to explicitly provide values for file/multipart uploads, etc.
* By default, payload is not supported in HTTP verb DELETE. Use [Client.SetMethodDeleteAllowPayload]({{% godoc v3 %}}Client.SetMethodDeleteAllowPayload) or [Request.SetMethodDeleteAllowPayload]({{% godoc v3 %}}Request.SetMethodDeleteAllowPayload).
* [Retry Mechanism]({{% relref "retry" %}})
    * Request values are inherited from the client upon creation; they do not refresh during a retry attempt. Therefore, value updates are performed on the request instance via [Response.Request]({{% godoc v3 %}}Response).
    * Respects header `Retry-After` if present.
    * Resets reader on retry request if the `io.ReadSeeker` interface is supported.
    * Retries only on Idempotent HTTP Verb - GET, HEAD, PUT, DELETE, OPTIONS, and TRACE ([RFC 9110](https://datatracker.ietf.org/doc/html/rfc9110.html#name-method-registration), [RFC 5789](https://datatracker.ietf.org/doc/html/rfc5789.html)),
        * Use [Client.SetRetryAllowNonIdempotent]({{% godoc v3 %}}Client.SetRetryAllowNonIdempotent) or [Request.SetRetryAllowNonIdempotent]({{% godoc v3 %}}Request.SetRetryAllowNonIdempotent). If additional control is necessary, use a custom retry condition.
    * Applies [default retry conditions]({{% relref "retry#default-conditions" %}})
        * It can be disabled via [Client.SetRetryDefaultConditions]({{% godoc v3 %}}Client.SetRetryDefaultConditions) or [Request.SetRetryDefaultConditions]({{% godoc v3 %}}Request.SetRetryDefaultConditions)
* [Multipart]({{% relref "multipart" %}})
    * By default, Resty streams the content in the request body when a file or `io.Reader` is detected in the MultipartField input.
* [Redirect]({{% relref "redirect-policy" %}})
    * [RedirectNoPolicy]({{% godoc v3 %}}RedirectNoPolicy) returns the error `http.ErrUseLastResponse`
    * Request URL host for comparison does not strip the port; the request URL host is used as-is.
* All response middleware runs regardless of the `error`. Instead, the error is cascaded to downstream response middleware.
    * It is recommended to check the error to determine whether to continue or skip the logic.
* By default, Resty does not set the header `Accept` for requests.
* Digest auth is supported only at the client level; create a dedicated client to use it.
* It does not use `http.Client.Timeout`; instead, it uses context with [timeout]({{% relref "timeout" %}}).
* `curl` command generation is independent. It does not require debugging or tracing to be enabled.

#### Client

* Client Getter Methods - Thread-safe client setting updates were added, so all getter fields became methods.
    * For example:
        * `Client.BaseURL => Client.BaseURL()`
        * `Client.FormData => Client.FormData()`
        * `Client.Header => Client.Header()`
        * etc.
* Getter naming convention alignment - `Client.GetClient()` => [Client.Client()]({{% godoc v3 %}}Client.Client)
* `Client.Token` => [Client.AuthToken]({{% godoc v3 %}}Client.AuthToken)
* `Client.SetError` => [Client.SetResultError]({{% godoc v3 %}}Client.SetResultError)
* [Client.SetDebugBodyLimit]({{% godoc v3 %}}Client.SetDebugBodyLimit) - data type changed from `int64` to `int`
* [Client.ResponseBodyLimit]({{% godoc v3 %}}Client.ResponseBodyLimit) - data type changed from `int` to `int64`
* `Client.SetAllowGetMethodPayload` => [Client.SetMethodGetAllowPayload]({{% godoc v3 %}}Client.SetMethodGetAllowPayload)
* `Client.AllowGetMethodPayload` => [Client.IsMethodGetAllowPayload]({{% godoc v3 %}}Client.IsMethodGetAllowPayload)
* `Client.Clone()` => [Client.Clone(ctx context.Context)]({{% godoc v3 %}}Client.Clone)
* `Client.SetRootCertificate` => [Client.SetRootCertificates]({{% godoc v3 %}}Client.SetRootCertificates)
* `Client.SetClientRootCertificate` => [Client.SetClientRootCertificates]({{% godoc v3 %}}Client.SetClientRootCertificates)
* `Client.Debug` => [Client.IsDebug]({{% godoc v3 %}}Client.IsDebug)
* `Client.DisableWarn` => [Client.IsDisableWarn]({{% godoc v3 %}}Client.IsDisableWarn)
* `Client.AddRetryCondition` => [Client.AddRetryConditions]({{% godoc v3 %}}Client.AddRetryConditions)
* `Client.AddRetryHook` => [Client.AddRetryHooks]({{% godoc v3 %}}Client.AddRetryHooks)
* `Client.SetRetryAfter` => [Client.SetRetryDelayStrategy]({{% godoc v3 %}}Client.SetRetryDelayStrategy)
* `Client.Transport` => [Client.HTTPTransport]({{% godoc v3 %}}Client.HTTPTransport) new method returns `http.Transport`
    * [Client.Transport]({{% godoc v3 %}}Client.Transport) method does exist in v3, which returns `http.RoundTripper`
* `Client.OnBeforeRequest` => [Client.AddRequestMiddleware]({{% godoc v3 %}}Client.AddRequestMiddleware)
* `Client.OnAfterResponse` => [Client.AddResponseMiddleware]({{% godoc v3 %}}Client.AddResponseMiddleware)
* `Client.OutputDirectory` => [Client.ResponseSaveDirectory]({{% godoc v3 %}}Client.ResponseSaveDirectory)
* `Client.SetOutputDirectory` => [Client.SetResponseSaveDirectory]({{% godoc v3 %}}Client.SetResponseSaveDirectory)
* `Client.SetDoNotParseResponse` => [Client.SetResponseDoNotParse]({{% godoc v3 %}}Client.SetResponseDoNotParse)
* `Client.SetUnescapeQueryParams` => [Client.SetQueryParamsUnescape]({{% godoc v3 %}}Client.SetQueryParamsUnescape)
* `Client.SetDisableWarn` => [Client.SetLoggerWarnLevel]({{% godoc v3 %}}Client.SetLoggerWarnLevel)
* `Client.SetRawPathParam` => [Client.SetPathRawParam]({{% godoc v3 %}}Client.SetPathRawParam)
* `Client.SetRawPathParamAny` => [Client.SetPathRawParamAny]({{% godoc v3 %}}Client.SetPathRawParamAny)
* `Client.SetRawPathParams` => [Client.SetPathRawParams]({{% godoc v3 %}}Client.SetPathRawParams)


#### Request

* `Request.QueryParam` => [Request.QueryParams]({{% godoc v3 %}}Request)
* `Request.Token` => [Request.AuthToken]({{% godoc v3 %}}Request)
* `Request.DoNotParseResponse` => [Request.IsResponseDoNotParse]({{% godoc v3 %}}Request)
* `Request.SetDoNotParseResponse` => [Request.SetResponseDoNotParse]({{% godoc v3 %}}Request.SetResponseDoNotParse)
* `Request.ExpectContentType` => [Request.SetResponseExpectContentType]({{% godoc v3 %}}Request.SetResponseExpectContentType)
* `Request.ForceContentType` => [Request.SetResponseForceContentType]({{% godoc v3 %}}Request.SetResponseForceContentType)
* `Request.SetOutput` => [Request.SetResponseSaveFileName]({{% godoc v3 %}}Request.SetResponseSaveFileName)
* `Request.GenerateCurlCommand` => [Request.CurlCmd]({{% godoc v3 %}}Request.CurlCmd)
* `Request.AddRetryCondition` => [Request.AddRetryConditions]({{% godoc v3 %}}Request.AddRetryConditions)
* `Request.SetContentLength(l bool)` => [Request.SetContentLength(v int64)]({{% godoc v3 %}}Request.SetContentLength)
* `Request.SetUnescapeQueryParams` => [Request.SetQueryParamsUnescape]({{% godoc v3 %}}Request.SetQueryParamsUnescape)
* `Request.SetRawPathParam` => [Request.SetPathRawParam]({{% godoc v3 %}}Request.SetPathRawParam)
* `Request.SetRawPathParams` => [Request.SetPathRawParams]({{% godoc v3 %}}Request.SetPathRawParams)
* `Request.Debug` => [Request.IsDebug]({{% godoc v3 %}}Request)
* `Request.Error` => [Request.ResultError]({{% godoc v3 %}}Request)
* `Request.SetError` => [Request.SetResultError]({{% godoc v3 %}}Request.SetResultError)
* `Request.Time` => [Request.StartTime]({{% godoc v3 %}}Request)
* `Request.EnableTrace` => [Request.SetTrace]({{% godoc v3 %}}Request.SetTrace)


#### Response

* `Response.Time` => [Response.Duration]({{% godoc v3 %}}Response.Duration)
* `Response.IsError()` => [Response.IsStatusFailure]({{% godoc v3 %}}Response.IsStatusFailure)
* `Response.IsSuccess()` => [Response.IsStatusSuccess]({{% godoc v3 %}}Response.IsStatusSuccess)

#### Multipart

* `MultipartField.Param` => [MultipartField.Name]({{% godoc v3 %}}MultipartField)

#### TraceInfo

* `TraceInfo.RemoteAddr` => `net.Addr` to `string`

#### Package Level

* Retry
    * `OnRetryFunc` => [RetryHookFunc]({{% godoc v3 %}}RetryHookFunc)
    * `RetryAfterFunc` => [RetryDelayStrategyFunc]({{% godoc v3 %}}RetryDelayStrategyFunc)
    * `NoRedirectPolicy` => [RedirectNoPolicy]({{% godoc v3 %}}RedirectNoPolicy)
    * `FlexibleRedirectPolicy` => [RedirectFlexiblePolicy]({{% godoc v3 %}}RedirectFlexiblePolicy)
    * `DomainCheckRedirectPolicy` => [RedirectDomainCheckPolicy]({{% godoc v3 %}}RedirectDomainCheckPolicy)


### Removed

#### Client

* `Client.SetHostURL` - use [Client.SetBaseURL]({{% godoc v3 %}}Client.SetBaseURL) instead.
* `Client.{SetJSONMarshaler, SetJSONUnmarshaler, SetXMLMarshaler, SetXMLUnmarshaler}` - use [Client.AddContentTypeEncoder]({{% godoc v3 %}}Client.AddContentTypeEncoder) and [Client.AddContentTypeDecoder]({{% godoc v3 %}}Client.AddContentTypeDecoder) instead.
* `Client.RawPathParams` - use `Client.PathParams()` instead.
* `Client.UserInfo`
* `Client.SetRetryResetReaders` - this is handled automatically.
* `Client.SetRetryAfter` - use [Client.SetRetryDelayStrategy]({{% godoc v3 %}}Client.SetRetryDelayStrategy) or [Request.SetRetryDelayStrategy]({{% godoc v3 %}}Request.SetRetryDelayStrategy) instead.
* `Client.RateLimiter` and `Client.SetRateLimiter` - Retry respects header `Retry-After` if present.
* `Client.AddRetryAfterErrorCondition` - use [Client.AddRetryConditions]({{% godoc v3 %}}Client.AddRetryConditions) instead.
* `Client.SetPreRequestHook` - use [Client.SetRequestMiddlewares]({{% godoc v3 %}}Client.SetRequestMiddlewares) instead. Refer to [docs]({{% relref "request-middleware" %}}).
* `Client.OnRequestLog` => use [Client.OnDebugLog]({{% godoc v3 %}}Client.OnDebugLog) instead.
* `Client.OnResponseLog` => use [Client.OnDebugLog]({{% godoc v3 %}}Client.OnDebugLog) instead.
* `Client.SetContentLength` => use [Request.SetContentLength]({{% godoc v3 %}}Request.SetContentLength) instead.
* `Client.EnableGenerateCurlOnDebug` => use [Client.SetCurlCmdGenerate]({{% godoc v3 %}}Client.SetCurlCmdGenerate) instead.
* `Client.DisableGenerateCurlOnDebug` => use [Client.SetCurlCmdGenerate]({{% godoc v3 %}}Client.SetCurlCmdGenerate) instead.
* `Client.EnableTrace` => use [Client.SetTrace]({{% godoc v3 %}}Client.SetTrace) instead.
* `Client.DisableTrace` => use [Client.SetTrace]({{% godoc v3 %}}Client.SetTrace) instead.


#### Request

* `Request.RawPathParams` - use [Request.PathParams]({{% godoc v3 %}}Request) instead
* `Request.UserInfo`
* `Request.SRV` and `Request.SetSRV` - use [NewSRVWeightedRoundRobin]({{% godoc v3 %}}NewSRVWeightedRoundRobin) and [Client.SetLoadBalancer]({{% godoc v3 %}}Client.SetLoadBalancer) instead. It respects weight value from SRV record
* `Request.SetDigestAuth` - use [Client.SetDigestAuth]({{% godoc v3 %}}Client.SetDigestAuth) instead.


#### Response

* `Response.SetBody`
* `Response.Body()` - use [Response.Bytes]({{% godoc v3 %}}Response.Bytes), [Response.String]({{% godoc v3 %}}Response.String), or the [Response.Body]({{% godoc v3 %}}Response) field when response parsing is disabled


#### Package Level

##### Types

* `User` - became unexported as `credentials`.
* `SRVRecord` - in favor of new [Load Balancer feature]({{% relref "load-balancer-and-service-discovery" %}}) that supports SRV record lookup.
* `File` - in favor of enhanced [MultipartField]({{% godoc v3 %}}MultipartField) feature.
* `RequestLog`, `ResponseLog` => use [DebugLog]({{% godoc v3 %}}DebugLog) instead.
* `RequestLogCallback` and `ResponseLogCallback` => use [DebugLogCallbackFunc]({{% godoc v3 %}}DebugLogCallbackFunc) instead

##### Methods

* `IsStringEmpty`
* `IsJSONType`
* `IsXMLType`
* `DetectContentType`
* `Unmarshalc`
* `Backoff`
