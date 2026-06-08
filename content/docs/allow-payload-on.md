
# Allow Payload On

By default, Resty allows request payloads on POST, PUT, and PATCH under [RFC 9110](https://datatracker.ietf.org/doc/html/rfc9110.html) as of June 2022.

However, GET and DELETE have historically been subject to debate or interpretation. [RFC 9110](https://datatracker.ietf.org/doc/html/rfc9110.html) states:

    request has no generally defined semantics...

So, by default, Resty disallows request payloads on the GET and DELETE HTTP verbs.

Some real-world systems use request payloads on GET and DELETE. Resty provides explicit methods to enable payloads for these verbs.

## Methods

### Client

* [Client.SetMethodGetAllowPayload]({{% godoc v3 %}}Client.SetMethodGetAllowPayload)
* [Client.SetMethodDeleteAllowPayload]({{% godoc v3 %}}Client.SetMethodDeleteAllowPayload)

### Request

* [Request.SetMethodGetAllowPayload]({{% godoc v3 %}}Request.SetMethodGetAllowPayload)
* [Request.SetMethodDeleteAllowPayload]({{% godoc v3 %}}Request.SetMethodDeleteAllowPayload)
