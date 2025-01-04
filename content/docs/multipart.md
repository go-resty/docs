
# Multipart Form Data

Resty provides a convenient method to compose multipart form-data or ordered form-data requests.

{{% hint info %}}
* Only allowed on POST, PUT, and PATCH HTTP verbs.
* Starting v3, ordered multipart form data is possible.
* [Request.SetMultipartBoundary]({{% godoc v3 %}}Request.SetMultipartBoundary) setting custom boundary can be used together.
{{% /hint %}}

## Form Data

```go
// SetMultipartBoundary(`"custom-boundary"`).
res, err := c.R().
    SetMultipartFormData(map[string]string{
        "first_name": "Jeevanandam",
        "last_name":  "M",
        "zip_code":   "00001",
    }).
    Post("https://myapp.com/profile")

fmt.Println(err, res)
```

## Ordered Form Data

```go
res, err := c.R().
    SetMultipartOrderedFormData("first_name", []string{"Jeevanandam"}).
    SetMultipartOrderedFormData("last_name", []string{"M"}).
    SetMultipartOrderedFormData("zip_code", []string{"00001"}).
    Post("https://myapp.com/profile")

fmt.Println(err, res)


// it possbile to use SetMultipartFields for ordered form-data
fields := []*MultipartField{
    {
        Name:   "field1",
        Values: []string{"field1value1", "field1value2"},
    },
    {
        Name:   "field2",
        Values: []string{"field2value1", "field2value2"},
    }
}

res, err := c.R().
    SetMultipartFields(fields...). // it can be combined with SetMultipartOrderedFormData
    Post("https://myapp.com/profile")

fmt.Println(err, res)
```

## Methods

### Request

* [Request.SetMultipartFormData]({{% godoc v3 %}}Request.SetMultipartFormData)
* [Request.SetMultipartOrderedFormData]({{% godoc v3 %}}Request.SetMultipartOrderedFormData)
* [Request.SetMultipartBoundary]({{% godoc v3 %}}Request.SetMultipartBoundary)

# Multipart File Upload

{{% hint info %}}
* By default, Resty streams the content in the request body when a file or `io.Reader` is detected in the MultipartField input.
* Only allowed on POST, PUT, and PATCH HTTP verbs.
* [Request.SetMultipartBoundary]({{% godoc v3 %}}Request.SetMultipartBoundary) setting custom boundary can be used together.
{{% /hint %}}

## Upload

### Simple

### File with Content-Type

### Combine Form Data and Files Together

## Upload Progress


## Methods

### Request

* [Request.SetFile]({{% godoc v3 %}}Request.SetFile)
* [Request.SetFiles]({{% godoc v3 %}}Request.SetFiles)
* [Request.SetFileReader]({{% godoc v3 %}}Request.SetFileReader)
* [Request.SetMultipartField]({{% godoc v3 %}}Request.SetMultipartField)
* [Request.SetMultipartFields]({{% godoc v3 %}}Request.SetMultipartFields)
* [Request.SetMultipartBoundary]({{% godoc v3 %}}Request.SetMultipartBoundary)