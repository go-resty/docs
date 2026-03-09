
# Allow Payload On

By default, Resty allows request payload on POST, PUT, and PATCH per the latest [RFC 9110](https://datatracker.ietf.org/doc/html/rfc9110.html) as of Jun 2022.

However, the methods GET and DELETE have been the subject of debate or interpretation in the past, at least with the latest [RFC 9110](https://datatracker.ietf.org/doc/html/rfc9110.html), which states that -

    request has no generally defined semantics...

So Resty, by default, disallows the request payload on GET and DELETE HTTP verbs.

Some systems, in real-world use, request payloads on GET and DELETE. Resty provides explicit methods to enable payload for these verbs.

## Methods

### Client

* [Client.SetMethodGetAllowPayload]({{% godoc v3 %}}Client.SetMethodGetAllowPayload)
* [Client.SetMethodDeleteAllowPayload]({{% godoc v3 %}}Client.SetMethodDeleteAllowPayload)

### Request

* [Request.SetMethodGetAllowPayload]({{% godoc v3 %}}Request.SetMethodGetAllowPayload)
* [Request.SetMethodDeleteAllowPayload]({{% godoc v3 %}}Request.SetMethodDeleteAllowPayload)
