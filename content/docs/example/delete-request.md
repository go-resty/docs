---
title: DELETE Request
weight: 2
---

# DELETE Request

This page discusses simple DELETE requests. Users can utilize Resty features across nearly all HTTP methods.

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
    SetAuthToken("bc594900518b4f7eac75bd37f019e08fbc594900518b4f7eac75bd37f019e08f").
    SetError(&Error{}). // or SetError(Error{}).
    Delete("https://myapp.com/articles/123456")

fmt.Println(err, res)
fmt.Println(res.Error().(*Error))
```

### With Payload

See [Allow Payload On]({{% relref "allow-payload-on" %}})

```go
res, err := client.R().
    SetAuthToken("bc594900518b4f7eac75bd37f019e08fbc594900518b4f7eac75bd37f019e08f").
    SetBody(map[string]any{
        "article_ids": []int{1002, 1006, 1007, 87683, 45432},
    }). // default request content type is JSON
    SetError(&Error{}). // or SetError(Error{}).
    Delete("https://myapp.com/articles")

fmt.Println(err, res)
fmt.Println(res.Error().(*Error))
```