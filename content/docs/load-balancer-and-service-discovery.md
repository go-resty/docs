
# Load Balancer and Service Discovery

Resty v3 provides new ways to discover the Base URL and client-side load balancing.

Out of the box, Resty provides two algorithms -

* [Round-Robin (RR)]()
* [Weighted Round-Robin (WRR)]

Also, SRV records discovery using the Weighted Round-Robin (WRR) algorithm, called []().

{{% hint info %}}
* Version 2 had an SRV record lookup feature but did not utilize a record weight value. Version 3 respects the record weight value and executes the appropriate weighted round-robin.
* Version 3 enables Resty users to implement any custom method for determining the Base URL through the [LoadBalancer]({{% godoc v3 %}}LoadBalancer) interface.
{{% /hint %}}

## Examples

### Round-Robin

```go
// create a load balancer
// accepts one or more URLs
rr, err := resty.NewRoundRobin(
    "https://example1.com",
    "https://example2.com",
    "https://example3.com",
)
if err != nil {
    log.Printf("ERROR %v", err)
    return
}

// create Resty client
c := resty.New().
    SetLoadBalancer(rr)
defer c.Close()

// start using the client ...
```

### Weighted Round-Robin

```go
// create a load balancer
// accepts one or more Host(s)
wrr, err := resty.NewWeightedRoundRobin(
    3*time.Second, // recovery duration
    []*resty.Host{
        {
            BaseURL: "https://example1.com",
            Weight:  50, // determines the percentage of requests to this host
        },
        {BaseURL: "https://example2.com", Weight: 30},
        {BaseURL: "https://example3.com", Weight: 20},
    }...,
)
if err != nil {
    log.Printf("ERROR %v", err)
    return
}

// by default, the recovery duration is 120 seconds, which can be changed as follows
// wrr.SetRecoveryDuration(3 * time.Minute)

// create Resty client
c := resty.New().
    SetLoadBalancer(wrr)
defer c.Close()

// start using the client ...
```

### SRV Weighted Round-Robin

```go
// create a load balancer
swrr, err := resty.NewSRVWeightedRoundRobin(
    "_sample-server",
    "tcp", // default proto is tcp
    "example.com",
    "https", // default scheme is https
)
if err != nil {
    log.Printf("ERROR %v", err)
    return
}

// by default, the SRV records refresh duration is 180 seconds, which can be changed as follows
// swrr.SetRefreshDuration(1 * time.Hour)

// by default, the recovery duration is 120 seconds, which can be changed as follows
// swrr.SetRecoveryDuration(3 * time.Minute)

// create Resty client
c := resty.New().
    SetLoadBalancer(swrr)
defer c.Close()

// start using the client ...
```

### User-defined Algorithm

Version 3 enables Resty users to implement any custom method for determining the Base URL through the [LoadBalancer]({{% godoc v3 %}}LoadBalancer) interface.

Interface contains three methods -

* [Next]({{% godoc v3 %}}LoadBalancer)
* [Feedback]({{% godoc v3 %}}LoadBalancer)
* [Close]({{% godoc v3 %}}LoadBalancer)

```go
// create a custom load balancer
var _ resty.LoadBalancer = (*MyCustomAlgorithm)(nil)

// MyCustomAlgorithm struct implements a custom load balancer algorithm
type MyCustomAlgorithm struct {
	// defined required fields
}

// Next method returns the next Base URL based on the custom algorithm
func (mca *MyCustomAlgorithm) Next() (string, error) {
    // perform custom load balancer algorithm logic
    // and return Base URL or error

	return baseURL, nil
}

// Feedback method process the request feedback for custom
// load balancer algorithm
func (mca *MyCustomAlgorithm) Feedback(rf_ *RequestFeedback) {
    // process the request feedback and use it
    // for next Base URL calculation
}

// Close method does the cleanup activities for the custom load balancer
func (mca *MyCustomAlgorithm) Close() error {
    // perform clean up activities
    // such as closing channels, etc.

    return nil
}

// initialize the custom load balancer
mc := &MyCustomAlgorithm {
    // initialize here ...
}

// create Resty client
c := resty.New().
    SetLoadBalancer(mc)
defer c.Close()

// start using the client ...
```

## Methods

* [NewRoundRobin]({{% godoc v3 %}}NewRoundRobin)
* [NewWeightedRoundRobin]({{% godoc v3 %}}NewWeightedRoundRobin)
* [NewSRVWeightedRoundRobin]({{% godoc v3 %}}NewSRVWeightedRoundRobin)

### Client

* [Client.SetLoadBalancer]({{% godoc v3 %}}Client.SetLoadBalancer)

### RoundRobin

* [RoundRobin.Refresh]({{% godoc v3 %}}RoundRobin.Refresh)

### WeightedRoundRobin

* [WeightedRoundRobin.Refresh]({{% godoc v3 %}}WeightedRoundRobin.Refresh)
* [WeightedRoundRobin.SetOnStateChange]({{% godoc v3 %}}WeightedRoundRobin.SetOnStateChange)
* [WeightedRoundRobin.SetRecoveryDuration]({{% godoc v3 %}}WeightedRoundRobin.SetRecoveryDuration)


### SRVWeightedRoundRobin

* [SRVWeightedRoundRobin.Refresh]({{% godoc v3 %}}SRVWeightedRoundRobin.Refresh)
* [SRVWeightedRoundRobin.SetOnStateChange]({{% godoc v3 %}}SRVWeightedRoundRobin.SetOnStateChange)
* [SRVWeightedRoundRobin.SetRecoveryDuration]({{% godoc v3 %}}SRVWeightedRoundRobin.SetRecoveryDuration)
* [SRVWeightedRoundRobin.SetRefreshDuration]({{% godoc v3 %}}SRVWeightedRoundRobin.SetRefreshDuration)
