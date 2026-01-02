# Error Handling

In the Resty request and response flow, error handling is a crucial part of the implementation. It’s recommended to check and handle it appropriately. For more information, continue reading the page.

## Possible Area of Errors/Failures

* Request Errors: Connection, Network, Timeout, Lifecycle, Configuration, and Protocol
    * DNS related (lookup, host not found, etc.)
    * Connection related (refused, reset, broken, etc.)
    * End of File (socket closed, etc.)
    * TLS handshake (negotiation, timeout, etc.)
    * URL related (invalid, malformed, etc.)
    * Marshalling errors
    * Resty validation errors
    * Context cancellation errors
    * etc.
* Response Errors: Server Sent HTTP Status Codes
    * Success: Typically indicated by status code 2xx range.
    * Failure: Typically indicated by status code 4xx and 5xx range.

Let's take a simple example to cover the above-mentioned errors.

```go
// create a Resty client
client := resty.New()
defer client.Close()

// We are going to make a login request to demonstrate the above-mentioned
// Request and Response Errors
res, err := client.R().
    SetBody(User{
        Username: "testuser",
        Password: "testpass",
    }). // default request content type is JSON
    SetResult(&LoginResponse{}).
    SetResultError(&LoginErrorResponse{}).
    Post("https://myapp.com/login")

//****************
// Request Errors
//****************
// When err != nil, it means Request Error happened
if err != nil {
    // Handle the error appropriately, do not ignore it

    // perform the logic here

    return
}

//*****************
// Response Errors
//*****************
// Resty provides the necessary methods to facilitate the easy checking of status codes.

// Response.IsStatusFailure returns true if HTTP status `code >= 400` otherwise false.
if res.IsStatusFailure() {
    // Failure: Typically indicated by status code 4xx and 5xx range.
    // perform the logic here

    // Resty provides auto-unmarshalling feature for JSON and XML.
    // Use the `Request.SetResultError` method to set the type of the failure response object.

    // access
    fmt.Println(res.ResultError().(*LoginErrorResponse))

    return
}

// Response.IsStatusSuccess method returns true if HTTP status `code >= 200 and <= 299` otherwise false.
if res.IsStatusSuccess() {
    // Success: Typically indicated by status code 2xx range.
    // perform the logic here

    // Resty provides auto-unmarshalling feature for JSON and XML.
    // Use the `Request.SetResult` method to set the type of the success response object.

    // access
    fmt.Println(res.Result().(*LoginResponse))
}
```

## Best Practices

There are many best practices around. I have collated many with the context of Resty Client.

* Always check the `err != nil` first and handle it appropriately.
* Make use of `errors.Is` and `errors.As` methods to inspect errors instead of string matching on errors.
* Always check the HTTP status code explicitly; `err == nil` doesn't mean it is a 200 OK status code.
* Have a common method to handle error patterns and handle the resolution consistently across.
* Make use of the auto-unmarshalling feature with `SetResult` and `SetResultError` to distinguish between success and failure responses.
* Always check the `response.CascadeError != nil` in the Response middleware before applying the middleware logic.
* Make use of the `Response.CascadeError` field in the Response middleware to cascade errors to the next middleware.
