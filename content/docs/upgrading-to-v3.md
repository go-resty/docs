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

### Behavior

* Set Content length is not applicable for `io.Reader` flow.
* By default, payload is not supported in HTTP verb DELETE. Use [Client.AllowMethodDeletePayload]({{% param Resty.V3.GoDocLinkPrefix %}}Client.AllowMethodDeletePayload) or [Request.AllowMethodDeletePayload]({{% param Resty.V3.GoDocLinkPrefix %}}Request.AllowMethodDeletePayload).

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

#### Request

* `Request.QueryParam` => [Request.QueryParams]({{% param Resty.V3.GoDocLinkPrefix %}}Request.QueryParams)
* `Request.Token` => [Request.AuthToken]({{% param Resty.V3.GoDocLinkPrefix %}}Request.AuthToken)
* `Request.NotParseResponse` => [Request.DoNotParseResponse]({{% param Resty.V3.GoDocLinkPrefix %}}Request.DoNotParseResponse)
* `Request.ExpectContentType` => [Request.SetExpectResponseContentType]({{% param Resty.V3.GoDocLinkPrefix %}}Request.SetExpectResponseContentType)
* `Request.ForceContentType` => [Request.SetForceResponseContentType]({{% param Resty.V3.GoDocLinkPrefix %}}Request.SetForceResponseContentType)


### Removed

#### Client

* `Client.{SetJSONMarshaler, SetJSONUnmarshaler, SetXMLMarshaler, SetXMLUnmarshaler}` - use [Client.AddContentTypeEncoder]({{% param Resty.V3.GoDocLinkPrefix %}}Client.AddContentTypeEncoder) and [Client.AddContentTypeDecoder]({{% param Resty.V3.GoDocLinkPrefix %}}Client.AddContentTypeDecoder) instead.
* `Client.RawPathParams` - use `Client.PathParams()` instead
* `Client.UserInfo`

#### Request

* `Request.RawPathParams` - use [Request.PathParams]({{% param Resty.V3.GoDocLinkPrefix %}}Request.PathParams) instead

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

### Request

* [Request.Clone]({{% param Resty.V3.GoDocLinkPrefix %}}Request.Clone)
* [Request.WithContext]({{% param Resty.V3.GoDocLinkPrefix %}}Request.WithContext)
* [Request.SetResponseBodyUnlimitedReads]({{% param Resty.V3.GoDocLinkPrefix %}}Request.SetResponseBodyUnlimitedReads)
* [Request.DebugBodyLimit]({{% param Resty.V3.GoDocLinkPrefix %}}Request.DebugBodyLimit)
* [Request.EnableDebug]({{% param Resty.V3.GoDocLinkPrefix %}}Request.EnableDebug)
* [Request.DisableDebug]({{% param Resty.V3.GoDocLinkPrefix %}}Request.DisableDebug)
* [Request.IsTrace]({{% param Resty.V3.GoDocLinkPrefix %}}Request.IsTrace)
* [Request.SetTrace]({{% param Resty.V3.GoDocLinkPrefix %}}Request.SetTrace)
* [Request.DisableTrace]({{% param Resty.V3.GoDocLinkPrefix %}}Request.DisableTrace)
* [Request.Patch]({{% param Resty.V3.GoDocLinkPrefix %}}Request.Patch)
* [Request.Trace]({{% param Resty.V3.GoDocLinkPrefix %}}Request.Trace)
* [Request.SetMethod]({{% param Resty.V3.GoDocLinkPrefix %}}Request.SetMethod)
* [Request.SetURL](R{{% param Resty.V3.GoDocLinkPrefix %}}equest.SetURL)
* [Request.SetAllowMethodGetPayload]({{% param Resty.V3.GoDocLinkPrefix %}}Request.SetAllowMethodGetPayload)
* [Request.SetAllowMethodDeletePayload]({{% param Resty.V3.GoDocLinkPrefix %}}Request.SetAllowMethodDeletePayload)

### Response

* [Response.Body]({{% param Resty.V3.GoDocLinkPrefix %}}Response)
* [Response.SetBodyBytes]({{% param Resty.V3.GoDocLinkPrefix %}}Response.SetBodyBytes)
* [Response.Bytes]({{% param Resty.V3.GoDocLinkPrefix %}}Response.Bytes)
* [Response.IsRead]({{% param Resty.V3.GoDocLinkPrefix %}}Response)
* [Response.Err]({{% param Resty.V3.GoDocLinkPrefix %}}Response)