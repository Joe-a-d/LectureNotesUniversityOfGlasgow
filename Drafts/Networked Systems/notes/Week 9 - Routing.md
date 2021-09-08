# Week 9 - Routing

- CDNs
- Inter-domain
- Security
- Intra-domain

## CDNs

- Load balancing and latency reduction
- Implementation
  - DNS
  - anycast

- What? a service which provides scalable, load balance low latency hosting for web content
  - content is cached in data centres and edge networks around the world
  - reduces load on the customer's main servers
  - reduces latency to respond to requests
  - reduces chances of successful DOS attacks

### Load Distribution


- load is distributed by locating web caches around the world and answering most requests from a local cache requires large-scale cooperation with ISPs, IXPs, etc
- mutual beneficial
  - load on ISP's own network is reduced since the cache distributes the content itself
  - avoids overload of link from ISP to outside world, "cheaper to keep it in house" without crossing other ISPs networks
  - increases the reach and robustness of CDN

### Latency Reduction

- by serving requests from local caches
  - requires global distribution of CDN proxy caches. Implication -> less developed regions are not effectively served since they lack data centres and infrastructure
- particularly effective for serving static content, though some support other applications by use of edge compute infrastructure

### CDN Location via DNS

- each resource hosted by the CDN has a unique DNS name with a unique domain name
  - `https://example.com/images/kitten.jpg` -> `https://9BC1C10B7947A890B9.cdn-example.com/kitten.jpg`
- DNS server for the CDN returns different A or AAAA records for a name depending on where it's request from, what CDN caches have the data
  - CDN can return a different IP address for each file replica
  - request is redirect to local cache based on IP address of resolver making the query, without needing to be too accurate. The goal is to track broad geographical caches , i.e. check that request originated from the UK and serve from London rather than India
- fine-grained control, since they can put a very low TTL on each DNS request, and give different answers for new requests, very rapidly load balancing.
  - but puts high load on DNS

### CDN Location via Anycast Routing

- instead of having unique domain names, have the DNS always map to the same IP address but give each resource a unique filename
  - the IP address is a load balancer at the entrance to a data centre
- the CDN uses multiple data centres *all using the same IP addresses*
  - each data centre advertises its addresses via BGP
  - Inter-domain routing will ensure traffic goes to the closes data centre to the source

## Inter-domain Routing

- ASs and the AS graph
- Routing
  - edge
  - core
- BGP

- Inter-domain routing is a problem of finding the best path from the source network to the destination network
  - network is treated as a graph with each AS being represented as a node
  - we are not calculating route on a hop by hop basis
  
### Autonomous Systems

- an independently operated network (e.g ISP) identifiable by UID allocated by the RIR

> REM [list](http://bgp.potaroo.net/cidr/autnums.html) of all AS numbers and names

- Below is a visualization of theses AS and the connections between them. The circle represents geographic regions, and nodes closer to the center are more well connected.
  - IPV6 graph is fair sparser as it is to be expected, since newer, hence less support.

![](@attachment/Clipboard_2021-05-18-20-28-39.png)

### Edge Routing

- Devices at the edge tend to have simple routing tables
  - list device on the local network : requests for machines with an IP belonging to the local network are routed directly by the network 
    - e.g. , cs department at uofg has reserved the `130.209.240/20` range
  - default route for everything else : if the requested IP doesn't fall within the range, the request is redirected to the edge router which will then redirect the packet to the internet
    - e.g. , continuing the example above `130.209.240.48` routes the packets to the rest of the campus, and some other will send it to the internet

### Core Routing

- more complex, because nodes at the core don't really have default roots. This works on the edges because there's only a small number of possible direct routes, only a small part of the network which is know, anything beyond the edge is "out there". Nodes at the core however are much more densely connected, hence they require a full routing table
  - *default free zone* : zone which is so densely interconnected which cannot just "send it out there" because it was precisely the place where all the smaller edge networks send their packets to
  - more information is required to choose the best path

  ![](@attachment/Clipboard_2021-05-18-20-49-36.png)

- over time the AS graph is getting more complex, in particular we see a flattening of the topology leading to increasingly rich interconnections
- IXPs are becomming commonplace , these are essentially buildings usually situated in large cities which host large Ethernet switches connecting the major AS
  - [London](https://www.linx.net/) , [NYC](https://www.nyiix.net/)

### Routing Policy

- Interdomain routing happens between competitors. Hence, business, political and economic relationships influence routing. Hence routing *must* consider policy. Policy restrictions mean that the shortest path routes are not necessarily appropriate
  - who determines the network topology
  - which route traffic should follow between a particular source and destination, should latency or cost be prioritised
  - circumvent particularly pricey competitors, or enemy governments

### Border Gateway Protocol (BGP)

- consists of two parts
  - External (eBGP) is used to exchange routing info between ASes
    - tells neighbours which paths are available
    - runs over a TCP connection between two routers of different ASes
    - used to compute appropriate Interdomain routes
  - Internal (iBGP) propagates this information to routers *within* the AS
    - intra-domain routing protocol (see next section) determines routes within the AS
    - tells neighbouring internal nodes how to reach the external nodes


### eBGP

- eBGP routers advertise lists of IP address ranges ("prefixed") and their associated AS-level paths forming a *routing table*

- the image below represents partial routing table. We can see that there are 7 different possible ways to get to destination, each mapping to a particular AS path. We can see that the shortest containing only 3 ASes is the one highlighted in red, hence the fastest.

![](@attachment/Clipboard_2021-05-18-21-04-33.png)

- the routing table represented as a graph

![](@attachment/Clipboard_2021-05-18-21-09-04.png)


- as discussed above the fastest route is not always the most optimal. Each AS chooses what routes to advertise to its neighbours, but it doesn't need to advertise everything it receives. Routes are designed to optimise profit not routing efficiency, hence expensive routes are not advertised.
  - Gao-Rexford is a common routing policy used to decide which routes to drop. - difference between control plane and data plane
    - (take JANET UK network as an example) classifies each AS as one of :
      - customer : pays you for internet access (e.g. individual universities)
      - peers : other networks which don't share for sharing internet access (e.g. other european academic networks)
      - providers : other ASes which charge for internet access (e.g. GANT pan-european)
    - resulting graph is valley-free DAG, i.e. traffic flows up to common provider, then down

  ![](@attachment/Clipboard_2021-05-18-21-16-09.png)

### BGP Routing Decision Process Summary

- Each AS exchanges routing information with neighbours (according to their policies) giving them a partial view of the topology
- Each AS applies policy to choose what routes to use
  - choose what route to install in the forwarding table for each destination prefix
- Each AS applies policy to determine what routes to advertise to neighbours
  - usually following Gao-Rexford, but other reasons exist
  - certain routes can be tagged where business agreements exist
- BGP exchanges routes between ASes
  - the BGP decision process is public but the input data (the potential connections not allowed to use) is not, hence it makes it difficult to evaluate how routing decisions are made
- In the end the goal is to find the shortest path *after* all routes which do not comply to one's policies have been filtered out

## Routing Security

- what
- problems
- RPKI
- MANRS

- being able to advertise prefixes using BGP but making sure that the advertiser is the owner of that route , which is not guaranteed by BGP since any AS participant can advertise any prefix

BGP hijacking
: when an AS advertises a prefix which does not own, misdirecting traffic

#### Case Study - Accidental Hijacking

[Source](https://www.ripe.net/publications/news/industry-developments/youtube-hijacking-a-ripe-ncc-ris-case-study)

- ISPs in Pakistan were told to block youtube
- One ISP decided to do this by injecting the IP addresses ranges owned by youtube to its part of the network, so that all customers within the country would be redirected to their website
- PROBLEM : they misconfigured their routers and announced it to the rest of the Internet outside Pakistan, hence all youtube traffic was redirected to their website

### Resource Public Key Infrastructure (RPKI)

- Lets an AS make a signed *Route Origin Authorisation* (ROA) - a digital signature
  - becomes part of BGP policy, i.e. prefer signed prefixes
- Only about 12% of IPv4 addresses are signed, but [growing rapidly](https://blog.cloudflare.com/rpki-2020-fall-update/)