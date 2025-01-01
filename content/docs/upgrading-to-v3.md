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
* By default, payload is not supported in HTTP verb DELETE. Use [Client.AllowMethodDeletePayload]({{% param Resty.V3.GoDocLinkPrefix %}}Client.AllowMethodDeletePayload) or [Request.AllowMethodDeletePayload]({{% param Resty.V3.GoDocLinkPrefix %}}Request.AllowMethodDeletePayload).
* Retry Mechanism
    * Respects header `Retry-After` if present
    * Resets reader on retry request if the `io.ReadSeeker` interface is supported.
    * Retries only on Idempotent HTTP Verb - GET, HEAD, PUT, DELETE, OPTIONS, and TRACE ([RFC 9110](https://datatracker.ietf.org/doc/html/rfc9110.html#name-method-registration), [RFC 5789](https://datatracker.ietf.org/doc/html/rfc5789.html)),
        * Use [Client.SetAllowNonIdempotentRetry]({{% param Resty.V3.GoDocLinkPrefix %}}Client.SetAllowNonIdempotentRetry) or [Request.SetAllowNonIdempotentRetry]({{% param Resty.V3.GoDocLinkPrefix %}}Request.SetAllowNonIdempotentRetry). If additional control is necessary, utilize the custom retry condition.
    * Applies [default retry conditions]({{% relref "retry-mechanism#default-conditions" %}})
        * It can be disabled via [Client.SetRetryDefaultConditions]({{% param Resty.V3.GoDocLinkPrefix %}}Client.SetRetryDefaultConditions) or [Request.SetRetryDefaultConditions]({{% param Resty.V3.GoDocLinkPrefix %}}Request.SetRetryDefaultConditions)
*

#### Client

* Client Getter Methods - Added thread safety to the client settings modification, so all the getter fields become methods.
    * For Example:
        * `Client.BaseURL => Client.BaseURL()`
        * `Client.Debug => Client.IsDebug()`
* Getter naming convention alignment - `Client.GetClient()` => [Client.Client()]({{% param Resty.V3.GoDocLinkPrefix %}}Client.Client)
* `Client.Token` => [Client.AuthToken]({{% param Resty.V3.GoDocLinkPrefix %}}Client.AuthToken)
* [Client.SetDebugBodyLimit]({{% param Resty.V3.GoDocLinkPrefix %}}Client.SetDebugBodyLimit) - datatype changed from `int64` to `int`
* [Client.ResponseBodyLimit]({{% param Resty.V3.GoDocLinkPrefix %}}Client.ResponseBodyLimit) - datatype changed from `int` to `int64`
* `Client.SetAllowGetMethodPayload` => [Client.SetAllowMethodGetPayload]({{% param Resty.V3.GoDocLinkPrefix %}}Client.SetAllowMethodGetPayload)
* `Client.Clone()` - use [Client.Clone(ctx context.Context)]({{% param Resty.V3.GoDocLinkPrefix %}}Client.Clone) instead.
* `Client.EnableGenerateCurlOnDebug` => [Client.EnableGenerateCurlCmd]({{% param Resty.V3.GoDocLinkPrefix %}}Client.EnableGenerateCurlCmd)
* `Client.DisableGenerateCurlOnDebug` => [Client.DisableGenerateCurlCmd]({{% param Resty.V3.GoDocLinkPrefix %}}Client.DisableGenerateCurlCmd)

#### Request

* `Request.QueryParam` => [Request.QueryParams]({{% param Resty.V3.GoDocLinkPrefix %}}Request.QueryParams)
* `Request.Token` => [Request.AuthToken]({{% param Resty.V3.GoDocLinkPrefix %}}Request.AuthToken)
* `Request.NotParseResponse` => [Request.DoNotParseResponse]({{% param Resty.V3.GoDocLinkPrefix %}}Request.DoNotParseResponse)
* `Request.ExpectContentType` => [Request.SetExpectResponseContentType]({{% param Resty.V3.GoDocLinkPrefix %}}Request.SetExpectResponseContentType)
* `Request.ForceContentType` => [Request.SetForceResponseContentType]({{% param Resty.V3.GoDocLinkPrefix %}}Request.SetForceResponseContentType)
* `Request.SetOutput` => [Request.SetOutputFileName]({{% param Resty.V3.GoDocLinkPrefix %}}Request.SetOutputFileName)
* `Request.EnableGenerateCurlOnDebug` => [Request.EnableGenerateCurlCmd]({{% param Resty.V3.GoDocLinkPrefix %}}Request.EnableGenerateCurlCmd)
* `Request.DisableGenerateCurlOnDebug` => [Request.DisableGenerateCurlCmd]({{% param Resty.V3.GoDocLinkPrefix %}}Request.DisableGenerateCurlCmd)
* `Request.GenerateCurlCommand` => [Request.CurlCmd]({{% param Resty.V3.GoDocLinkPrefix %}}Request.CurlCmd)


### Removed

#### Client

* `Client.SetHostURL` - use [Client.SetBaseURL]({{% param Resty.V3.GoDocLinkPrefix %}}Client.SetBaseURL) instead.
* `Client.{SetJSONMarshaler, SetJSONUnmarshaler, SetXMLMarshaler, SetXMLUnmarshaler}` - use [Client.AddContentTypeEncoder]({{% param Resty.V3.GoDocLinkPrefix %}}Client.AddContentTypeEncoder) and [Client.AddContentTypeDecoder]({{% param Resty.V3.GoDocLinkPrefix %}}Client.AddContentTypeDecoder) instead.
* `Client.RawPathParams` - use `Client.PathParams()` instead.
* `Client.UserInfo`
* `Client.SetRetryResetReaders` - it happens automatically.
* `Client.SetRetryAfter` - use [Client.SetRetryStrategy]({{% param Resty.V3.GoDocLinkPrefix %}}Client.SetRetryStrategy) or [Request.SetRetryStrategy]({{% param Resty.V3.GoDocLinkPrefix %}}Request.SetRetryStrategy) instead.

#### Request

* `Request.RawPathParams` - use [Request.PathParams]({{% param Resty.V3.GoDocLinkPrefix %}}Request.PathParams) instead
*

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

* Override all transport settings and timeout values used by Resty using [NewWithTransportSettings]({{% param Resty.V3.GoDocLinkPrefix %}}NewWithTransportSettings)
* [Circuit Breaker]({{% relref "circuit-breaker" %}})
* Set retry settings on Request instance refer to [Retry Mechanism]({{% relref "retry-mechanism" %}})

### New ways to create Client

* [NewWithTransportSettings]({{% param Resty.V3.GoDocLinkPrefix %}}NewWithTransportSettings)
* [NewWithDialer]({{% param Resty.V3.GoDocLinkPrefix %}}NewWithDialer)
* [NewWithDialerAndTransportSettings]({{% param Resty.V3.GoDocLinkPrefix %}}NewWithDialerAndTransportSettings)

### Client

* [Client.AddContentTypeEncoder]({{% param Resty.V3.GoDocLinkPrefix %}}Client.AddContentTypeEncoder)
* [Client.AddContentTypeDecoder]({{% param Resty.V3.GoDocLinkPrefix %}}Client.AddContentTypeDecoder)
* [Client.SetResponseBodyUnlimitedReads]({{% param Resty.V3.GoDocLinkPrefix %}}Client.SetResponseBodyUnlimitedReads)
* [Client.ContentDecompressor]({{% param Resty.V3.GoDocLinkPrefix %}}Client.ContentDecompressor)
* [Client.ContentDecompressors]({{% param Resty.V3.GoDocLinkPrefix %}}Client.ContentDecompressors)
* [Client.AddContentDecompressor]({{% param Resty.V3.GoDocLinkPrefix %}}Client.AddContentDecompressor) - Automatically handles `gzip` and `deflate`
* [Client.ContentDecompressorKeys]({{% param Resty.V3.GoDocLinkPrefix %}}Client.ContentDecompressorKeys)
* [Client.SetContentDecompressorKeys]({{% param Resty.V3.GoDocLinkPrefix %}}Client.SetContentDecompressorKeys)
* [Client.Context]({{% param Resty.V3.GoDocLinkPrefix %}}Client.Context)
* [Client.SetContext]({{% param Resty.V3.GoDocLinkPrefix %}}Client.SetContext)
* [Client.Clone]({{% param Resty.V3.GoDocLinkPrefix %}}Client.Clone)
* [Client.EnableDebug]({{% param Resty.V3.GoDocLinkPrefix %}}Client.EnableDebug)
* [Client.DisableDebug]({{% param Resty.V3.GoDocLinkPrefix %}}Client.DisableDebug)
* [Client.IsTrace]({{% param Resty.V3.GoDocLinkPrefix %}}Client.IsTrace)
* [Client.IsDisableWarn]({{% param Resty.V3.GoDocLinkPrefix %}}Client.IsDisableWarn)
* [Client.AllowMethodDeletePayload]({{% param Resty.V3.GoDocLinkPrefix %}}Client.AllowMethodDeletePayload)
* [Client.SetAllowMethodDeletePayload]({{% param Resty.V3.GoDocLinkPrefix %}}Client.SetAllowMethodDeletePayload)
* [Client.SetRetryStrategy]({{% param Resty.V3.GoDocLinkPrefix %}}Client.SetRetryStrategy)
* [Client.SetRetryDefaultConditions]({{% param Resty.V3.GoDocLinkPrefix %}}Client.SetRetryDefaultConditions)
* [Client.IsSaveResponse]({{% param Resty.V3.GoDocLinkPrefix %}}Client.IsSaveResponse)
* [Client.SetSaveResponse]({{% param Resty.V3.GoDocLinkPrefix %}}Client.SetSaveResponse)
* [Client.SetGenerateCurlCmd]({{% param Resty.V3.GoDocLinkPrefix %}}Client.SetGenerateCurlCmd)
* [Client.SetDebugLogCurlCmd]({{% param Resty.V3.GoDocLinkPrefix %}}Client.SetDebugLogCurlCmd)

### Request

* [Request.Clone]({{% param Resty.V3.GoDocLinkPrefix %}}Request.Clone)
* [Request.WithContext]({{% param Resty.V3.GoDocLinkPrefix %}}Request.WithContext)
* [Request.SetResponseBodyUnlimitedReads]({{% param Resty.V3.GoDocLinkPrefix %}}Request.SetResponseBodyUnlimitedReads)
* [Request.DebugBodyLimit]({{% param Resty.V3.GoDocLinkPrefix %}}Request.DebugBodyLimit)
* [Request.EnableDebug]({{% param Resty.V3.GoDocLinkPrefix %}}Request.EnableDebug)
* [Request.DisableDebug]({{% param Resty.V3.GoDocLinkPrefix %}}Request.DisableDebug)
* [Request.IsTrace]({{% param Resty.V3.GoDocLinkPrefix %}}Request)
* [Request.SetTrace]({{% param Resty.V3.GoDocLinkPrefix %}}Request.SetTrace)
* [Request.DisableTrace]({{% param Resty.V3.GoDocLinkPrefix %}}Request.DisableTrace)
* [Request.Patch]({{% param Resty.V3.GoDocLinkPrefix %}}Request.Patch)
* [Request.Trace]({{% param Resty.V3.GoDocLinkPrefix %}}Request.Trace)
* [Request.SetMethod]({{% param Resty.V3.GoDocLinkPrefix %}}Request.SetMethod)
* [Request.SetURL](R{{% param Resty.V3.GoDocLinkPrefix %}}equest.SetURL)
* [Request.SetAllowMethodGetPayload]({{% param Resty.V3.GoDocLinkPrefix %}}Request.SetAllowMethodGetPayload)
* [Request.SetAllowMethodDeletePayload]({{% param Resty.V3.GoDocLinkPrefix %}}Request.SetAllowMethodDeletePayload)
* [Request.SetRetryCount]({{% param Resty.V3.GoDocLinkPrefix %}}Request.SetRetryCount)
* [Request.SetRetryWaitTime]({{% param Resty.V3.GoDocLinkPrefix %}}Request.SetRetryWaitTime)
* [Request.SetRetryMaxWaitTime]({{% param Resty.V3.GoDocLinkPrefix %}}Request.SetRetryMaxWaitTime)
* [Request.SetRetryStrategy]({{% param Resty.V3.GoDocLinkPrefix %}}Request.SetRetryStrategy)
* [Request.SetRetryDefaultConditions]({{% param Resty.V3.GoDocLinkPrefix %}}Request.SetRetryDefaultConditions)
* [Request.IsSaveResponse]({{% param Resty.V3.GoDocLinkPrefix %}}Request)
* [Request.SetSaveResponse]({{% param Resty.V3.GoDocLinkPrefix %}}Request.SetSaveResponse)
* [Request.SetGenerateCurlCmd]({{% param Resty.V3.GoDocLinkPrefix %}}Request.SetGenerateCurlCmd)
* [Request.SetDebugLogCurlCmd]({{% param Resty.V3.GoDocLinkPrefix %}}Request.SetDebugLogCurlCmd)


### Response

* [Response.Body]({{% param Resty.V3.GoDocLinkPrefix %}}Response)
* [Response.Bytes]({{% param Resty.V3.GoDocLinkPrefix %}}Response.Bytes)
* [Response.IsRead]({{% param Resty.V3.GoDocLinkPrefix %}}Response)
* [Response.Err]({{% param Resty.V3.GoDocLinkPrefix %}}Response)
* [Response.RedirectHistory]({{% param Resty.V3.GoDocLinkPrefix %}}Response.RedirectHistory)