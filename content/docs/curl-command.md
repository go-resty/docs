---
title: "CURL Command Generation"
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
* [Client.EnableGenerateCurlOnDebug]()
* [Client.DisableGenerateCurlOnDebug]()
* [Client.SetGenerateCurlOnDebug]()
* [Request.EnableGenerateCurlOnDebug]()
* [Request.DisableGenerateCurlOnDebug]()
* [Request.SetGenerateCurlOnDebug]()

```go
client := resty.New()
defer client.Close()

resp, err := client.R().
    EnableDebug().
    EnableGenerateCurlOnDebug(). // This option works in conjunction with debug mode
    SetBody(map[string]string{
        "name": "Alex",
    }).
    Post("https://httpbin.org/post")

curlCmdExecuted := resp.Request.GenerateCurlCommand()
fmt.Println(curlCmdExecuted)

// Result:
//     curl -X POST -H 'Content-Type: application/json' -H 'User-Agent: go-resty/3.0.0 (https://resty.dev)' -d '{"name":"Alex"}' https://httpbin.org/post

```
