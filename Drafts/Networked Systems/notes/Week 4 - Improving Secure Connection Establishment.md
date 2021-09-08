# Week 4 - Improving Secure Connection Establishment

<div id="content">

# Limitations of TLS v1.3

- great success
- added new features and has good performance
- 1.3 security improvements:
  - removed support for older, less secure algorithms
  - removed support for hard to implement algos 
- 1.3 performance improvements to the initial handshake and 0-RTT mode

Still some limitations that are hard to fix:
- connection establishment is relatively slow
- " " leaks potentially sensitive metadata
- protocol is ossified due to middlebox interference

## Slow Connection Establishment

- It takes 2x RTT after connection establishment starts for the first payload to be sent
  - earliest response 3x RTT

### What's the impact of these RTTs?

- Web page ; avg 1.7MB fetched as 69 HTTP requests using 15 TCP connections
- 83% of those run over TLS
- not all can run on parallel -> a lot of time wasted waiting for handshakes

$$
\text{RTT measurements (ping times) from  residential site in Glasgow} \\ \ \\
\begin{array}{|c|c|}\hline \text { Destination } & \text { Average RTT (ms) } \\ \hline \text { London } & 72.5 \\ \hline \text { New York } & 153.3 \\ \hline \text { Los Angeles } & 221.2 \\ \hline \text { Sydney } & 381.2 \\ \hline \end{array}
$$

### Speeding up TLS connection setup

1. 0-RTT for known servers
2. Concurrent TCP and TLS handshake for all servers
  - unlikely due to required OS and firewall updates

### 0-RTT 

In order to adapt TLS so that it can establish connections to know servers faster it is important to understand 3 key things:

#### What is the role of the TLS handshake?

2 THINGS


- Uses PK cryptography to establish a session key which is then used to encrypt the data being sent over the connection using a symmetric encryption algo
  - `Hello`s used to exchange material from which the session key is derived (ECDHE key negotiation)
  - key is *ephemeral* , i.e generated and destroyed on each connection
  - *forward secrecy* : each connection has a unique key, so if the key is somehow leaked it doesn't help break the encryption of any other connections between the 2 endpoints
- Retrieve the server's certificate, allowing the client to authenticate the server (`ServerHello`)

![](@attachment/Clipboard_2021-02-15-21-11-07.png)

#### How to encrypt initial data?

The ECDHE algo requires information from the two endpoints to derive a session key, so it cannot be used before the handshake is completed. This is why TLS usually takes 1RTT to generate the session keys

0-RTT bypasses this requirement by reusing a *pre-shared* key agreed in a previous TLS session. The first time the two peers connect, the server sends two additional bits of information : the pre-shared key and the *session ticket*. The next time the client tries to reconnect, it sends the session ticket and data encrypted using the pre-shared key. The server then maps the ticket to the corresponding key in order to decrypt the data

![](@attachment/Clipboard_2021-02-15-21-18-39.png)

#### What are the potential risks?

1. No longer forward secret, because the use of a pre-shared key links two TLS connections
2. Subject to *replay attack*
  - if an attacker captures and replays the TCP segment with the `ClientHello`, `SessionTicket` and the data, that data will be accepted by the server again
  - the server will respond to the replay, trying to complete the handshake which might fail, but by then the data will have been accepted

**0-RTT data should always be idempotent to avoid the risk**

## Metadata Leakage

- TCP/IP headers are not encrypted
- When used with HTTPS `ClientHello` includes the `SNI` extension which provides the name of the site being requested, so that the server knows what PK to use in `ServerHello`. This is required to support shared hosing, with multiple websites on the one server, and since the goal is to select the server can't be encrypted with `PreSharedKey` since that's provided by the server

## Protocol Ossification

- Widely implemented but many poor quality implementations , e.g. some TLS serves fail if given unexpected version number; no attempts to use older versions

> REM approx 8% of servers failed when updating to 1.3

- Adapted to still signal 1.2, with an extra field signalling 1.3. Bad implementations ignore extra field, while others with support for 1.3 will use it to negotiate the version to be used

### Avoiding Ossification

Ossification happens when extension mechanisms, or allowed flexibility, are not used. For example, there was a 10y gap between 1.2 and 1.3, and whilst 1.2 supported extensions, such as version negotiation, there was no other version to choose from so a lot of devs did not make use of them or even took them into account when testing their implementations, releasing buggy code

In order to future-proof code, developers should follow **GREASE** , Generate Random Extensions and Sustain Extensibility:
- the protocol allow extensions, send (dummy) extensions
- the protocol allows different versions, negotiate different versions
- *"use it or lose it"* , i.e send even if there's no current need to send

# QUIC

QUIC aims to replace TLS 1.3:

- reducing latency by overlapping TLS and transport handshake
- avoid metadata leakage via pervasive encryption
- avoid ossification via systematic application of GREASE and encryption

## Overview

QUIC runs on UDP for ease of deployment and replaces most of TCP, completely subsumes TLS and adds some features to HTTP

- HTTP : stream multiplexing
- TLS : security
- TCP : reliability, ordering, congestion control

The main goals of QUIC are:
- to provide a better, more secure replacement for TCP
- to run HTTP more effectively

![](@attachment/Clipboard_2021-02-16-10-24-14.png)

QUIC saves 1 RTT; In normal mode it established a secure connection *as fast* as TCP and TLS can perform 0-RTT session resumption, without the limitations of session resumption. Furthermore, QUIC also supports 0-RTT

![](@attachment/Clipboard_2021-02-16-10-27-59.png)

QUIC allows applications to send and receive up to $2^62$ different streams in each direction in a single connection, e.g. when fetching a web page with multiple images these can be sent over multiple streams without each requiring a new connection to be set up

A connection comprises QUICK *packets* sent within UDP *datagrams*. Each packet starts with a *header* and contains one or more frames of data which are composed of data streams, acknowledgements or other control messages

## Headers

QUIC packets can be *long header* or *short header*

### Long Header

Long Header packets are used to establish QUIC connections. They all start with a common header, followed by a packet-type specific data

The 8-bit common header:
- first 2 bits set to 1 to indicate long header
- next 2 bits indicate long header type 
  - Initial - starts TLS handshake
  - 0-RTT - idempotent data sent with initial handshake
  - Handshake - completes connection establishment
  - Retry - used to force address validation
- last 4 bits are unused

The connection id allow connections to survive address changes, e.g. if a smartphone establishes a connection to a server and then moves out of range of Wi-Fi and switches to 4G its IP address will change which would cause a TCP connection to fail, whilst QUIC allows for automatic server reconnection

![](@attachment/Clipboard_2021-02-16-10-38-36.png)

### Short Header

Used once the connection has been established

![](@attachment/Clipboard_2021-02-16-10-48-56.png)

## Frames

There are many types of frames, which play the same role take in TCP by header fields :

- `CRYPTO` frames are used to carry TLS messages such as
the `ClientHello`, `ServerHello` etc.
- `STREAM` and `ACK` frames send data and acknowledgements
- Migration between two network interfaces is supported by
`PATH_CHALLENGE` and `PATH_RESPONSE` frames
- Other frames control progress of a QUIC connection

Compared to TCP, QUIC headers are limited in scope but *extensible* via frames, making it more flexible. For example, TCP sends sequence numbers and acknowledgements in the header while QUIC sends this information in `STREAM` and
`ACK` frame

## Connection Establishment

- **Handshake**
  - long header packets
  - conneciton estblishment
  - keys' negotiation
  - server authentication

QUIC improves on TCP and TLS performance by combining the connection establishment handshake and the TLS handshake into 1 RT

The client will first send an `Initial` packet equivalent to `SYN` which contains the TLS `ClientHello` within a `CRYPTO` frame

The server will then respond with its own `Initial` packet (`SYN ACK`) and frame (`ServerHello`) as well as with a `Handshake` packet which contains other connection setup information

The handshake is concluded by sending a 3rd packet , a UDP datagram, which also starts the data transfer. This datagram will include three different types of packets:
- `Initial` containing an `ACK` frame, acknowledging the server's initial packet
- `Handshake` containing a `CRUPTO` frame with TLS `Finished`
- `1-RTT` containing a `STREAM` frame which carries the initial data sent from the client to the server

![](@attachment/Clipboard_2021-02-16-11-08-54.png)

### Initial Packets

QUIC `Initial` packets play two main roles:
- Synchronise client and server state, similarly to TCP's `SYN` and `SYN+ACK` packets
- Contain a `CRYPTO` frame with TLS `ClientHello` or `Finished` 

![](@attachment/Clipboard_2021-02-16-11-38-46.png)

This packets can optionally carry a `Token` which can be used to prevent connection spoofing. If a server refuses an initial connection attempt, it can send a `Retry` packet containing the token. The client must then retry the connection, providing the token in its init packet

### Handshake Packets

Complete the TLS 1.3 exchange, i.e they include either the TLS `ServerHello` or `Finished` messages. In most cases the packet is sent in the same datagram as the `Initial` packet to reduce overhead, but if the combined packet is too big the packets may be split

### 0-RTT

Works similarly to TLS over TCP. The `Initial` packet sends the `CRYPTO` frame with a TLS hello with a `SessionTicket` alongside a QUIC `0-RTT` packet which contains a `STREAM` frame carrying idempotent data. The server will in turn respond by sending the data in 1-RTT (short header) packet along with its own init and handshake packets

![](@attachment/Clipboard_2021-02-16-11-46-16.png)


In summary , the performance advantage is brought by the fact that **QUIC combines the two handshakes into one** whilst TLS over TCP requires the two handshakes to happen sequentially

## Data Transfer

- **Data Transfer**
  - short header packets
  - sends data
  - sends acknowledgements

Each short header contains a `Packet Number` field which plays a similar tole to the sequence number in TCP segments. Unlike TCP though, QUICK packet numbers increase by one for each packet sent, counting the number of packets sent as opposed to the number of bytes. Instead of sending `ACK` number, QUIC uses `ACK` frames to indicate that a packet with a given number has been received. Another difference is that QUIC never retransmits packets, instead frames of lost packets are sent within new packets, with new packet numbers. Note that this means that QUIC can tell the difference between a delayed arrival of a packet and the retransmission, since they will have different packet numbers

The protected payload section of a short header packet contains encrypted QUIC frames (e.g `STREAM`, `ACK` frames)

### ACK Frames

Sent inside long and short header packets and indicate the sequence numbers of QUIC packets received, not frames

### STREAM Frames

Responsible for carrying the data. Contain:

- Stream ID
- Data offset
- Data length
- Data

QUIC provides multiple reliable byte streams within a single connection, so data for each stream is delivered reliably and in order (though order is not preserved between streams)

There are two ways to view QUIC streams:

1. Several parallel TCP connections, i.e. QUIC streams allow you to send multiple unframed byte streams sent within a single connection
2. Each QUIC stream frames a message and the connection is just a series of messages

## QUIC over UDP

As we've seen, QUIC runs over UDP rather than over IP. There are 2 reasons for this:

1. It eases end-system deployment in user-space applications. 
  This is because it is difficult to run applications directly over IP. The API existing protocols use to communicate with IP is hidden within the OS and it is usually undocumented and proprietary. Applications running over UDP are easy to build since they use the widely used and portable BSD sockets API

2. To work around protocol ossification due to middleboxes. Existing firewalls block anything other than TCP and UDP, so by running it inside UDP there's a chance that it will work, since for example, NATs can translate UDP headers without inspecting their content

## Ossification

In general, if a field in a protocol is visible to the network there will be a middlebox somewhere that relies on its presence. Hence, once a protocol has been widely deployed it is very hard to change. 

Currently, even though we can use TLS to encrypt a packet's contents, there is nothing stopping middleboxes from blocking and/or modifying them simply by inspecting TCP and UDP headers, or block IP packets because its contents are not TCP or UDP.

Honda et al. [^1] showed that TCP extensions were hard to deploy, by measuring how often firewalls and NATs block TCP packets that include standardised but rarely used extensions, and how often they block TCP packets that use non-standard extensions 

The standards community increasingly views ossification as a major problem, which makes it difficult to evolve network protocols to address new requirements, and which can eventually lead to the death of the system. Even though there are known solutions to existing problems, these can't be deployed

QUIC is a new design that wants to avoid ossification, starting with initial deployments. The goal was to design the protocol so as to make it nearly impossible for middleboxes to interfere with QUIC connections, i.e. a network can wither allow QUIC traffic or it can block it, but it can't expect or modify QUIC flows (except invariants). In order to achieve this, designers applied the following techniques:

- Published protocol invariants
- Pervasive encryption of transport headers
- GREASE

### QUIC Invariants

QUIC Invariants
: the properties that IETF has indicated will never change

These function as explicit guidance to middlebox designers, and include:

- Packets start with either a long or short header
  - the first bit of a long header is always 1
  - long headers will always include version number, destination, and source-connection IDs
  - the first bit of a short header is always 0
  - short headers will always include a destination connection ID
- Connections can arbitrarily switch between long and short header packets

### Pervasive Encryption

Everything except the invariant fields and the last 7-bits of the first byte is encrypted, which makes it impossible for middleboxes to inspect any part of a QUIC header after the connection identifiers. This is achieved by agreeing on an encryption key during connection establishment which is used to encrypt the packets. The connection establish packets are themselves encrypted by deriving keys from connection identifiers, this is ok because there is nothing secret in these packets

> REM QUIC provides no more security than TLS over TCP, but makes it expensive for middleboxes to read the handshake

### GREASE

Every field in a QUIC packet is either encrypted or has a value that is, at least sometimes, unpredictable. Connection identifiers, for example, are randomly chosen, and clients randomly try to negotiate new version numbers

The goal is that middleboxes can't make any assumptions about QUIC header values, by making nothing in the header to be predictable

## QUIC : Benefits & Costs

### Benefits

- speeds up connection establishment
- reduces risk of ossification
- supports multiple streams within a single connection

### Costs

- New, poorly documented and frequently buggy
- High CPU usage (stack not yet optimised like TCP)

> REM these drawbacks are not inherent to the protocol, but are rather due to its relative novelty. TCP has been around for 40 years, the first standardised version 1.0 of QUIC will only be released sometime this year 

</div>

[^1]: https://doi.org/10.1145/2068816.2068834