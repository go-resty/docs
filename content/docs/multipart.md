
# Multipart Form Data

Resty provides a convenient method to compose multipart form-data or ordered form-data requests.

{{% hint info %}}
* Only allowed on POST, PUT, and PATCH verbs.
* Starting v3, ordered multipart form data is possible.
* [Request.SetMultipartBoundary]({{% godoc v3 %}}Request.SetMultipartBoundary) setting custom boundary can be used together.
* All form data and multipart methods can be used together.
{{% /hint %}}

```go
res, err := client.R().
    SetMultipartFormData(map[string]string{
        "first_name": "Jeevanandam",
        "last_name":  "M",
        "zip_code":   "00001",
    }).
    Post("https://myapp.com/profile")

fmt.Println(err, res)
```

## Ordered Form Data

### Example 1

```go
res, err := client.R().
    SetMultipartOrderedFormData("first_name", []string{"Jeevanandam"}).
    SetMultipartOrderedFormData("last_name", []string{"M"}).
    SetMultipartOrderedFormData("zip_code", []string{"00001"}).
    Post("https://myapp.com/profile")

fmt.Println(err, res)
```

### Example 2

```go
// it is possible to use SetMultipartFields for ordered form-data
fields := []*resty.MultipartField{
    {
        Name:   "field1",
        Values: []string{"field1value1", "field1value2"},
    },
    {
        Name:   "field2",
        Values: []string{"field2value1", "field2value2"},
    }
}

res, err := client.R().
    SetMultipartFields(fields...). // it can be combined with SetMultipartOrderedFormData
    Post("https://myapp.com/profile")

fmt.Println(err, res)
```

## Methods

### Request

* [Request.SetMultipartFormData]({{% godoc v3 %}}Request.SetMultipartFormData)
* [Request.SetMultipartOrderedFormData]({{% godoc v3 %}}Request.SetMultipartOrderedFormData)
* [Request.SetMultipartBoundary]({{% godoc v3 %}}Request.SetMultipartBoundary)

------------

# Multipart File Upload

{{% hint info %}}
* By default, Resty streams the content in the request body when a file or `io.Reader` is detected in the MultipartField input.
* Only allowed on POST, PUT, and PATCH verbs.
* [Request.SetMultipartBoundary]({{% godoc v3 %}}Request.SetMultipartBoundary) setting custom boundary can be used together.
* All form data and multipart methods can be used together.
{{% /hint %}}

## Upload

```go
// add one file
client.R().
    SetFile("my_file", "/path/to/file/sample.pdf") // field name and file path

// add multiple files together
client.R().
    SetFiles(map[string]string{
        // field name and file path
        "my_file1": "/path/to/file/sample1.pdf",
        "my_file2": "/path/to/file/sample2.pdf",
        "my_file3": "/path/to/file/sample3.pdf",
    })
```

### Use io.Reader

```go
// adding bytes or io.Reader
client.R().
    SetFileReader(
        "profile_img", // field name
        "my-profile-img.png", // file name
        bytes.NewReader(profileImgBytes), // io.Reader
    )
```

### With Content-Type

```go
// adding bytes or io.Reader with file content-type
client.R().
    SetMultipartField(
        "profile_img", // field name
        "my-profile-img.png", // file name
        "image/png", // file content-type
        bytes.NewReader(profileImgBytes), // io.Reader
    )
```

## Upload Progress

Resty v3 provides an optional multipart live upload progress count in bytes, see
* [Request.SetMultipartFields]({{% godoc v3 %}}Request.SetMultipartFields) - it is quite powerful, supports various combinations, [see example](#power-of-requestsetmultipartfields)
* [MultipartField]({{% godoc v3 %}}MultipartField) input type
    * Refer to the godoc to know more about `Optional` fields.
* [MultipartField.ProgressCallback]({{% godoc v3 %}}MultipartField) - callback method
* [MultipartFieldProgress]({{% godoc v3 %}}MultipartFieldProgress) - callback method argument

```go
progressCallback := func(mp resty.MultipartFieldProgress) {
    // progress argument provides all the required details
    fmt.Println("Name:", mp.Name)
    fmt.Println("FileName:", mp.FileName)
    fmt.Println("FileSize:", mp.FileSize)
    fmt.Println("Written:", mp.Written)
}

myImageFile, _ := os.Open("/path/to/image-1.png")
myImageFileStat, _ := myImageFile.Stat()

// demonstrate with various possibilities
client.R().
    SetMultipartFields(
        []*resty.MultipartField{
            // minimum required field, rest of the values are inferred
            // it is recommended to take advantage of input fields
            {
                Name:             "myfile_1",
                FilePath:         "/path/to/file-1.txt",
                ProgressCallback: progressCallback,
            },
            // with file name and content-type
            {
                Name:             "myimage_1",
                FileName:         "image-1.png",
                ContentType:      "image/png",
                FilePath:         "/path/to/image-1.png",
                ProgressCallback: progressCallback,
            },
            // with io.Reader and file size
            {
                Name:             "myimage_2",
                FileName:         "image-2.png",
                ContentType:      "image/png",
                Reader:           myImageFile,
                FileSize:         myImageFileStat.Size(),
                ProgressCallback: progressCallback,
            },
        }...,
    )
```

## Methods

### Request

* [Request.SetFile]({{% godoc v3 %}}Request.SetFile)
* [Request.SetFiles]({{% godoc v3 %}}Request.SetFiles)
* [Request.SetFileReader]({{% godoc v3 %}}Request.SetFileReader)
* [Request.SetMultipartField]({{% godoc v3 %}}Request.SetMultipartField)
* [Request.SetMultipartFields]({{% godoc v3 %}}Request.SetMultipartFields)
* [Request.SetMultipartBoundary]({{% godoc v3 %}}Request.SetMultipartBoundary)

----

# Use Form Data and Multipart Together

```go
// all form data and multipart methods can be used together
client.R().
    SetFormData(map[string]string{
        "first_name": []string{"Jeevanandam"},
    }).
    SetFormDataFromValues(url.Values{
        "last_name":  []string{"M"},
    }).
    SetFiles(map[string]string{
        // field name and file path
        "profile_img": "/path/to/profile/image.png",
    }).
    SetMultipartFormData(map[string]string{
        "zip_code": "00002",
    }).
    SetMultipartField(
        "profile_img2", // field name
        "my-profile-img2.png", // file name
        "image/png", // file content-type
        bytes.NewReader(profileImg2Bytes), // io.Reader
    ).
    SetMultipartFields(
        &resty.MultipartField{
            Name:   "city",
            Values: []string{"city name here"},
        },
    )
```

----

# Power of Request.SetMultipartFields

* This [MultipartField]({{% godoc v3 %}}MultipartField) input has various combinations; take advantage of it as per your use case.
    * Refer to the godoc to know more about `Optional` fields.

```go
myImageFile, _ := os.Open("/path/to/image-1.png")
myImageFileStat, _ := myImageFile.Stat()

// demonstrate with various combinations and possibilities
client.R().
    SetMultipartFields(
        []*resty.MultipartField{
            // add form data, order is preserved
            {
                Name:   "field1",
                Values: []string{"field1value1", "field1value2"},
            },
            {
                Name:   "field2",
                Values: []string{"field2value1", "field2value2"},
            },
            // add file upload
            {
                Name:             "myfile_1",
                FilePath:         "/path/to/file-1.txt",
            },
            // add file upload with progress callback
            {
                Name:             "myfile_1",
                FilePath:         "/path/to/file-1.txt",
                ProgressCallback: func(mp MultipartFieldProgress) {
    				// use the progress details
    			},
            },
            // with file name and content-type
            {
                Name:             "myimage_1",
                FileName:         "image-1.png",
                ContentType:      "image/png",
                FilePath:         "/path/to/image-1.png",
            },
            // with io.Reader and file size
            {
                Name:             "myimage_2",
                FileName:         "image-2.png",
                ContentType:      "image/png",
                Reader:           myImageFile,
                FileSize:         myImageFileStat.Size(),
            },
            // with io.Reader
            {
                Name:        "uploadManifest1",
                FileName:    "upload-file-1.json",
                ContentType: "application/json",
                Reader:      strings.NewReader(`{"input": {"name": "Uploaded document 1", "_filename" : ["file1.txt"]}}`),
            },
            // with io.Reader and progress callback
            {
                Name:             "image-file1",
                FileName:         "image-file1.png",
                ContentType:      "image/png",
                Reader:           bytes.NewReader(fileBytes),
                ProgressCallback: func(mp MultipartFieldProgress) {
                    // use the progress details
                },
            },
        }...,
    )
```