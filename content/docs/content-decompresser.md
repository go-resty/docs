---
weight: 7
---

# Content Decompresser

Resty v3 provides an extensible way to handle Response content decompression. Out-of-the-box, it handles `gzip` and `deflate` decompress.

> [!NOTE]
> **NOTE:**
> * User-defined decompresser takes priority over default ones.
> * Add method overwrites decompresser if `decompress` directive/key already exists.
> * [Content-Encoding directive/key](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Encoding) is important while adding decompresser.

## Example

Refer to the example section for [Brotli (br)]({{% relref "decompress-brotli" %}}) and [Zstandard (zstd)]({{% relref "decompress-zstandard" %}}) decompress.

```go
c := resty.New()
defer c.Close()

c.AddContentDecompresser("decompress directive/key here", func(r io.ReadCloser) (io.ReadCloser, error) {
    // logic goes here

    return nil, nil
})
```

## Methods

* [Client.AddContentDecompresser]({{% godoc v3 %}}Client.AddContentDecompresser)
* [Client.SetContentDecompresserKeys]({{% godoc v3 %}}Client.SetContentDecompresserKeys)
* [Client.ContentDecompressers]({{% godoc v3 %}}Client.ContentDecompressers)
* [Client.ContentDecompresserKeys]({{% godoc v3 %}}Client.ContentDecompresserKeys)
