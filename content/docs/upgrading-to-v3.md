---
# title: "v3"
weight: 1
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

#### Behavior

* Set Content length is not applicable for `io.Reader` flow.
* By default, payload is not supported in HTTP verb DELETE. Use [Client.AllowMethodDeletePayload]({{% godoc v3 %}}Client.AllowMethodDeletePayload) or [Request.AllowMethodDeletePayload]({{% godoc v3 %}}Request).
* Retry Mechanism
    * Respects header `Retry-After` if present
    * Resets reader on retry request if the `io.ReadSeeker` interface is supported.
    * Retries only on Idempotent HTTP Verb - GET, HEAD, PUT, DELETE, OPTIONS, and TRACE ([RFC 9110](https://datatracker.ietf.org/doc/html/rfc9110.html#name-method-registration), [RFC 5789](https://datatracker.ietf.org/doc/html/rfc5789.html)),
        * Use [Client.SetAllowNonIdempotentRetry]({{% godoc v3 %}}Client.SetAllowNonIdempotentRetry) or [Request.SetAllowNonIdempotentRetry]({{% godoc v3 %}}Request.SetAllowNonIdempotentRetry). If additional control is necessary, utilize the custom retry condition.
    * Applies [default retry conditions]({{% relref "retry-mechanism#default-conditions" %}})
        * It can be disabled via [Client.SetRetryDefaultConditions]({{% godoc v3 %}}Client.SetRetryDefaultConditions) or [Request.SetRetryDefaultConditions]({{% godoc v3 %}}Request.SetRetryDefaultConditions)
*

#### Client

* Client Getter Methods - Added thread safety to the client settings modification, so all the getter fields become methods.
    * For Example:
        * `Client.BaseURL => Client.BaseURL()`
        * `Client.Debug => Client.IsDebug()`
* Getter naming convention alignment - `Client.GetClient()` => [Client.Client()]({{% godoc v3 %}}Client.Client)
* `Client.Token` => [Client.AuthToken]({{% godoc v3 %}}Client.AuthToken)
* [Client.SetDebugBodyLimit]({{% godoc v3 %}}Client.SetDebugBodyLimit) - datatype changed from `int64` to `int`
* [Client.ResponseBodyLimit]({{% godoc v3 %}}Client.ResponseBodyLimit) - datatype changed from `int` to `int64`
* `Client.SetAllowGetMethodPayload` => [Client.SetAllowMethodGetPayload]({{% godoc v3 %}}Client.SetAllowMethodGetPayload)
* `Client.Clone()` - use [Client.Clone(ctx context.Context)]({{% godoc v3 %}}Client.Clone) instead.
* `Client.EnableGenerateCurlOnDebug` => [Client.EnableGenerateCurlCmd]({{% godoc v3 %}}Client.EnableGenerateCurlCmd)
* `Client.DisableGenerateCurlOnDebug` => [Client.DisableGenerateCurlCmd]({{% godoc v3 %}}Client.DisableGenerateCurlCmd)

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


### Removed

#### Client

* `Client.SetHostURL` - use [Client.SetBaseURL]({{% godoc v3 %}}Client.SetBaseURL) instead.
* `Client.{SetJSONMarshaler, SetJSONUnmarshaler, SetXMLMarshaler, SetXMLUnmarshaler}` - use [Client.AddContentTypeEncoder]({{% godoc v3 %}}Client.AddContentTypeEncoder) and [Client.AddContentTypeDecoder]({{% godoc v3 %}}Client.AddContentTypeDecoder) instead.
* `Client.RawPathParams` - use `Client.PathParams()` instead.
* `Client.UserInfo`
* `Client.SetRetryResetReaders` - it happens automatically.
* `Client.SetRetryAfter` - use [Client.SetRetryStrategy]({{% godoc v3 %}}Client.SetRetryStrategy) or [Request.SetRetryStrategy]({{% godoc v3 %}}Request.SetRetryStrategy) instead.

#### Request

* `Request.RawPathParams` - use [Request.PathParams]({{% godoc v3 %}}Request) instead


#### Response

* `Response.SetBody`
* `Response.Body()`

#### Package Exported Methods

* IsStringEmpty
* IsJSONType
* IsXMLType
* DetectContentType
* Unmarshalc
* Backoff


## New Features and Enhancements

* Override all transport settings and timeout values used by Resty using [NewWithTransportSettings]({{% godoc v3 %}}NewWithTransportSettings)
* [Circuit Breaker]({{% relref "circuit-breaker" %}})
* Set retry settings on Request instance refer to [Retry Mechanism]({{% relref "retry-mechanism" %}})

### New ways to create Client

* [NewWithTransportSettings]({{% godoc v3 %}}NewWithTransportSettings)
* [NewWithDialer]({{% godoc v3 %}}NewWithDialer)
* [NewWithDialerAndTransportSettings]({{% godoc v3 %}}NewWithDialerAndTransportSettings)

### Client

* [Client.Close]({{% godoc v3 %}}Client.Close)
* [Client.AddContentTypeEncoder]({{% godoc v3 %}}Client.AddContentTypeEncoder)
* [Client.AddContentTypeDecoder]({{% godoc v3 %}}Client.AddContentTypeDecoder)
* [Client.SetResponseBodyUnlimitedReads]({{% godoc v3 %}}Client.SetResponseBodyUnlimitedReads)
* [Client.ContentDecompressor]({{% godoc v3 %}}Client.ContentDecompressor)
* [Client.ContentDecompressors]({{% godoc v3 %}}Client.ContentDecompressors)
* [Client.AddContentDecompressor]({{% godoc v3 %}}Client.AddContentDecompressor) - Automatically handles `gzip` and `deflate`
* [Client.ContentDecompressorKeys]({{% godoc v3 %}}Client.ContentDecompressorKeys)
* [Client.SetContentDecompressorKeys]({{% godoc v3 %}}Client.SetContentDecompressorKeys)
* [Client.Context]({{% godoc v3 %}}Client.Context)
* [Client.SetContext]({{% godoc v3 %}}Client.SetContext)
* [Client.Clone]({{% godoc v3 %}}Client.Clone)
* [Client.EnableDebug]({{% godoc v3 %}}Client.EnableDebug)
* [Client.DisableDebug]({{% godoc v3 %}}Client.DisableDebug)
* [Client.IsTrace]({{% godoc v3 %}}Client.IsTrace)
* [Client.IsDisableWarn]({{% godoc v3 %}}Client.IsDisableWarn)
* [Client.AllowMethodDeletePayload]({{% godoc v3 %}}Client.AllowMethodDeletePayload)
* [Client.SetAllowMethodDeletePayload]({{% godoc v3 %}}Client.SetAllowMethodDeletePayload)
* [Client.SetRetryStrategy]({{% godoc v3 %}}Client.SetRetryStrategy)
* [Client.SetRetryDefaultConditions]({{% godoc v3 %}}Client.SetRetryDefaultConditions)
* [Client.IsSaveResponse]({{% godoc v3 %}}Client.IsSaveResponse)
* [Client.SetSaveResponse]({{% godoc v3 %}}Client.SetSaveResponse)
* [Client.SetGenerateCurlCmd]({{% godoc v3 %}}Client.SetGenerateCurlCmd)
* [Client.SetDebugLogCurlCmd]({{% godoc v3 %}}Client.SetDebugLogCurlCmd)

### Request

* [Request.Clone]({{% godoc v3 %}}Request.Clone)
* [Request.WithContext]({{% godoc v3 %}}Request.WithContext)
* [Request.SetResponseBodyUnlimitedReads]({{% godoc v3 %}}Request.SetResponseBodyUnlimitedReads)
* [Request.DebugBodyLimit]({{% godoc v3 %}}Request)
* [Request.EnableDebug]({{% godoc v3 %}}Request.EnableDebug)
* [Request.DisableDebug]({{% godoc v3 %}}Request.DisableDebug)
* [Request.IsTrace]({{% godoc v3 %}}Request)
* [Request.SetTrace]({{% godoc v3 %}}Request.SetTrace)
* [Request.DisableTrace]({{% godoc v3 %}}Request.DisableTrace)
* [Request.Patch]({{% godoc v3 %}}Request.Patch)
* [Request.Trace]({{% godoc v3 %}}Request.Trace)
* [Request.SetMethod]({{% godoc v3 %}}Request.SetMethod)
* [Request.SetURL](R{{% godoc v3 %}}equest.SetURL)
* [Request.SetAllowMethodGetPayload]({{% godoc v3 %}}Request.SetAllowMethodGetPayload)
* [Request.SetAllowMethodDeletePayload]({{% godoc v3 %}}Request.SetAllowMethodDeletePayload)
* [Request.RetryTraceID]({{% godoc v3 %}}Request)
* [Request.SetRetryCount]({{% godoc v3 %}}Request.SetRetryCount)
* [Request.SetRetryWaitTime]({{% godoc v3 %}}Request.SetRetryWaitTime)
* [Request.SetRetryMaxWaitTime]({{% godoc v3 %}}Request.SetRetryMaxWaitTime)
* [Request.SetRetryStrategy]({{% godoc v3 %}}Request.SetRetryStrategy)
* [Request.SetRetryDefaultConditions]({{% godoc v3 %}}Request.SetRetryDefaultConditions)
* [Request.IsSaveResponse]({{% godoc v3 %}}Request)
* [Request.SetSaveResponse]({{% godoc v3 %}}Request.SetSaveResponse)
* [Request.SetGenerateCurlCmd]({{% godoc v3 %}}Request.SetGenerateCurlCmd)
* [Request.SetDebugLogCurlCmd]({{% godoc v3 %}}Request.SetDebugLogCurlCmd)


### Response

* [Response.Body]({{% godoc v3 %}}Response)
* [Response.Bytes]({{% godoc v3 %}}Response.Bytes)
* [Response.IsRead]({{% godoc v3 %}}Response)
* [Response.Err]({{% godoc v3 %}}Response)
* [Response.RedirectHistory]({{% godoc v3 %}}Response.RedirectHistory)