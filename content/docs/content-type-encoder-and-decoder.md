---
title: Content-Type {Encoder, Decoder}
weight: 7
---

# Content-Type {Encoder, Decoder}

 Resty v3 provides an extensible way to handle Request and Response content types. Out-of-the-box, it handles using Go built-in package -

* `JSON` content-type using [`json.Encoder`]({{% param Resty.GoDoc %}}/encoding/json#Encoder) and [`json.Decoder`]({{% param Resty.GoDoc %}}/encoding/json#Decoder)
* `XML` content-type using [`xml.Encoder`]({{% param Resty.GoDoc %}}/encoding/xml#Encoder) and [`xml.Decoder`]({{% param Resty.GoDoc %}}/encoding/xml#Decoder)

> [!NOTE]
> **NOTE:**
> * User-defined encoder/decoder takes priority over default ones.
> * Add method overwrites encoder/decoder if `Content-Type` key already exists.
> * Resty v3 uses a streaming approach by default to handle JSON and XML content types, improving memory efficiency. Resty also provides the [In-Memory Marshal and Unmarshal]({{% relref "#in-memory-marshal-and-unmarshal" %}}) section.

## Examples

```go
c := resty.New()
defer c.Close()

c.AddContentTypeEncoder("http content type key here", func(w io.Writer, v any) error {
    // logic goes here

    return nil
})

c.AddContentTypeDecoder("http content type key here", func(r io.Reader, v any) error {
    // logic goes here

    return nil
})
```

## In Memory Marshal and Unmarshal

Resty v3 provides in-memory marshal and unmarshal for `JSON` and `XML` content types using Go’s built-in packages.

```go
c := resty.New()
defer c.Close()

// JSON
c.AddContentTypeEncoder("application/json", resty.InMemoryJSONMarshal)
c.AddContentTypeDecoder("application/json", resty.InMemoryJSONUnmarshal)

// XML
c.AddContentTypeEncoder("application/xml", resty.InMemoryXMLMarshal)
c.AddContentTypeDecoder("application/xml", resty.InMemoryXMLUnmarshal)
```


## Methods

* [Client.AddContentTypeEncoder]({{% godoc v3 %}}Client.AddContentTypeEncoder)
* [Client.AddContentTypeDecoder]({{% godoc v3 %}}Client.AddContentTypeDecoder)
* [Client.ContentTypeEncoders]({{% godoc v3 %}}Client.ContentTypeEncoders)
* [Client.ContentTypeDecoders]({{% godoc v3 %}}Client.ContentTypeDecoders)
