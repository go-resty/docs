
# Brotli Decompress

Resty v3 allows users to add decompression logic for HTTP responses using their favorite package.

## Example 1

Uses package: [github.com/andybalholm/brotli](https://github.com/andybalholm/brotli)

```go
c := resty.New()
defer c.Close()

// Add decompresser into Resty
client.AddContentDecompresser("br", decompressBrotli)

// Create Brotli decompress logic
func decompressBrotli(r io.ReadCloser) (io.ReadCloser, error) {
	br := &brotliReader{s: r, r: brotli.NewReader(r)}
	return br, nil
}

type brotliReader struct {
	s io.ReadCloser
	r *brotli.Reader
}

func (b *brotliReader) Read(p []byte) (n int, err error) {
	return b.r.Read(p)
}

func (b *brotliReader) Close() error {
	return b.s.Close()
}
```

## Example 2

Uses package: [github.com/dsnet/compress](https://github.com/dsnet/compress)

```go
c := resty.New()
defer c.Close()

// Add decompresser into Resty
client.AddContentDecompresser("br", decompressBrotli)

// Create Brotli decompress logic
func decompressBrotli(r io.ReadCloser) (io.ReadCloser, error) {
	br, err := brotli.NewReader(r, nil)
	if err != nil {
		return nil, err
	}
	b := &brotliReader{s: r, r: br}
	return b, nil
}

type brotliReader struct {
	s io.ReadCloser
	r *brotli.Reader
}

func (b *brotliReader) Read(p []byte) (n int, err error) {
	return b.r.Read(p)
}

func (b *brotliReader) Close() error {
	_ = b.r.Close()
	return b.s.Close()
}
```
