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
    * Retry settings on [Request-level]({{% relref "retry-mechanism#request" %}}).
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
* [Client.EnableDebug]({{% godoc v3 %}}Client.EnableDebug)
* [Client.DisableDebug]({{% godoc v3 %}}Client.DisableDebug)
* [Client.IsTrace]({{% godoc v3 %}}Client.IsTrace)
* [Client.IsDisableWarn]({{% godoc v3 %}}Client.IsDisableWarn)
* [Client.AllowMethodDeletePayload]({{% godoc v3 %}}Client.AllowMethodDeletePayload)
* [Client.SetAllowMethodDeletePayload]({{% godoc v3 %}}Client.SetAllowMethodDeletePayload)
* [Client.RetryStrategy]({{% godoc v3 %}}Client.RetryStrategy)
* [Client.SetRetryStrategy]({{% godoc v3 %}}Client.SetRetryStrategy)
* [Client.IsRetryDefaultConditions]({{% godoc v3 %}}Client.IsRetryDefaultConditions)
* [Client.EnableRetryDefaultConditions]({{% godoc v3 %}}Client.EnableRetryDefaultConditions)
* [Client.DisableRetryDefaultConditions]({{% godoc v3 %}}Client.DisableRetryDefaultConditions)
* [Client.SetRetryDefaultConditions]({{% godoc v3 %}}Client.SetRetryDefaultConditions)
* [Client.SetAllowNonIdempotentRetry]({{% godoc v3 %}}Client.SetAllowNonIdempotentRetry)
* [Client.IsSaveResponse]({{% godoc v3 %}}Client.IsSaveResponse)
* [Client.SetSaveResponse]({{% godoc v3 %}}Client.SetSaveResponse)
* [Client.SetGenerateCurlCmd]({{% godoc v3 %}}Client.SetGenerateCurlCmd)
* [Client.SetDebugLogCurlCmd]({{% godoc v3 %}}Client.SetDebugLogCurlCmd)
* [Client.SetRootCertificatesWatcher]({{% godoc v3 %}}Client.SetRootCertificatesWatcher)
* [Client.SetClientRootCertificatesWatcher]({{% godoc v3 %}}Client.SetClientRootCertificatesWatcher)
* [Client.SetCertificateFromFile]({{% godoc v3 %}}Client.SetCertificateFromFile)
* [Client.SetCertificateFromString]({{% godoc v3 %}}Client.SetCertificateFromString)
* [Client.SetUnescapeQueryParams]({{% godoc v3 %}}Client.SetUnescapeQueryParams)


## Request

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
* [Request.EnableRetryDefaultConditions]({{% godoc v3 %}}Request.EnableRetryDefaultConditions)
* [Request.DisableRetryDefaultConditions]({{% godoc v3 %}}Request.DisableRetryDefaultConditions)
* [Request.SetRetryDefaultConditions]({{% godoc v3 %}}Request.SetRetryDefaultConditions)
* [Request.SetAllowNonIdempotentRetry]({{% godoc v3 %}}Request.SetAllowNonIdempotentRetry)
* [Request.OutputFileName]({{% godoc v3 %}}Request)
* [Request.SetOutputFileName]({{% godoc v3 %}}Request.SetOutputFileName)
* [Request.IsSaveResponse]({{% godoc v3 %}}Request)
* [Request.SetSaveResponse]({{% godoc v3 %}}Request.SetSaveResponse)
* [Request.SetGenerateCurlCmd]({{% godoc v3 %}}Request.SetGenerateCurlCmd)
* [Request.SetDebugLogCurlCmd]({{% godoc v3 %}}Request.SetDebugLogCurlCmd)
* [Request.SetUnescapeQueryParams]({{% godoc v3 %}}Request.SetUnescapeQueryParams)
* [Request.Funcs]({{% godoc v3 %}}Request.Funcs)
* [Request.SetTimeout]({{% godoc v3 %}}Request.SetTimeout)
* [Request.SetHeaderAuthorizationKey]({{% godoc v3 %}}Request.SetHeaderAuthorizationKey)

## Response

* [Response.Body]({{% godoc v3 %}}Response)
* [Response.Bytes]({{% godoc v3 %}}Response.Bytes)
* [Response.IsRead]({{% godoc v3 %}}Response)
* [Response.Err]({{% godoc v3 %}}Response)
* [Response.RedirectHistory]({{% godoc v3 %}}Response.RedirectHistory)

## TraceInfo

* [TraceInfo.String]({{% godoc v3 %}}TraceInfo.String)
* [TraceInfo.JSON]({{% godoc v3 %}}TraceInfo.JSON)