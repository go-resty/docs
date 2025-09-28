
# Curl Command

Resty provides an option to generate the curl command for the request.

By default, Resty does not log the curl command in the debug log since it has the potential to leak sensitive data unless explicitly enabled via [Client.SetDebugLogCurlCmd]({{% godoc v3 %}}Client.SetDebugLogCurlCmd) or [Request.SetDebugLogCurlCmd]({{% godoc v3 %}}Request.SetDebugLogCurlCmd).

{{% hintreqoverride %}}

> [!WARNING]
> **NOTE:**
> - Potential to leak sensitive data from [Request]({{% godoc v3 %}}Request) and [Response]({{% godoc v3 %}}Response) in the debug log when the debug log option is enabled.
> - Additional memory usage since the request body was reread.
> - curl body is not generated for `io.Reader` and multipart request flow.

## Example

```go
c := resty.New()
defer c.Close()

res, _ := c.R().
    SetGenerateCurlCmd(true).
    SetBody(map[string]string{
        "name": "Resty",
    }).
    Post("https://httpbin.org/post")

curlCmdStr := res.Request.CurlCmd()
fmt.Println(curlCmdStr)

// Result:
// curl -X POST -H 'Accept-Encoding: gzip, deflate' -H 'Content-Type: application/json' -H 'User-Agent: go-resty/3.0.0 (https://resty.dev)' -d '{"name":"Resty"}' https://httpbin.org/post
```

## Methods

### Client

* [Client.EnableGenerateCurlCmd]({{% godoc v3 %}}Client.EnableGenerateCurlCmd)
* [Client.DisableGenerateCurlCmd]({{% godoc v3 %}}Client.DisableGenerateCurlCmd)
* [Client.SetGenerateCurlCmd]({{% godoc v3 %}}Client.SetGenerateCurlCmd)
* [Client.SetDebugLogCurlCmd]({{% godoc v3 %}}Client.SetDebugLogCurlCmd)

### Request

* [Request.CurlCmd]({{% godoc v3 %}}Request.CurlCmd)
* [Request.EnableGenerateCurlCmd]({{% godoc v3 %}}Request.EnableGenerateCurlCmd)
* [Request.DisableGenerateCurlCmd]({{% godoc v3 %}}Request.DisableGenerateCurlCmd)
* [Request.SetGenerateCurlCmd]({{% godoc v3 %}}Request.SetGenerateCurlCmd)
* [Request.SetDebugLogCurlCmd]({{% godoc v3 %}}Request.SetDebugLogCurlCmd)
