
# Redirect History

Resty v3 adds the redirect history feature to the response.
* Method [Response.RedirectHistory]({{% godoc v3 %}}Response.RedirectHistory) returns [RedirectInfo]({{% godoc v3 %}}RedirectInfo) slice.

```go
package main

import (
	"fmt"

	"resty.dev/v3"
)

func main() {
	c := resty.New()
	defer c.Close()

	res, _ := c.R().Get("http://resty.dev")

	for _, rh := range res.RedirectHistory() {
		fmt.Println(rh.StatusCode, rh.URL)
	}
}
```