---
title: Welcome
type: docs
---

<h2 align="center">Simple HTTP, REST, and SSE client library for Go</h2>
<p align="center" style="margin-top: 3rem;">
    <a href="{{% param Resty.GitHubRepo %}}/actions/workflows/ci.yml?query=branch%3Av3" target="_blank">
        <img src="{{% param Resty.GitHubRepo %}}/actions/workflows/ci.yml/badge.svg?branch=v3" alt="Resty Build Status">
    </a>
    <a href="https://app.codecov.io/gh/{{% param Resty.GitHubSlug %}}/tree/v3" target="_blank">
        <img src="https://codecov.io/gh/{{% param Resty.GitHubSlug %}}/branch/v3/graph/badge.svg" alt="Resty Code Coverage">
    </a>
    <a href="https://goreportcard.com/report/{{% param Resty.V3.Vanity %}}" target="_blank">
        <img src="https://goreportcard.com/badge/{{% param Resty.V3.Vanity %}}" alt="Go Report Card">
    </a>
    <a href="{{% param Resty.GoDoc %}}/{{% param Resty.V3.Vanity %}}" target="_blank">
        <img src="{{% param Resty.GoDoc %}}/badge/{{% param Resty.V3.Vanity %}}" alt="Resty GoDoc">
    </a>
    <a href="https://github.com/avelino/awesome-go" target="_blank">
        <img src="https://awesome.re/mentioned-badge.svg" alt="Mentioned in Awesome Go">
    </a>
</p>
<p align="center" style="margin-bottom: 1rem;">
    <a href="https://app.fossa.com/projects/git%2Bgithub.com%2Fgo-resty%2Fresty?ref=badge_shield&issueType=license" alt="FOSSA Status"><img src="https://app.fossa.com/api/projects/git%2Bgithub.com%2Fgo-resty%2Fresty.svg?type=shield&issueType=license"/></a>
    <a href="https://app.fossa.com/projects/git%2Bgithub.com%2Fgo-resty%2Fresty?ref=badge_shield&issueType=security" alt="FOSSA Status"><img src="https://app.fossa.com/api/projects/git%2Bgithub.com%2Fgo-resty%2Fresty.svg?type=shield&issueType=security"/></a>
</p>

<div id="resty-go-mod" class="resty-go-mod">
<pre>
<code>require resty.dev/v3 {{% param Resty.V3.Version %}}</code>
</pre>
</div>
<div class="resty-go-min">Minimum required Go version is {{% param Resty.V3.GoMinVersion %}}</div>

{{% columns %}}
- ```go
  // HTTP, REST Client
  client := resty.New()
  defer client.Close()

  res, err := client.R().
      EnableTrace().
      Get("https://httpbin.org/get")
  fmt.Println(err, res)
  fmt.Println(res.Request.TraceInfo())
  ```

- ```go
  // Server-Sent Events Client
  es := NewEventSource().
      SetURL("https://sse.dev/test").
      OnMessage(func(e any) {
          fmt.Println(e.(*resty.Event))
      }, nil)

  err := es.Get()
  fmt.Println(err)
  ```
{{% /columns %}}

<p align="center">Resty v3 offers improved performance, memory efficiency, and features compared to Resty v2.</p>

This website represents Resty v3 and above. For previous v2 documentation, refer to this [README.md]({{% param Resty.GitHubRepo %}}/blob/v2/README.md "Resty v2 README")

## Key Features

{{% columns %}}

-   * Simple and chainable methods
    * Multipart and Form data with ease
    * Request Path Params
    * Retry Mechanism
    * Circuit Breaker
    * Goroutine & concurrent safe
    * Automatic decompresser (gzip, deflate)
    * Basic auth, Digest auth, Bearer, etc.
    * Request tracing
    * CURL command generation
    * HTTP/1.1 and HTTP/2. Integrate HTTP/3
    * Circuit Breaker Policy
    <p class="ml-20">and much more ...</p>

-   * Automatic marshal and unmarshal
    * Large file upload and progress callback
    * Download to file
    * Redirect Policies
    * Debug mode with human-readable, JSON log
    * Load Balancer and Service Discovery
    * Response body limit & Unlimited reads
    * Bazel support
    * Dynamic reload of TLS certificates
    * Custom root and client certificates
    <p class="ml-20">and much more ...</p>

{{% /columns %}}

## Highly Extensible

Resty provides various ways to enhance its functionality by implementing its interfaces to meet all custom requirements.

* Request middleware
* Response middleware
* Content-Type encoder & decoder
* Content Decompresser
* Load Balancer and Service Discovery
* Retry Strategy, Condition, and Hooks
* Circuit Breaker Policy
* Request Functions
* Redirect Policy
* Transport RoundTripper
* Debug Log Formatter
* Logger

