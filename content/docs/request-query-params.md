---
weight: 2
---

# Request Query Params

Resty provides easy-to-add request query parameters into requests.

    Example: search=kitchen%20papers&size=large

{{% hint info %}}
**NOTE:** Client-level settings can be overridden at the request level.
{{% /hint %}}

## Methods
* [Client.SetQueryParam]({{% param Resty.V3.GoDocLinkPrefix %}}Client.SetQueryParam)
* [Client.SetQueryParams]({{% param Resty.V3.GoDocLinkPrefix %}}Client.SetQueryParams)
* [Request.SetQueryParam]({{% param Resty.V3.GoDocLinkPrefix %}}Request.SetQueryParam)
* [Request.SetQueryParams]({{% param Resty.V3.GoDocLinkPrefix %}}Request.SetQueryParams)
* [Request.SetQueryParamsFromValues]({{% param Resty.V3.GoDocLinkPrefix %}}Request.SetQueryParamsFromValues)
* [Request.SetQueryString]({{% param Resty.V3.GoDocLinkPrefix %}}Request.SetQueryString)

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
