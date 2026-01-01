---
weight: 4
---

# Any Value Methods

Resty provides `*Any` convenience methods that accept `any` type values and automatically convert them to strings using predefined formatting rules. These methods eliminate the need for manual `strconv` or `fmt.Sprintf` calls when working with non-string values.

{{% hintreqoverride %}}

## Type Conversion Rules

Values are converted to strings based on these rules (in order of priority):

| Type | Conversion Method |
|------|-------------------|
| `string` | Used as-is |
| `int` | `strconv.Itoa()` |
| `bool` | `strconv.FormatBool()` |
| `int64` | `strconv.FormatInt()` |
| `[]string` | `strings.Join(v, ",")` |
| `time.Time` | `v.Format(time.RFC3339)` |
| `[]byte` | `string(v)` |
| `float64` | `strconv.FormatFloat()` |
| `int32`, `int16`, `int8` | `strconv.FormatInt()` |
| `uint64`, `uint32`, `uint16`, `uint8`, `uint` | `strconv.FormatUint()` |
| `float32` | `strconv.FormatFloat()` |
| `fmt.Stringer` | `v.String()` |
| Any other type | `fmt.Sprint(v)` |

## Examples

### Query Params with Non-String Values

Instead of manually converting values to strings:

```go
// Without *Any methods - manual conversion required
c.R().
    SetQueryParam("page", strconv.Itoa(5)).
    SetQueryParam("active", strconv.FormatBool(true)).
    Get("/items")
```

You can use the `SetQueryParamAny` method:

```go
c := resty.New()
defer c.Close()

c.R().
    SetQueryParamAny("page", 5).
    SetQueryParamAny("active", true).
    Get("/items")

// Result:
//     /items?active=true&page=5
```

### Path Params with Integer IDs

```go
c := resty.New()
defer c.Close()

c.R().
    SetPathParamAny("userId", 12345).
    SetPathParamAny("postId", 67890).
    Get("/users/{userId}/posts/{postId}")

// Result:
//     /users/12345/posts/67890
```

### Headers with Timestamps

```go
c := resty.New()
defer c.Close()

c.R().
    SetHeaderAny("X-Request-Id", 798940).
    SetHeaderAny("X-Timestamp", time.Now()).
    Post("/events")

// Headers:
//     X-Request-Id: 798940
//     X-Timestamp: 2024-06-15T10:30:00Z
```

### Headers with Verbatim Key Casing

Use `SetHeaderVerbatimAny` to preserve the exact header key casing:

```go
c := resty.New()
defer c.Close()

c.R().
    SetHeaderVerbatimAny("x-trace-id", 123456).
    Get("/api/resource")

// Header key preserved as: x-trace-id (not X-Trace-Id)
```

### Raw Path Params (No URL Encoding)

Use `SetRawPathParamAny` when you don't want the value to be URL-encoded:

```go
c := resty.New()
defer c.Close()

c.R().
    SetRawPathParamAny("path", "groups/developers").
    Get("/v1/users/{path}/details")

// Result:
//     /v1/users/groups/developers/details
```

Compare with `SetPathParamAny` which URL-encodes the value:

```go
c.R().
    SetPathParamAny("path", "groups/developers").
    Get("/v1/users/{path}/details")

// Result:
//     /v1/users/groups%2Fdevelopers/details
```

### Custom Types with fmt.Stringer

Types that implement `fmt.Stringer` are automatically converted using their `String()` method:

```go
type Status int

const (
    StatusPending Status = iota
    StatusApproved
    StatusRejected
)

func (s Status) String() string {
    return [...]string{"pending", "approved", "rejected"}[s]
}

c := resty.New()
defer c.Close()

c.R().
    SetQueryParamAny("status", StatusApproved).
    Get("/items")

// Result:
//     /items?status=approved
```

### Combining Multiple Any Methods

```go
c := resty.New()
defer c.Close()

c.R().
    SetPathParamAny("userId", 12345).
    SetQueryParamAny("page", 1).
    SetQueryParamAny("limit", 20).
    SetQueryParamAny("active", true).
    SetHeaderAny("X-Request-Id", requestId).
    SetHeaderAny("X-Timestamp", time.Now()).
    Get("/users/{userId}/posts")
```

## Methods

### Client

#### Headers
* [Client.SetHeaderAny]({{% godoc v3 %}}Client.SetHeaderAny)
* [Client.SetHeaderVerbatimAny]({{% godoc v3 %}}Client.SetHeaderVerbatimAny)

#### Query Params
* [Client.SetQueryParamAny]({{% godoc v3 %}}Client.SetQueryParamAny)

#### Path Params
* [Client.SetPathParamAny]({{% godoc v3 %}}Client.SetPathParamAny)
* [Client.SetRawPathParamAny]({{% godoc v3 %}}Client.SetRawPathParamAny)

### Request

#### Headers
* [Request.SetHeaderAny]({{% godoc v3 %}}Request.SetHeaderAny)
* [Request.SetHeaderVerbatimAny]({{% godoc v3 %}}Request.SetHeaderVerbatimAny)

#### Query Params
* [Request.SetQueryParamAny]({{% godoc v3 %}}Request.SetQueryParamAny)

#### Path Params
* [Request.SetPathParamAny]({{% godoc v3 %}}Request.SetPathParamAny)
* [Request.SetRawPathParamAny]({{% godoc v3 %}}Request.SetRawPathParamAny)

## See Also

* [Request Query Params]({{% relref "request-query-params" %}}) - String-based query parameter methods
* [Request Path Params]({{% relref "request-path-params" %}}) - String-based path parameter methods
