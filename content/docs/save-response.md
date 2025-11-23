---
weight: 4
---

# Save Response

Resty provides a simple method for saving/downloading HTTP responses to the file system.

> [!NOTE]
> Resty v3 adds -
> * Ability to determine the filename automatically from the response in the following order -
>     * [Request.SetOutputFileName]({{% godoc v3 %}}Request.SetOutputFileName)
>     * Header `Content-Disposition`
>     * Request URL using `path.Base`
>     * Request URL hostname if path is empty or "/"
> * Ability to use [Request.SetResult]({{% godoc v3 %}}Request.SetResult) and [Request.SetError]({{% godoc v3 %}}Request.SetError) together with save response by enabling [Request.SetResponseBodyUnlimitedReads]({{% godoc v3 %}}Request.SetResponseBodyUnlimitedReads), refer to [unlimited response reads]().

{{% hintreqoverride %}}

## Examples

### Save All Response

```go
// create a Resty client
c := resty.New().
    SetOutputDirectory("/path/to/save/all/response").
    SetSaveResponse(true) // applies to all requests
defer c.Close()

// start using the client ...
```

### Save Single Response

**Determines the filename from the URL**

```go
// save this image into the file system as "resty-logo.svg"
client.R().
    SetSaveResponse(true).
    Get("https://resty.dev/svg/resty-logo.svg")
```

**Want to control the output file name**

```go
// save this image into the file system as "resty-logo-blue.svg"
client.R().
    SetSaveResponse(true).
    SetOutputFileName("resty-logo-blue.svg"). // can be a relative or absolute path
    Get("https://resty.dev/svg/resty-logo.svg")
```

## Methods

### Client

* [Client.SetOutputDirectory]({{% godoc v3 %}}Client.SetOutputDirectory)
* [Client.SetSaveResponse]({{% godoc v3 %}}Client.SetSaveResponse)

### Request

* [Request.SetOutputFileName]({{% godoc v3 %}}Request.SetOutputFileName)
* [Request.SetSaveResponse]({{% godoc v3 %}}Request.SetSaveResponse)