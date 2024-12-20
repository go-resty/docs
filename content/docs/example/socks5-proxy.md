
# Socks5 Proxy

```go
package main

import (
	"fmt"

	"resty.dev/v3"
)

func main() {
	c := resty.New().
		SetProxy("socks5://127.0.0.1:1080")
	defer c.Close()

	res, err := c.R().
		Get("https://httpbin.org/get")

	fmt.Println(err, res)
}
```