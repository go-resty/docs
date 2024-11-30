---
title: Welcome
type: docs
---

<p align="center"><img src="/img/resty-logo.svg" alt="Resty Logo" height="100px" width="225px" /></p>
<p align="center" style="font-weight:bold">Simple HTTP, REST, and SSE client library for Go</p>
<p align="center" class="resty-badges"><a href="https://github.com/go-resty/resty/actions/workflows/ci.yml?query=branch%3Amain"><img src="https://github.com/go-resty/resty/actions/workflows/ci.yml/badge.svg?branch=main" alt="Build Status"></a> <a href="https://app.codecov.io/gh/go-resty/resty/tree/v3"><img src="https://codecov.io/gh/go-resty/resty/branch/main/graph/badge.svg" alt="Code Coverage"></a> <a href="https://goreportcard.com/report/go-resty/resty"><img src="https://goreportcard.com/badge/go-resty/resty" alt="Go Report Card"></a> <a href="https://github.com/go-resty/resty/releases/latest"><img src="https://img.shields.io/badge/version-3.0.0-blue.svg" alt="Release Version"></a> <a href="https://pkg.go.dev/github.com/go-resty/resty/v3"><img src="https://pkg.go.dev/badge/github.com/go-resty/resty" alt="GoDoc"></a> <a href="LICENSE"><img src="https://img.shields.io/github/license/go-resty/resty.svg" alt="License"></a> <a href="https://github.com/avelino/awesome-go"><img src="https://awesome.re/mentioned-badge.svg" alt="Mentioned in Awesome Go"></a></p>
</p>

{{% columns %}}
```go
// HTTP, REST Client
client := resty.New()
defer client.Close()

resp, err := client.R().
    EnableTrace().
    Get("https://httpbin.org/get")
fmt.Println(err, resp)
fmt.Println(resp.Request.TraceInfo())
```
<--->
```go
// SSE Client
client := resty.NewSSE().
    SetURL("https://sse.dev/test").
    SetResultMapping("*", Message{})

client.Subscribe("*", func(v any) {
    msg := v.(*Message)
    fmt.Println(msg)
})
```

{{% /columns %}}

This website represents Resty v3 and above. For previous v2 documentation, refer to this [README.md](https://github.com/go-resty/resty/blob/v2/README.md "Resty v2 README")

## Features

{{% columns %}}
* Simple and chainable methods
* Multipart and Form data with ease
* Request Path Params
* Retry Mechanism
* Goroutine & concurrent safe
* Automatic decompresser (gzip, deflate)
* Basic auth, Digest auth, Bearer, etc.
* Request tracing
* CURL command generation
* HTTP/1.1 and HTTP/2. Integrate HTTP/3


<p class="ml-20">and much more ...</p>

<--->

* Automatic marshal and unmarshal
* Large file upload and progress callback
* Download to file
* Redirect Policies
* Debug mode with structured logging
* Load Balancer and Service Discovery
* Response body limit & Unlimited reads
* Bazel support
* Dynamic reload of TLS certificates
* Custom root and client certificates

<p class="ml-20">and much more ...</p>
{{% /columns %}}

## Highly Extensible

Resty offers various ways to enhance its functionality by implementing its interfaces to meet all custom requirements.

* Request & Response middleware
* Content-Type encoder & decoder
* Content Decompresser
* Load Balancer and Service Discovery
* Retry Strategy, Condition, and Hooks
* Request Functions
* Transport RoundTripper
* Redirect Policy
* Logger

