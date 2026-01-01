---
weight: 2
---

# Request Query Params

Resty provides easy-to-add request query parameters into requests.

    Example: search=kitchen%20papers&size=large

{{% hintreqoverride %}}

## Examples

### Single Query Param

```go
c := resty.New()
defer c.Close()

c.R().
    SetQueryParam("search", "kitchen papers").
    SetQueryParam("size", "large").
    Get("/search")

// Result:
//     /search?search=kitchen%20papers&size=large

```

### Multiple Query Params

```go
c := resty.New()
defer c.Close()

c.R().
    SetQueryParams(map[string]string{
		"search": "kitchen papers",
		"size": "large",
	}).
    Get("/search")

// Result:
//     /search?search=kitchen%20papers&size=large
```

### Query Params from url.Values

```go
c := resty.New()
defer c.Close()

c.R().
    SetQueryParamsFromValues(url.Values{
        "status": []string{"pending", "approved", "open"},
    }).
    Get("/search")

// Result:
//     /search?status=pending&status=approved&status=open
```

### Query Params from String

```go
c := resty.New()
defer c.Close()

c.R().
    SetQueryString("productId=232&template=fresh-sample&cat=resty&source=google&kw=buy a lot more").
    Get("/search")

// Result:
//     /search?cat=resty&kw=buy+a+lot+more&productId=232&source=google&template=fresh-sample
```

## Methods

### Client

* [Client.SetQueryParam]({{% godoc v3 %}}Client.SetQueryParam)
* [Client.SetQueryParamAny]({{% godoc v3 %}}Client.SetQueryParamAny)
* [Client.SetQueryParams]({{% godoc v3 %}}Client.SetQueryParams)

### Request

* [Request.SetQueryParam]({{% godoc v3 %}}Request.SetQueryParam)
* [Request.SetQueryParamAny]({{% godoc v3 %}}Request.SetQueryParamAny)
* [Request.SetQueryParams]({{% godoc v3 %}}Request.SetQueryParams)
* [Request.SetQueryParamsFromValues]({{% godoc v3 %}}Request.SetQueryParamsFromValues)
* [Request.SetQueryString]({{% godoc v3 %}}Request.SetQueryString)

## See Also

* [Any Value Methods]({{% relref "any-value-methods" %}}) - Methods that accept any type and auto-convert to string
