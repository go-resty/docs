---
bookHidden: true
---

# v3 Upgrade Guide

Resty v3 release brings many new features, enhancements, and breaking changes. This page outlines upgrading Resty to v3.

## Update go.mod

Resty v3 provides a Go vanity URL.

```bash
require resty.dev/v3 {{% param Resty.V3.Version %}}
```

## Breaking Changes

I made necessary breaking changes to improve Resty and open up future growth possibilities.

### Changed

* All the Resty errors start with `resty: ...` prefix and sub feature errors contain feature name in them, e.g., `resty: digest: ...`
* Add `defer client.Close()` after the Client creation.

#### Behavior

* The content length option no longer applies to the `io.Reader` flow.
* By default, payload is not supported in HTTP verb DELETE. Use [Client.AllowMethodDeletePayload]({{% godoc v3 %}}Client.AllowMethodDeletePayload) or [Request.AllowMethodDeletePayload]({{% godoc v3 %}}Request).
* [Retry Mechanism]({{% relref "retry-mechanism" %}})
    * Respects header `Retry-After` if present
    * Resets reader on retry request if the `io.ReadSeeker` interface is supported.
    * Retries only on Idempotent HTTP Verb - GET, HEAD, PUT, DELETE, OPTIONS, and TRACE ([RFC 9110](https://datatracker.ietf.org/doc/html/rfc9110.html#name-method-registration), [RFC 5789](https://datatracker.ietf.org/doc/html/rfc5789.html)),
        * Use [Client.SetAllowNonIdempotentRetry]({{% godoc v3 %}}Client.SetAllowNonIdempotentRetry) or [Request.SetAllowNonIdempotentRetry]({{% godoc v3 %}}Request.SetAllowNonIdempotentRetry). If additional control is necessary, utilize the custom retry condition.
    * Applies [default retry conditions]({{% relref "retry-mechanism#default-conditions" %}})
        * It can be disabled via [Client.SetRetryDefaultConditions]({{% godoc v3 %}}Client.SetRetryDefaultConditions) or [Request.SetRetryDefaultConditions]({{% godoc v3 %}}Request.SetRetryDefaultConditions)
* [Multipart]({{% relref "multipart" %}})
    * By default, Resty streams the content in the request body when a file or `io.Reader` is detected in the MultipartField input.
* [Redirect]({{% relref "redirect-policy" %}})
    * [NoRedirectPolicy]({{% godoc v3 %}}NoRedirectPolicy) returns an error `http.ErrUseLastResponse`
* All response middleware executes regardless of the `error`. Instead, it cascades the error to downstream response middleware.
    * It is recommended that the error be checked to determine whether to continue or skip the logic execution.
* By default, Resty does not set the header `Accept` for requests.
* Digest auth is supported only at the client level; create a dedicated client to utilize it.
* It does not use `http.Client.Timeout` instead, it uses context with [timeout]({{% relref "timeout" %}}).
* Generate `curl` command flow is independent. It does not require debugging or tracing to be enabled.

#### Client

* Client Getter Methods - Added thread safety to the client settings modification, so all the getter fields become methods.
    * For Example:
        * `Client.BaseURL => Client.BaseURL()`
        * `Client.FormData => Client.FormData()`
        * `Client.Header => Client.Header()`
        * etc.
* Getter naming convention alignment - `Client.GetClient()` => [Client.Client()]({{% godoc v3 %}}Client.Client)
* `Client.Token` => [Client.AuthToken]({{% godoc v3 %}}Client.AuthToken)
* [Client.SetDebugBodyLimit]({{% godoc v3 %}}Client.SetDebugBodyLimit) - datatype changed from `int64` to `int`
* [Client.ResponseBodyLimit]({{% godoc v3 %}}Client.ResponseBodyLimit) - datatype changed from `int` to `int64`
* `Client.SetAllowGetMethodPayload` => [Client.SetAllowMethodGetPayload]({{% godoc v3 %}}Client.SetAllowMethodGetPayload)
* `Client.Clone()` => [Client.Clone(ctx context.Context)]({{% godoc v3 %}}Client.Clone)
* `Client.EnableGenerateCurlOnDebug` => [Client.EnableGenerateCurlCmd]({{% godoc v3 %}}Client.EnableGenerateCurlCmd)
* `Client.DisableGenerateCurlOnDebug` => [Client.DisableGenerateCurlCmd]({{% godoc v3 %}}Client.DisableGenerateCurlCmd)
* `Client.SetRootCertificate` => [Client.SetRootCertificates]({{% godoc v3 %}}Client.SetRootCertificates)
* `Client.SetClientRootCertificate` => [Client.SetClientRootCertificates]({{% godoc v3 %}}Client.SetClientRootCertificates)
* `Client.Debug` => [Client.IsDebug]({{% godoc v3 %}}Client.IsDebug)
* `Client.DisableWarn` => [Client.IsDisableWarn]({{% godoc v3 %}}Client.IsDisableWarn)
* `Client.AddRetryCondition` => [Client.AddRetryConditions]({{% godoc v3 %}}Client.AddRetryConditions)
* `Client.AddRetryHook` => [Client.AddRetryHooks]({{% godoc v3 %}}Client.AddRetryHooks)
* `Client.SetRetryAfter` => [Client.SetRetryStrategy]({{% godoc v3 %}}Client.SetRetryStrategy)
* `Client.OnRequestLog` => [Client.OnRequestDebugLog]({{% godoc v3 %}}Client.OnRequestDebugLog)
* `Client.OnResponseLog` => [Client.OnResponseDebugLog]({{% godoc v3 %}}Client.OnResponseDebugLog)
* `Client.Transport` => [Client.HTTPTransport]({{% godoc v3 %}}Client.HTTPTransport) new method returns `http.Transport`
    * [Client.Transport]({{% godoc v3 %}}Client.Transport) method does exist in v3, which returns `http.RoundTripper`
* `Client.OnBeforeRequest` => [Client.AddRequestMiddleware]({{% godoc v3 %}}Client.AddRequestMiddleware)
* `Client.OnAfterResponse` => [Client.AddResponseMiddleware]({{% godoc v3 %}}Client.AddResponseMiddleware)

#### Request

* `Request.QueryParam` => [Request.QueryParams]({{% godoc v3 %}}Request)
* `Request.Token` => [Request.AuthToken]({{% godoc v3 %}}Request)
* `Request.NotParseResponse` => [Request.DoNotParseResponse]({{% godoc v3 %}}Request)
* `Request.ExpectContentType` => [Request.SetExpectResponseContentType]({{% godoc v3 %}}Request.SetExpectResponseContentType)
* `Request.ForceContentType` => [Request.SetForceResponseContentType]({{% godoc v3 %}}Request.SetForceResponseContentType)
* `Request.SetOutput` => [Request.SetOutputFileName]({{% godoc v3 %}}Request.SetOutputFileName)
* `Request.EnableGenerateCurlOnDebug` => [Request.EnableGenerateCurlCmd]({{% godoc v3 %}}Request.EnableGenerateCurlCmd)
* `Request.DisableGenerateCurlOnDebug` => [Request.DisableGenerateCurlCmd]({{% godoc v3 %}}Request.DisableGenerateCurlCmd)
* `Request.GenerateCurlCommand` => [Request.CurlCmd]({{% godoc v3 %}}Request.CurlCmd)
* `Request.AddRetryCondition` => [Request.AddRetryConditions]({{% godoc v3 %}}Request.AddRetryConditions)

#### Multipart

* `MultipartField.Param` => [MultipartField.Name]({{% godoc v3 %}}MultipartField)

#### Package Level

* Retry
    * `OnRetryFunc` => [RetryHookFunc]({{% godoc v3 %}}RetryHookFunc)
    * `RetryStrategyFunc` => [RetryStrategyFunc]({{% godoc v3 %}}RetryStrategyFunc)
* Debug Log
    * `RequestLogCallback` and `ResponseLogCallback` => [DebugLogCallback]({{% godoc v3 %}}DebugLogCallback)


### Removed

#### Client

* `Client.SetHostURL` - use [Client.SetBaseURL]({{% godoc v3 %}}Client.SetBaseURL) instead.
* `Client.{SetJSONMarshaler, SetJSONUnmarshaler, SetXMLMarshaler, SetXMLUnmarshaler}` - use [Client.AddContentTypeEncoder]({{% godoc v3 %}}Client.AddContentTypeEncoder) and [Client.AddContentTypeDecoder]({{% godoc v3 %}}Client.AddContentTypeDecoder) instead.
* `Client.RawPathParams` - use `Client.PathParams()` instead.
* `Client.UserInfo`
* `Client.SetRetryResetReaders` - it happens automatically.
* `Client.SetRetryAfter` - use [Client.SetRetryStrategy]({{% godoc v3 %}}Client.SetRetryStrategy) or [Request.SetRetryStrategy]({{% godoc v3 %}}Request.SetRetryStrategy) instead.
* `Client.RateLimiter` and `Client.SetRateLimiter` - Retry respects header `Retry-After` if present
* `Client.AddRetryAfterErrorCondition` - use [Client.AddRetryConditions]({{% godoc v3 %}}Client.AddRetryConditions) instead.
* `Client.SetPreRequestHook` - use [Client.SetRequestMiddlewares]({{% godoc v3 %}}Client.SetRequestMiddlewares) instead. Refer to [docs]({{% relref "request-middleware" %}}).

#### Request

* `Request.RawPathParams` - use [Request.PathParams]({{% godoc v3 %}}Request) instead
* `Request.UserInfo`
* `Request.SRV` and `Request.SetSRV` - use [NewSRVWeightedRoundRobin]({{% godoc v3 %}}NewSRVWeightedRoundRobin) and [Client.SetLoadBalancer]({{% godoc v3 %}}Client.SetLoadBalancer) instead. It respects weight value from SRV record
* `Request.SetDigestAuth` - use [Client.SetDigestAuth] instead.


#### Response

* `Response.SetBody`
* `Response.Body()`


#### Package Level

##### Types

* `User` - become unexported as `credentials`.
* `SRVRecord` - in favor of new [Load Balancer feature]({{% relref "load-balancer-and-service-discovery" %}}) that supports SRV record lookup.
* `File` - in favor of enhanced [MultipartField]({{% godoc v3 %}}MultipartField) feature.
* `RequestLog`, `ResponseLog` => use [DebugLog]({{% godoc v3 %}}DebugLog) instead.

##### Methods

* `IsStringEmpty`
* `IsJSONType`
* `IsXMLType`
* `DetectContentType`
* `Unmarshalc`
* `Backoff`
