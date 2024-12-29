---
title: "CURL Command Generation"
bookHidden: true
---

# CURL Command Generation

Resty provides a way to generate the CURL command in debug mode.

{{% hint info %}}
**NOTE:** Client-level settings can be overridden at the request level.
{{% /hint %}}

{{% hint warning %}}
**NOTE:**

   - Potential to leak sensitive data from [Request]() and [Response]() in the debug log.
   - Beware of memory usage since the request body is reread.
{{% /hint %}}

## Methods
* [Client.EnableGenerateCurlOnDebug]({{% param Resty.V3.GoDocLinkPrefix %}}Client.EnableGenerateCurlOnDebug)
* [Client.DisableGenerateCurlOnDebug]({{% param Resty.V3.GoDocLinkPrefix %}}Client.DisableGenerateCurlOnDebug)
* [Client.SetGenerateCurlOnDebug]({{% param Resty.V3.GoDocLinkPrefix %}}Client.SetGenerateCurlOnDebug)
* [Request.EnableGenerateCurlOnDebug]({{% param Resty.V3.GoDocLinkPrefix %}}Request.EnableGenerateCurlOnDebug)
* [Request.DisableGenerateCurlOnDebug]({{% param Resty.V3.GoDocLinkPrefix %}}Request.DisableGenerateCurlOnDebug)
* [Request.SetGenerateCurlOnDebug]({{% param Resty.V3.GoDocLinkPrefix %}}Request.SetGenerateCurlOnDebug)

```go
c := resty.New()
defer c.Close()

res, err := c.R().
    EnableDebug().
    EnableGenerateCurlOnDebug().
    SetBody(map[string]string{
        "name": "Alex",
    }).
    Post("https://httpbin.org/post")

curlCmdStr := res.Request.GenerateCurlCommand()
fmt.Println(err, curlCmdStr)

// Result:
//     curl -X POST -H 'Content-Type: application/json' -H 'User-Agent: go-resty/3.0.0 (https://resty.dev)' -d '{"name":"Alex"}' https://httpbin.org/post
```
