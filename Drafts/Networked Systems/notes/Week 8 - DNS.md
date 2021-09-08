# Week 8 - DNS

- what ?
- DNS Resolution
- Naming structure and organisation
- Methods for DNS resolution
- Intersection of Tech and Politics

# DNS Name Resolution
- what?
- structure
- name resolution

- IP packets contain addresses not names, which are not human readable (or at least friendly)
- DNS is a distributed database which maps names to IP addresses
- Domain Name within the URL is the bit which gets translated into a set of IP addresses to reach the server

## Structure

- hierarchical (e.g www.gla.ac.uk)
	- sub-domains first (e.g. www , gla)
	- top-level domain (TLD) (e.g. ac , uk)
- TLD live within the DNS root
	-  this root server cannot by definition live in the DNS since they are the first point of contact for DNS resolvers. Hence, they have known, fixed IP addresses
- Each level in hierarchy is independently administered and operated

## Name Resolution

- given a name , perform a lookup for a specific type of *record* relating to that name
	- many different types of records (A, AAAA, CNMAE, ...) but most common are A and AAAA that map hostnames to IPv4 and IPv6 addresses and NS records which identify the name server for the domain
- DNS client asks  its resolver to perform the lookup by calling `getaddrinfo()`
- if the resolver has no info it makes a recursive query, working its way down the hierarchy, via the DNS root servers
	- query the root to find the TLD
	- query the TLD to find the subdomain
	- query the subdomain to find the address
- responses include a TTL that allows a resolver to *cache* the value for a certain time period
	-  TTL for root is essentially infinite
	- a site hosted on a single server can afford to give a long TTL (a few days e.g) since it is always on the same server
	- busy websites' subdomains can set a short TTL and give different answers each time a particular name is requested, this is because they perform load balancing ; hitting CDNs is likely to have the same result, so that they can hit different caches

# DNS Names

- Ownership
- TLDs
- Internationalisation
- DNS root

## History and Overview

- IANA created in the ARPANET times, and initial run by Postel in UCLA
	- worked on it part-time as a grad student in UCLA
- Internet grows and  IANA merges with ICANN
	- nowadays is a global organisation
	- political with members who have competing interests
	- US Gov control ends on October 2016

## TDDs

- 4 types
	- Country code : most use ISO standard two letter codes
	- Generic : represent different types (com, edu, gov ...) ; greatly expanded wit approx 1500 today
	- Infrastructure : `.arpa` historic relic from ARPANET, but still used for reverse DNS lookups (IP -> Domain Name)
		- possible because the address is stored alongside the name using `in-addr.arpa`
	- Special Use : 6 exist in total , e.g. .onion, .localhost 

## Internationalised DNS

- all use ASCII, should move to UTF-8, tough difficult to protocol ossification
	- workaround : translates non-ASCII into ASCII using Punnycode , non-ASCII domain names are prefixed wit `xn--`(TODO LINK AND EXAMPLE)

## DNS Root

- there are 13 root servers that advertise the name servers for the TDDs
	- a.root-servers.net -> m.root-servers.net
	- 13 because we need to ask a DNS resolver to return a list of all the root servers and a single UDP packet can only return a max of 13
	- not really 13 physical machines , instead use anycast (see lec9) so that multiple machines can advertise same address
- heavily US-based because history (initial orgs founded there) + ossification (IPs too widely know for change)


# DNS Resolution

- security
- different methods

## Security

- historically completely insecure
	- trivial to eavesdrop on who is looking up what name ; because unencrypted and unauthenticated protocol
	- trivial for on-pat attackers, or malicious resolver to forge replies ; because responded are not digitally signed
- two approaches to securing DNS, which are both required for fully secure DNS
	- Transport security
	- Record security

### Transport Security

Can we make requests and receive replies securely?

- make request over TLS (or other secure channel) , to a trusted resolver, providing encryption

### Record Security

Add form of digital signature to the responses, so tat the client can verify authenticity

 - each server in the hierarchy signs data
 - client can verify the chain of signatures all the way up to the root servers
 - implemented, but not widely used


## UDP

- requests/responses are small, hence no reliability needed, fit into a single packet
	- TCP has a lot of overhead, if packet is lost just retransmit , no need to wait for the 3ACK. (+1RTT Vs +4RTT)
	- congestion control also not required, just set a timeout and retransmit
- DNS Message within UDP datagram
	- Question section 
		- list of domain names and requested record type
	- Answer section
		- list of domain names and record type
		- record data
		- TTL
	- Authority section
		- where the answer came from
		
TODO INSERT DIAGRAM
TODO INSERT EXAMPLE of dig tool

## TLS (DoT)

- provides security at the cost of speed and extra overhead
- DNS client opens TCP connection to the resolver
- TLS session is negotiated
- data is transmitted within that session (formatted exactly the same way as in the UDP datagram)

## HTTPS (DoH)

- more recent , less widely used alternative to DoT
- open HTTPs connection to resolver and send query over that connection using a GET or POST methods

TODO INSERT EXAMPLE OF REQUESTS

- HTTP response has `Content-Type : application/dns-message` but again the data is the same as in the UDP datagram

## QUIC (DoQ)

- even more recent, even less widely used , but work in progress to standardise it
- principle the same as running over TLS, but with reduced overhead

## Methods for DNS resolution Summary

- the contents of the query and response are identical in all cases
	- change how the query is delivered to the resolver and how the response is returned *not the content of the messages*
	- change security provided
- provide flexibility for the client to handle different resolvers

# Politics

- Choice of DNS resolver
- Intelectual property and the DNS
- what domains should exist
- who controls the DNS root

## Choice of DNS Resolver

How is the DNS resolver chosen?

- on connection uses DHCP to discover network settings and configs
  - tells host what DNS resolver to use for the network
  - it might use different resolvers for each network interface ( e.g. device connected over 4G and private Ethernet, the ethernet might show internal addresses not available publicly)
- possible to configure the DNS resolver manually (e.g. common google public DNS resolver `8.8.8.8`)

- typically is implemented as as a sytem-wide service
  - OS implements a DNS resolution service which is used by all services/applications
  - consistent mapping of names to addresses, regardless of each application emited the query, since it is always using the same resolver
- DoH changes this approach
  - JS web apps can perform DNS queries via HTTP websites
  - Each app may get different answers for the same query depending on the server, hence it's no longer easily possible to enforce policy bia the DNS

- As previously discussed in past lectures, there's a trade off between privacy and security. The ability of allowing applications to securely access arbitrary DNS servers allows bypassing of DNS filtering and monitoring and by letting applications choose trusted DNS servers, they can more easily avoid attacks. However, not filtering DNS responses means that network operators and law enforcement can not block access to malicious websites

- Restricting the choice of DNS resolver can be achived by
  - firewals : DoU and DoT , simply block access to TCP and UDP ports or use a IP address whitelist
  - DoH : difficult because the network cannot distinguish between DoH and regular HTTPS traffic, because traffic is encrypte, unless the DNS server IP address is known and it is exclusively used to handle DNS traffic
    -  government organisations and ISPs are concerned about the implications of DoH

## Intellectual Property
## What domains should exists

SEE SLIDES, not particularly interesting, non-technical discussion of legal implications of domain ownerhsip and creation

## Root Servers 

- mostly US based organisations
- filtering on a geographic basis?
- global DNS?

SEE Slides on questions to ponder for possible implications of this



