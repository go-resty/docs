
# Zstandard Decompress

Resty v3 allows users to add decompression logic for HTTP responses using their favorite package.

{{% hint info %}}
Using `sync.Pool` can reuse the reader and reduce allocation if the package supports `Reset`.
{{% /hint %}}

## Example

Package: [github.com/klauspost/compress/zstd](https://github.com/klauspost/compress)

[![Go Reference](https://pkg.go.dev/badge/github.com/klauspost/compress/zstd.svg)](https://pkg.go.dev/github.com/klauspost/compress/zstd)

```go
c := resty.New()
defer c.Close()

// Add decompresser into Resty
client.AddContentDecompresser("zstd", decompressZstd)

// Create Zstandard decompress logic
func decompressZstd(r io.ReadCloser) (io.ReadCloser, error) {
	zr, err := zstd.NewReader(r)
	if err != nil {
		return nil, err
	}
	z := &zstdReader{s: r, r: zr}
	return z, nil
}

type zstdReader struct {
	s io.ReadCloser
	r *zstd.Decoder
}

func (b *zstdReader) Read(p []byte) (n int, err error) {
	return b.r.Read(p)
}

func (b *zstdReader) Close() error {
	b.r.Close()
	return b.s.Close()
}
```
