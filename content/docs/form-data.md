
# Form Data

Resty provides a convenient method to compose form-data requests.

{{% hint info %}}
* By default, only allowed on payload-supported HTTP verbs, see [allow payload on]({{% relref "allow-payload-on" %}}).
* Request `Content-Type` set as `application/x-www-form-urlencoded`.
* Form data values are `URL-encoded`.
{{% /hint %}}

{{% hintreqoverride %}}

## Examples

### From Map

```go
c := resty.New()
defer c.Close()

// login request
res, err := c.R().
	SetFormData(map[string]string{
		"username": "myusername",
		"password": "mypassword",
	}).
	Post("https://myapp.com/login")

fmt.Println(err, res)

// followed by profile update
res, err := c.R().
	SetFormData(map[string]string{
		"first_name": "Jeevanandam",
		"last_name":  "M",
		"zip_code":   "00001",
		"city":       "new city update",
	}).
	Post("https://myapp.com/profile")

fmt.Println(err, res)
```

### From url.Values

```go
c := resty.New()
defer c.Close()

// sample multi-value form data
criteria := url.Values{
  "search_criteria": []string{"book", "glass", "pencil"},
}
res, err := c.R().
      SetFormDataFromValues(criteria).
      Post("https://myapp.com/search")

fmt.Println(err, res)
```

## Methods

### Client

* [Client.SetFormData]({{% godoc v3 %}}Client.SetFormData)

### Request

* [Request.SetFormData]({{% godoc v3 %}}Request.SetFormData)
* [Request.SetFormDataFromValues]({{% godoc v3 %}}Request.SetFormDataFromValues)