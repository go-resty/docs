---
title: GET Request
weight: 1
---

# GET Request

This page discusses simple GET requests. Users can utilize Resty features across nearly all HTTP methods.

{{% hint info %}}
* Explore the documentation to fulfill all use cases.
* Examples use request-level methods; however, Resty also includes client-level methods to configure settings for all requests.
{{% /hint %}}

## Examples

See [Request Body Types]({{% relref "request-body-types" %}}), [Allow Payload On]({{% relref "allow-payload-on" %}})

```go
// create a Resty client
client := resty.New()
defer client.Close()
```

### Simple

```go
res, err := client.R().
    Get("https://httpbin.org/get")

fmt.Println(err, res)
```

### With Query Params

See [Request Query Params]({{% relref "request-query-params" %}})

```go
res, err := client.R().
    SetQueryParams(map[string]string{
        "page_no": "1",
        "limit":   "20",
        "sort":    "name",
        "order":   "asc",
        "random":  strconv.FormatInt(time.Now().Unix(), 10),
    }).
    SetHeader("Accept", "application/json").
    SetAuthToken("bc594900518b4f7eac75bd37f019e08fbc594900518b4f7eac75bd37f019e08f").
    Get("/search_result")

fmt.Println(err, res)
```

### With Path Params

See [Request Path Params]({{% relref "request-path-params" %}})

```go
res, err := client.R().
    SetPathParams(map[string]string{
		"userId":       "sample@sample.com",
		"subAccountId": "100002",
	}).
    SetAuthToken("bc594900518b4f7eac75bd37f019e08fbc594900518b4f7eac75bd37f019e08f").
    Get("/v1/users/{userId}/{subAccountId}/details")

fmt.Println(err, res)
```

### With Payload

See [Allow Payload On]({{% relref "allow-payload-on" %}})

```go
res, err := client.R().
    SetAllowMethodGetPayload(true). // client level options is available
    SetContentType("application/json").
    SetBody(`{
        "query": {
            "simple_query_string" : {
                "query": "\"fried eggs\" +(eggplant | potato) -frittata",
                "fields": ["title^5", "body"],
                "default_operator": "and"
            }
        }
    }`). // this is string value as request body
    SetAuthToken("bc594900518b4f7eac75bd37f019e08fbc594900518b4f7eac75bd37f019e08f").
    Get("/_search")

fmt.Println(err, res)
```