---
bookHidden: true
---

# New Features and Enhancements

* Override all transport settings and timeout values used by Resty using [NewWithTransportSettings]({{% godoc v3 %}}NewWithTransportSettings).
* Fully composable [request]({{% relref "request-middleware" %}}) and [response]({{% relref "response-middleware" %}}) middleware
* [Content-Type {Encoder, Decoder}]({{% relref "content-type-encoder-and-decoder" %}})
* [Content Decompresser]({{% relref "content-decompresser" %}})
* [Circuit Breaker]({{% relref "circuit-breaker" %}})
* [Multipart]({{% relref "multipart" %}}) streaming and [upload progress]({{% relref "multipart#upload-progress" %}}).
* [Load Balancer and Service Discovery]({{% relref "load-balancer-and-service-discovery" %}})
* Retry
    * Retry settings on [Request-level]({{% relref "retry#request" %}}).
    * Respects header `Retry-After` if present.
    * Resets reader on retry request if the `io.ReadSeeker` interface is supported.
* [Root]({{% relref "root-certificates" %}}), [Client Root]({{% relref "client-root-certificates" %}}) certificates - dynamically reload by interval.
* [Server-Sent Events]({{% relref "server-sent-events" %}})
* SRV lookup got a facelift with weighted round-robin algorithm and weight value respected from SRV record.
* Ability to set empty header value for `User-Agent` and `Accept-Encoding`.
* Ability to set `TLSClientConfig` on custom RoundTripper via [TLSClientConfiger interface]({{% relref "tls-client-config-on-custom-roundtriper" %}}).
* Adds Retry Trace ID and Attempt details to the debug log.
* [Digest Auth]({{% relref "authentication#digest-auth" %}})
    * Internal flow improvements and optimization.
    * Adds `auth-int` QOP support.
    * Adds new Hash functions `SHA-512` and `SHA-512-sess`.
    * Updates hash functions for `SHA-512-256` and `SHA-512-256-sess`.
* Adds Request level [timeout]({{% relref "timeout" %}}) support.
* Adds the ability to determine the filename automatically from the response for [saving the response]({{% relref "save-response" %}}).
* [Debug Log]({{% relref "debug-log" %}})
    * Introduced Debug Log formatter, out of the box human-readable and JSON formatter added.
* Hook functions at Client update to variadic function; it becomes easy to supply one or more values.
* [Any Value Methods]({{% relref "any-value-methods" %}}) - convenience methods (`*Any` variants) that accept `any` type values and auto-convert to strings for headers, query params, and path params.


## New ways to create Client

* [NewWithTransportSettings]({{% godoc v3 %}}NewWithTransportSettings)
* [NewWithDialer]({{% godoc v3 %}}NewWithDialer)
* [NewWithDialerAndTransportSettings]({{% godoc v3 %}}NewWithDialerAndTransportSettings)

## Client

* [Client.Close]({{% godoc v3 %}}Client.Close)
* [Client.SetRequestMiddlewares]({{% godoc v3 %}}Client.SetRequestMiddlewares)
* [Client.SetResponseMiddlewares]({{% godoc v3 %}}Client.SetResponseMiddlewares)
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
* [Client.IsTrace]({{% godoc v3 %}}Client.IsTrace)
* [Client.IsDisableWarn]({{% godoc v3 %}}Client.IsDisableWarn)
* [Client.IsMethodDeleteAllowPayload]({{% godoc v3 %}}Client.IsMethodDeleteAllowPayload)
* [Client.SetMethodDeleteAllowPayload]({{% godoc v3 %}}Client.SetMethodDeleteAllowPayload)
* [Client.RetryDelayStrategy]({{% godoc v3 %}}Client.RetryDelayStrategy)
* [Client.SetRetryDelayStrategy]({{% godoc v3 %}}Client.SetRetryDelayStrategy)
* [Client.IsRetryDefaultConditions]({{% godoc v3 %}}Client.IsRetryDefaultConditions)
* [Client.SetRetryDefaultConditions]({{% godoc v3 %}}Client.SetRetryDefaultConditions)
* [Client.SetRetryAllowNonIdempotent]({{% godoc v3 %}}Client.SetRetryAllowNonIdempotent)
* [Client.IsResponseSaveToFile]({{% godoc v3 %}}Client.IsResponseSaveToFile)
* [Client.SetResponseSaveToFile]({{% godoc v3 %}}Client.SetResponseSaveToFile)
* [Client.SetCurlCmdGenerate]({{% godoc v3 %}}Client.SetCurlCmdGenerate)
* [Client.SetCurlCmdDebugLog]({{% godoc v3 %}}Client.SetCurlCmdDebugLog)
* [Client.SetRootCertificatesWatcher]({{% godoc v3 %}}Client.SetRootCertificatesWatcher)
* [Client.SetClientRootCertificatesWatcher]({{% godoc v3 %}}Client.SetClientRootCertificatesWatcher)
* [Client.SetCertificateFromFile]({{% godoc v3 %}}Client.SetCertificateFromFile)
* [Client.SetCertificateFromString]({{% godoc v3 %}}Client.SetCertificateFromString)
* [Client.SetQueryParamsUnescape]({{% godoc v3 %}}Client.SetQueryParamsUnescape)
* [Client.OnDebugLog]({{% godoc v3 %}}Client.OnDebugLog)
* [Client.SetDebugLogFormatter]({{% godoc v3 %}}Client.SetDebugLogFormatter)
* [Client.OnClose]({{% godoc v3 %}}Client.OnClose)
* [Client.SetHeaderAny]({{% godoc v3 %}}Client.SetHeaderAny)
* [Client.SetHeaderVerbatimAny]({{% godoc v3 %}}Client.SetHeaderVerbatimAny)
* [Client.SetQueryParamAny]({{% godoc v3 %}}Client.SetQueryParamAny)
* [Client.SetPathParamAny]({{% godoc v3 %}}Client.SetPathParamAny)
* [Client.SetPathRawParamAny]({{% godoc v3 %}}Client.SetPathRawParamAny)

## Request

* [Request.Clone]({{% godoc v3 %}}Request.Clone)
* [Request.WithContext]({{% godoc v3 %}}Request.WithContext)
* [Request.SetResponseBodyUnlimitedReads]({{% godoc v3 %}}Request.SetResponseBodyUnlimitedReads)
* [Request.DebugBodyLimit]({{% godoc v3 %}}Request)
* [Request.IsTrace]({{% godoc v3 %}}Request)
* [Request.SetTrace]({{% godoc v3 %}}Request.SetTrace)
* [Request.Patch]({{% godoc v3 %}}Request.Patch)
* [Request.Trace]({{% godoc v3 %}}Request.Trace)
* [Request.SetMethod]({{% godoc v3 %}}Request.SetMethod)
* [Request.SetURL]({{% godoc v3 %}}Request.SetURL)
* [Request.SetMethodGetAllowPayload]({{% godoc v3 %}}Request.SetMethodGetAllowPayload)
* [Request.SetMethodDeleteAllowPayload]({{% godoc v3 %}}Request.SetMethodDeleteAllowPayload)
* [Request.CorrelationID]({{% godoc v3 %}}Request)
* [Request.SetCorrelationID]({{% godoc v3 %}}Request.SetCorrelationID)
* [Request.SetRetryCount]({{% godoc v3 %}}Request.SetRetryCount)
* [Request.SetRetryWaitTime]({{% godoc v3 %}}Request.SetRetryWaitTime)
* [Request.SetRetryMaxWaitTime]({{% godoc v3 %}}Request.SetRetryMaxWaitTime)
* [Request.SetRetryDelayStrategy]({{% godoc v3 %}}Request.SetRetryDelayStrategy)
* [Request.SetRetryDefaultConditions]({{% godoc v3 %}}Request.SetRetryDefaultConditions)
* [Request.SetRetryAllowNonIdempotent]({{% godoc v3 %}}Request.SetRetryAllowNonIdempotent)
* [Request.ResponseSaveFileName]({{% godoc v3 %}}Request)
* [Request.SetResponseSaveFileName]({{% godoc v3 %}}Request.SetResponseSaveFileName)
* [Request.IsResponseSaveToFile]({{% godoc v3 %}}Request)
* [Request.SetResponseSaveToFile]({{% godoc v3 %}}Request.SetResponseSaveToFile)
* [Request.SetCurlCmdGenerate]({{% godoc v3 %}}Request.SetCurlCmdGenerate)
* [Request.SetCurlCmdDebugLog]({{% godoc v3 %}}Request.SetCurlCmdDebugLog)
* [Request.SetQueryParamsUnescape]({{% godoc v3 %}}Request.SetQueryParamsUnescape)
* [Request.Funcs]({{% godoc v3 %}}Request.Funcs)
* [Request.SetTimeout]({{% godoc v3 %}}Request.SetTimeout)
* [Request.SetHeaderAuthorizationKey]({{% godoc v3 %}}Request.SetHeaderAuthorizationKey)
* [Request.SetHeaderAny]({{% godoc v3 %}}Request.SetHeaderAny)
* [Request.SetHeaderVerbatimAny]({{% godoc v3 %}}Request.SetHeaderVerbatimAny)
* [Request.SetQueryParamAny]({{% godoc v3 %}}Request.SetQueryParamAny)
* [Request.SetPathParamAny]({{% godoc v3 %}}Request.SetPathParamAny)
* [Request.SetPathRawParamAny]({{% godoc v3 %}}Request.SetPathRawParamAny)

## Response

* [Response.Body]({{% godoc v3 %}}Response)
* [Response.Bytes]({{% godoc v3 %}}Response.Bytes)
* [Response.IsRead]({{% godoc v3 %}}Response)
* [Response.CascadeError]({{% godoc v3 %}}Response)
* [Response.RedirectHistory]({{% godoc v3 %}}Response.RedirectHistory)

## Middleware

Resty v3 exports the middleware functions.

### Request

* [MiddlewareRequestCreate]({{% godoc v3 %}}MiddlewareRequestCreate)

### Response

* [MiddlewareResponseAutoParse]({{% godoc v3 %}}MiddlewareResponseAutoParse)
* [MiddlewareResponseSaveToFile]({{% godoc v3 %}}MiddlewareResponseSaveToFile)


## TraceInfo

* [TraceInfo.String]({{% godoc v3 %}}TraceInfo.String)
* [TraceInfo.JSON]({{% godoc v3 %}}TraceInfo.JSON)