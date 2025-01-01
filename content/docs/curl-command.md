
# Curl Command

Resty provides an option to generate the curl command for the request.

By default, Resty does not log the curl command in the debug log since it has the potential to leak sensitive data unless explicitly enabled via [Client.SetDebugLogCurlCmd]({{% param Resty.V3.GoDocLinkPrefix %}}Client.SetDebugLogCurlCmd).

{{% hint info %}}
**NOTE:** Client-level settings can be overridden at the request level.
{{% /hint %}}

{{% hint warning %}}
**NOTE:**
   - Potential to leak sensitive data from [Request]({{% param Resty.V3.GoDocLinkPrefix %}}Request) and [Response]({{% param Resty.V3.GoDocLinkPrefix %}}Response) in the debug log when the debug log option is enabled.
   - Additional memory usage since the request body was reread.
   - curl body is not generated for `io.Reader` and multipart request flow.
{{% /hint %}}

## Example

```go
c := resty.New()
defer c.Close()

res, err := c.R().
    SetGenerateCurlCmd(true).
    SetBody(map[string]string{
        "name": "Alex",
    }).
    Post("https://httpbin.org/post")

curlCmdStr := res.Request.CurlCommand()
fmt.Println(err, curlCmdStr)

// Result:
//     curl -X POST -H 'Content-Type: application/json' -H 'User-Agent: go-resty/3.0.0 (https://resty.dev)' -d '{"name":"Alex"}' https://httpbin.org/post
```

## Methods

### Client

* [Client.EnableGenerateCurlCmd]({{% param Resty.V3.GoDocLinkPrefix %}}Client.EnableGenerateCurlCmd)
* [Client.DisableGenerateCurlCmd]({{% param Resty.V3.GoDocLinkPrefix %}}Client.DisableGenerateCurlCmd)
* [Client.SetGenerateCurlCmd]({{% param Resty.V3.GoDocLinkPrefix %}}Client.SetGenerateCurlCmd)
* [Client.SetDebugLogCurlCmd]({{% param Resty.V3.GoDocLinkPrefix %}}Client.SetDebugLogCurlCmd)

### Request

* [Request.EnableGenerateCurlCmd]({{% param Resty.V3.GoDocLinkPrefix %}}Request.EnableGenerateCurlCmd)
* [Request.DisableGenerateCurlCmd]({{% param Resty.V3.GoDocLinkPrefix %}}Request.DisableGenerateCurlCmd)
* [Request.SetGenerateCurlCmd]({{% param Resty.V3.GoDocLinkPrefix %}}Request.SetGenerateCurlCmd)
* [Request.SetDebugLogCurlCmd]({{% param Resty.V3.GoDocLinkPrefix %}}Request.SetDebugLogCurlCmd)
