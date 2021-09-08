# Week 1 - Changing Internet


- highlight ways in which the network is changing
  - exhaustion of IPv3
  - increase to wireless mobility
  - increasing centralization
  - real-time increase and need for low-latency
  - new approaches to protocol design to prevent nework ossification


## Architectural Assumptions

- devices fixed location with small number of network interfaces that are uniquely addressable
- network and services decentralised
- best effort provides sufficient quality
- trusted and secure
- innovation can happen at the edges, network can provide simple packet forward service

## Assumption 1

- desirable property that every device is addressable bye every other device, which can act as both a client and server

- FAIL : because IPv4 insufficient addresses and devices became mobile
  - hosts share IP addresses with others using NAT 
  - SOLVE : IPv6 , but slow to deploy
  - SOLVE : v4/v6 connection racaing "happy eyebals"
  - SOLVE : NAT traversal for P2P , but slows apps, reliance on cloud services, encourages centralisation


## Establishing Connectivity in the modern internet

- In IPv4 many behind NAT, complicates connections \mymarginpar{see lec 2}

- P2P apps must perform complex process to discover net bindings
  - STUN, TURN and the ICE algorithm
  - requires a server with public IP address for binding discovery, to determine what type of translation is being performed and to derive a set of candidate addresses that can be used for P2P
  - the peers use the central server to exchange the candidate addresses , then use ICE to setup direct low-latecy P2P flows
  - Complex, slow and unreliable


## Increasing Mobility

- IP encodes location not devices
  - mobile devices complicate addressing
  - TCP connections must be re-established after each move
  - UDP packets must be redirected after each move
  - complex signalling and connection management if devices move frequently

## Hypergiants and Centralisation

- Internet topology is flattening, direct connections from "eyeball" networks to content providers - Google, Apple, Amazon, Akamai etc.

- Implications:
  - network neutrality
  - competition
  - innovation


## Supporting Real-Time Traffic

- Video streaming dominates internet traffic, growing 40% per year
- Also driving centralisation and direct CDN connections, because easier to manage quality
- Driving TCP congestion control \mymarginpar{see lec 4, 5}
  - Google's BBR algorithm 
  - TCP replacement QUIC

### Impact of COVID-19 

- accelerating changes
- residential networks saw >20% increase in traffic overnight at the start of lockdown

![](@attachment/Clipboard_2021-01-22-13-25-42.png)


- massive growth in video conferencing traffic , usage grew by approx x20
- flexible enough, but can we improve quality? \mymarginpar{see lect 6,7}

![](@attachment/Clipboard_2021-01-22-13-27-08.png)

## Pervasive monitoring and Trust in the network

- balancing the needs of law enforncement monitoring while preserving privacy and protecting agains attackers \mymarginpar{see lec 3,4,8,9}

## Innovation

- large system implies increasingly harder to change (e.g. slow transition v4 -> v6)
- NATs , firewalls and middleboxes make TCP hard to change, but serious attempts are being made tunnel UDP -> QUIC, but not clear that these will succeed
- must push against centralisation

## Summary 

In the rest of the course we'll look at how the existing protocols can evolve to address the following challenges

![](@attachment/Clipboard_2021-01-22-13-38-23.png)

