
# Custom DNS Resolver

Resty v3 introduces additional methods for creating client instances, including the [NewWithDialer]({{% godoc v3 %}}NewWithDialer) function.

```go
package main

import (
	"context"
	"fmt"
	"net"
	"time"

	"resty.dev/v3"
)

func main() {
	dialer := &net.Dialer{
		Resolver: &net.Resolver{
			PreferGo: true,
			Dial: func(ctx context.Context, network, address string) (net.Conn, error) {
				d := net.Dialer{
					Timeout: time.Duration(20) * time.Second,
				}
				return d.DialContext(ctx, "udp", "9.9.9.9:53") // Quad9 DNS
			},
		},
	}

	c := resty.NewWithDialer(dialer)
	defer c.Close()

	res, err := c.R().Get("https://httpbin.org/get")
	fmt.Println(err, res)
}
```