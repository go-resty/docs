---
# title: New Features and Enhancements
bookHidden: true
---

# New Features and Enhancements

* Override all transport settings and timeout values used by Resty using [NewWithTransportSettings]({{% godoc v3 %}}NewWithTransportSettings)
* [Content-Type {Encoder, Decoder}]({{% relref "content-type-encoder-and-decoder" %}})
* [Content Decompresser]({{% relref "content-decompresser" %}})
* [Circuit Breaker]({{% relref "circuit-breaker" %}})
* Multipart [upload progress]({{% relref "multipart#upload-progress" %}})
* Retry settings on [Request-level]({{% relref "retry-mechanism#request" %}})
* Retry respects header `Retry-After` if present
* [Root]({{% relref "root-certificates" %}}), [Client, and Client Root]({{% relref "client-root-certificates" %}}) certificates - dynamically reload by interval
* SRV lookup got a facelift with weighted round-robin algorithm and weight value respected from SRV record
* Ability to set empty header value for User-Agent and Accept-Encoding

## New ways to create Client

* [NewWithTransportSettings]({{% godoc v3 %}}NewWithTransportSettings)
* [NewWithDialer]({{% godoc v3 %}}NewWithDialer)
* [NewWithDialerAndTransportSettings]({{% godoc v3 %}}NewWithDialerAndTransportSettings)

## Client

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
* [Client.SetRootCertificatesWatcher]({{% godoc v3 %}}Client.SetRootCertificatesWatcher)
* [Client.SetClientRootCertificatesWatcher]({{% godoc v3 %}}Client.SetClientRootCertificatesWatcher)
* [Client.SetCertificateFromFile]({{% godoc v3 %}}Client.SetCertificateFromFile)
* [Client.SetCertificateFromString]({{% godoc v3 %}}Client.SetCertificateFromString)

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
* [Request.SetRetryDefaultConditions]({{% godoc v3 %}}Request.SetRetryDefaultConditions)
* [Request.IsSaveResponse]({{% godoc v3 %}}Request)
* [Request.SetSaveResponse]({{% godoc v3 %}}Request.SetSaveResponse)
* [Request.SetGenerateCurlCmd]({{% godoc v3 %}}Request.SetGenerateCurlCmd)
* [Request.SetDebugLogCurlCmd]({{% godoc v3 %}}Request.SetDebugLogCurlCmd)


## Response

* [Response.Body]({{% godoc v3 %}}Response)
* [Response.Bytes]({{% godoc v3 %}}Response.Bytes)
* [Response.IsRead]({{% godoc v3 %}}Response)
* [Response.Err]({{% godoc v3 %}}Response)
* [Response.RedirectHistory]({{% godoc v3 %}}Response.RedirectHistory)
