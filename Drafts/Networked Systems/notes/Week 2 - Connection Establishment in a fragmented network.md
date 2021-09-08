# Week 2 - Connection Establishment in a fragmented network

![](@attachment/Clipboard_2021-01-22-15-37-44.png)


## TCP - Programming Model

- client-server protocol
  - the way code is written depending on which one you're modelling

SERVER
1. create socket
2. bind socket
3. listen for incoming connections
4. accept incoming connections, only returns when conneciton is established
5. send & recv
6. close , server goes back to 4

CLIENT
1. create socket
2. call connect, return connection or unavailable server
3. send & recv
4. close

ADD details from labs_intro slides

![](@attachment/Clipboard_2021-01-22-15-51-02.png)

## Client-Server Connections

- how does client-server connection establishment actually work? 
  - what impacts it?

### 3-Way Handshake

- the server calls `accept()` and waits
- the `connect()` call triggers the handshake

  - CLIENT
    - The client sends the first packet, since it's the first packet from itself it sets the `SYN` bit in the TCP header
    - It also includes a randomly chosen `SEQ` number
  - SERVER `SYN-ACK` packet
    - Sets `SYN`
    - random `SEQ`
    - also `ACK` number which signals that the client's packet was received. by convention `ACK = SEQ_C + 1`
  - CLIENT
    - set `ACK`
    - set `SEQ` = `ACK_S`

- Client considers connection established, the `accept()` function returns a file descriptor which the server can use to access the new connection. The server considers the connection open

![](@attachment/Clipboard_2021-01-22-15-56-54.png)


### Sending Data

- typically the client sends data immediately after, but there is no requirement that the client sends first

- for short flows the handshake takes a significant fraction of connection lifetime
  - it takes a certain amount of time *ROUND-TRIP TIME* to send a minimal size request from the server and get a minimal size response. Larger responses add to this because of larger data size and its serialization

EXAMPLE

- ASSUME:
  - 1 HTML File @ server 1
  - 1 CSS File @ server 1
  - 1 Image @ server 2
  - Everything retrieved via HTTP over TCP/IP


How long does fetching a web page takes?

1. RTT handshake to connect to server 1
2. RTT + serialisation time to fetch HTML file
3. In parallel , hence the longest of:
  - RTT + serialisation time to fetch CSS
  and
  - RTT handshake to server 2 (initial client connection is reused here)
  - RTT + serialisation time to fetch image


![](@attachment/Clipboard_2021-01-22-16-18-42.png)


Hence, the following two factors affect performance

- RTT depends on the distance between the client and the server
- Serialization time depends on the avilable capacity of the network

**Latency** hurst performance:
  - cnnection establishment is slower 
  - retrieving data takes longer

  ![](@attachment/Clipboard_2021-01-22-16-26-53.png)

  Note how there is a diminishing return on bandwith as RTT increases. Note that increasing bandwidth by the same factor 10x from 100Mbps to 1Gbps gives very different gains, there's a 68% difference in performance between the best RTT of 1ms and the worst of 300ms 

  Hence, unless one is downloading very large files, the RTT is the limiting factor. For typical pages improving the link 10x only speeds up download times 2x

  What does this mean for protocols?

  - *"chatty"* protocols perform worse, since they involve many RTs

  EXAMPLE
  - HTML vs SMTP (email)
    - HTML requires a single request-response exchange 
    - SMTP requires a line-by-line request and response


![](@attachment/Clipboard_2021-01-22-16-36-01.png)

![](@attachment/Clipboard_2021-01-22-16-36-38.png)



## Performance Implications of adding TLS to TCP

- tls allows client-server to agree on encryption key

- HTTPS
  - same as HTTP but with TLS Handshake
  - adds one aditional RTT (TLS 1.3)


![](@attachment/Clipboard_2021-01-31-00-56-32.png)

- what's the impact of TLS on performance then?

![](@attachment/Clipboard_2021-01-31-00-57-34.png)

- RTT is often the most significant factor
- 1.3 (2018) is the best protocol since it only requires one aditional RTT , half of 1.2. (one to establish http connection and one to establish security )

## Impact of transition to IPv6

- we have 2 internets, so how to establish connections during the transition?
  - returns a list of possible addresses , then loop through until a first is found which is able to connect

PROBLEM : Slow

SOLUTION : *Happy Eyeballs*

- perform a DNS lookup for both 4,6 **in parallel**
  - start whichever connects first
  - call connect() for that address, if not connected within 100ms repeat using the next on the list alternating between 4 and 6

- balances speed to connect vs network overload

![](@attachment/Clipboard_2021-01-31-01-08-16.png)

## P2P

- conceptually the internet was designed so that , in principle, every device can act as client and a server.

- In practice P2P is difficult due to **NAT**

## NAT

- the process by which several devices can share a single public IP

- hosts form a private internal network

-  PRIVATE <-> NAT <-> PUBLIC

### HOW?

ISP Network range 

203.0.113.0/24

REM 
: what's /24:

  An IPv4 address is composed of 32 bits.

  /24 means that the first 24 bits define the network. So you have the remaining 8 bits for the hosts.

  2^8 =256 addresses, as the first one defines the network and the last one is the broadcast, you have 254 effective addresses.



1. Without NAT - Single Host

- host sends src = host ip and dest = server ip
- the server does the reverse

- the packets remain unchanged

![](@attachment/Clipboard_2021-01-31-01-40-35.png)

2. Without NAT - Multiple Host

- the host has now a router

- the ip effectively gives a chunk of its ip addresses to the customer and lets him handle how to assign the hosts in their internal network

- there is still no address translation, SRC/DEST addresses match the original

3. WITH NAT

- IP addresses are expensive
- NAT translator sits betwen ISP <-> Customer
  - nat translates the source address to match its own
  - it also rewrites the TCP/UDP port number to an unused port of itself
  - it keeps a map of the changes

  ![](@attachment/Clipboard_2021-01-31-01-52-07.png)

  ![](@attachment/Clipboard_2021-01-31-01-52-25.png)

### PROBLEMS

- break certain classes of application
- encourage centralisation
- designed for client-server apps

- NAT internal mapping requires packet forwarding from INTERNAL -> EXTERNAL. So when a packet arrives from the ISP network without a corresponging "client" packet having been sent by the host there is no mapping. Hence apps with **SERVER** behind NAT fail
  - can be manually configured, e.g. upnp
  - but complex, so most use cloud computing services to host server

- hard to write P2P, because incoming connections difficult and hosts behind NAT only know their private address. So can't give peer its address.
  - there are also solutions for this, but they are complicated, slow and wasteful
  - often easier to relay traffic via server hosted in a data center -> centralisation

### Why use it then?

- lack of IPv4 ; IPv4 expensive
- future proof; translate 4,6
  - ISP 6 only
  - customers translate 4-6 when leave private
  - ISP -> Internet 6 or 4
- avoid renumbering
  - applications often hard-code IP addresses rather than using DNS (BAD)
  
### Implications of NAT for TCP

- recall outgoing connections create state , i.e. mapping

- it listens for TCP handshakes and infers that a TCP connection should be establishing, so chooses the appropriate translation state
  - it needs to send data periodically, or NAT will think FAIL
  - setup time out interval to `keep-alive`, recommended 2h but often much less is used

### Implications of NAT for UDP

- UDP has no notion of connection, so even though the NAT can just listen to see when a UDP packet is sent out and adjust its translation state appropriately, it can't tell when the connection is over so that the state can be reversed.
  - use timeouts , recommended keep-alive 15s
  - generates unnecessary traffic
  

## P2P NAT TRAVERSAL

- assume A,B share same private IP address, such that sender can't send directly to receiver address

1. **binding discovery** use server in the internet to discover NAT bindings

2. exchange candidate addresses with peer via the referral server

![](@attachment/Clipboard_2021-01-31-03-29-52.png)

### Binding Discovery  






