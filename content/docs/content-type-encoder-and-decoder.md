---
title: Content-Type {Encoder, Decoder}
weight: 7
---

# Content-Type {Encoder, Decoder}

 Resty v3 provides an extensible way to handle Request and Response content types. Out-of-the-box, it handles `JSON` and `XML` content types.

> [!NOTE]
> **NOTE:**
> * User-defined encoder/decoder takes priority over default ones.
> * Add method overwrites encoder/decoder if `Content-Type` key already exists.

## Examples

```go
c := resty.New()
defer c.Close()

c.AddContentTypeEncoder("http content type key here", func(w io.Writer, v any) error {
    // logic goes here

    return nil
})

c.AddContentTypeDecoder("http content type key here", func(w io.Reader, v any) error {
    // logic goes here

    return nil
})
```

## Methods

* [Client.AddContentTypeEncoder]({{% godoc v3 %}}Client.AddContentTypeEncoder)
* [Client.AddContentTypeDecoder]({{% godoc v3 %}}Client.AddContentTypeDecoder)
* [Client.ContentTypeEncoders]({{% godoc v3 %}}Client.ContentTypeEncoders)
* [Client.ContentTypeDecoders]({{% godoc v3 %}}Client.ContentTypeDecoders)
