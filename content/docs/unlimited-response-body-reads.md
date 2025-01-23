
# Unlimited Response Body Reads

Resty v3 provides the ability to read HTTP response body unlimited times.

{{% hint warning %}}
* Keeps the response body in memory, which might cause additional memory usage.
{{% /hint %}}

{{% hintreqoverride %}}

## Example

The provided code snippet demonstrates:
* Response body auto-parsing.
* Saves the response body to the file system.

```go
loginResponseFile := "login-response.txt"

res, err := client.R().
    SetHeader(hdrContentTypeKey, "application/json").
    SetBody(&User{Username: "testuser", Password: "testpass"}).
    SetResponseBodyUnlimitedReads(true).
    SetResult(&LoginResponse{}).
    SetOutputFileName(loginResponseFile).
    Post("/login")

fmt.Println(err)

fmt.Println("")
loginResponse := res.Result().(*LoginResponse)
fmt.Println("ID:", loginResponse.ID)
fmt.Println("Message:", loginResponse.Message)

fmt.Println("")
loginResponseCnt, _ := os.ReadFile(loginResponseFile)
fmt.Println("File Content:", string(loginResponseCnt))

// output:
// nil
//
// ID: success
// Message: login successful
//
// File Content: { "id": "success", "message": "login successful" }
```

## Methods

### Client

* [Client.SetResponseBodyUnlimitedReads]({{% godoc v3 %}}Client.SetResponseBodyUnlimitedReads)

### Request

* [Request.SetResponseBodyUnlimitedReads]({{% godoc v3 %}}Request.SetResponseBodyUnlimitedReads)
