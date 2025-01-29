
# Debug Log

The debug log provides insights into Resty's request and response details for troubleshooting. The v3 introduces the debug log formatter feature, allowing the debug log content customization for the user's use case. Out of the box, the following formatters are available:

* [DebugLogFormatter]({{% godoc v3 %}}DebugLogFormatter) (default)
* [DebugLogJSONFormatter]({{% godoc v3 %}}DebugLogJSONFormatter)

## Default Behaviour

* Automatically sanitize HTTP headers in both Request and Response if the header key contains `authorization`, `auth`, or `token`.
* Applies a human-readable debug log formatter.

## Examples

### Get Started

```go
// enabling debug for all requests
c := resty.New().
    SetDebug(true)

// enabling debug for a particular request
req := c.R().SetDebug(true)

// few syntactic sugar methods available; see Methods section
```

### Editing Log Details

Register to debug log callback for any log modification; see [DebugLog]({{% godoc v3 %}}DebugLog).

```go
c := resty.New().
    OnDebugLog(func(dl *DebugLog) {
        // logic goes here
    })
```

### JSON Formatter

```go
c := resty.New().
    SetDebugLogFormatter(resty.DebugLogJSONFormatter)
```

### Custom Formatter

See [DebugLog]({{% godoc v3 %}}DebugLog).

```go
// implement custom debug log formatter
func DebugLogCustomFormatter(dl *DebugLog) string {
    logContent := ""

    // perform log manipulation logic here

	return logContent
}

// set the custom debug log formatter
c := resty.New().
    SetDebugLogFormatter(DebugLogCustomFormatter)
```

## Methods

### Client

* [Client.SetDebug]({{% godoc v3 %}}Client.SetDebug)
* [Client.EnableDebug]({{% godoc v3 %}}Client.EnableDebug)
* [Client.DisableDebug]({{% godoc v3 %}}Client.DisableDebug)
* [Client.SetDebugBodyLimit]({{% godoc v3 %}}Client.SetDebugBodyLimit)
* [Client.OnDebugLog]({{% godoc v3 %}}Client.OnDebugLog)
* [Client.SetDebugLogFormatter]({{% godoc v3 %}}Client.SetDebugLogFormatter)

### Request

* [Request.SetDebug]({{% godoc v3 %}}Request.SetDebug)
* [Request.EnableDebug]({{% godoc v3 %}}Request.EnableDebug)
* [Request.DisableDebug]({{% godoc v3 %}}Request.DisableDebug)