# Week 5 - Reliability and Data Transfer

<div id="context">

# Packet Loss in the Internet

A crucial *feature* of the Internet is its unreliability were IP packets can be lost, delayed, reordered or corrupted in transit. 

- mention examples of reasons to why, and how packet loss depends on them:
 - on type of link ; wireless more noisy - more likely
 - protocols 


## End-to-End Argument

- only put functionality that is absolutely necessary in the network, everything else lives at the endpoints
- example : best effort instead of detecting and retransmitting lost packets ; end systems check for packet lost ; since 100% reliability can never be guaranteed, no need to perform checks within the network

## Timeliness Vs Reliability Trade-off

Different protocols exist to accommodate different applications which deem one factor to be more essential than the other, e.g. streaming video would favour timeliness whilst applications like email favour reliability. This has implications for network architecture, in particular the network/IP layer must be unreliable and timely whilst the transport layer above is responsible for reliability

![](@attachment/Clipboard_2021-04-25-06-29-36.png)

# UDP

- unreliable connectionless datagram

- adds only two features on top of the IP
  - ports numbers : determines the receiving app ; set by `bind()` once the socket has been created
  - checksum : checks that the package has not been corrupted; the receiver discards it before passing it to the app if it has been

- mostly UDP is used as a substrate on which higher layer protocols are built, e.g QUIC

## Overview
  - create socket
  - call bind, choose local port for listening to incoming connections
  - call recvfrom, to receive on that socket
  - call sendto, to send from that socket

> REM note how there is no need to setup a connection before sending datagrams, hence *connectionless*


![](@attachment/Clipboard_2021-04-25-06-39-44.png)

## SEND

  - sendto()
    - requires address and size
  - can send to multiple addresses using the same socket, hence address param always required

> REM if sending to the same address multiple times connect() followed by send() (which does not require address param) can be used, but note that there is still no connection being established. All connect does is set the destination address for future packets

## RECEIVE

  - recvfrom()
    - records source address
  - recv() does not give return address ; not often used
  
## Framing and Reliability

- single UDP send generates a single datagram, which if delivered will require a single receiving call
- The syntax and semantics of the datagrams depends on the application layer protocol
running within UDP
- when designing a custom protocol on top of UDP the following [guidelines](https://tools.ietf.org/html/rfc8085) should be considered

### reliability

- the protocol built on top of UDP is the one responsible for correcting the order, detecting duplicates, and repairing loss if needed
  - e.g. , QUIC adds packet seq and ack frames, allows for ordering and retransmission
  - RTP supports ordering only 
  - KEY TAKEAWAY there is no requirement on the top protocol to implement reliability

### Framing

- applications are responsible for organising the data so it's useful if some datagrams are lost

#### case study : video conferencing
  - video is encoded using index (I) and predicted (P) frames 
    - I frames represent a full video pictures 
    - P frames represent the nearest previous I-frame , which rely on the fact that certain parts of the image are unlikely to change (e.g. background)
  - i-frames are sent only at regular intervals and in between send only p-frames since they are cheaper to send
  - this means that detection of corrupted i-frames is of greater importance, since they will affect several seconds and corrupt all frames in between, hence often this type of apps check if the missing packet contain an i or p frame and only retransmits i frame


  ![video_codec_frames](@attachment/Clipboard_2021-04-28-04-54-21.png)


# TCP

TCP is a *reliable, ordered, byte stream* delivery service *running over IP*

![](@attachment/Clipboard_2021-05-11-13-19-54.png)

## Reliability

Data can flow in either direction, but usually follows a *Request-Response pattern* regardless by using ACK for segments as they are received it always guaranteed that any lost data is retransmitted

## SEND

`send` function 
  - blocks until the data can be written
  - returns the amount of data that was actually sent or -1 on error
    - if not all is sent then the return value is compared against the original request and the unset data is buffered to be sent in another call

## RECIEVE

`recv` function
  - blocks until data available or connection closed
  - reads up to BUFLEN bytes
  - returns the amount of bytes read , or 0 if connection closed, or -1 on error
  
It's important to remember that all `recv` returns is the number of bytes read, it does not add a `NULL` terminating char, which can pose a security risk if handled as a string, since string functions will expect it. Misusing this string buffers can lead to a buffer overflow attack

### Framing

`recv()` does not frame the data , hence data must be parsed to know how much remains to be read

For example, when fetching an HTML page, one might hope to call `recv()` for each semantically distinct section (headers, body etc.) however this is not possible.

![](@attachment/Clipboard_2021-05-11-13-45-12.png)


## Segments and SEQ numbers

- `send()` enqueues the data for transmission , splitting the data into *segments* and placing each into a *TCP packet*

- TCP packets are sent in IP packets when allowed by *congestion control algorithms*

- During the handhsake the client sets an initial seq number chosen at random
- The first data packet has SEQ + 1
- Subsequent packets increase by the number of bytes sent

> REM : client and server use separate sequence number spaces

**NOTE** calls to `send()` don't map directly to TCP segments, i.e. there is no guarantee that one segment will be sent in a single call or that multiple segments are not sent within the same call

For example, *Nagle's algorithm* is a common practice to improve efficiency since it buffers the data until the packet is large enough to be sent (slower though this can be disabled if the `TCP_NODELAY` socket option is passed)

## ACK

- TCP segment acknowledges previously received segment by sending within the response packet the sequence number of the *next contiguous byte expected*

- To reduce overhead , it's also possible to use *delayed acknowledgments* where ACK packets are only sent with every second received packet , i.e. rcv 1,2 -> ack 3

### Loss detection

![](@attachment/Clipboard_2021-05-11-13-48-59.png)

- Lost packets are identified by retransmiting the same same ack packet until the expected seq number is received. If four consecutive ack with same seq are send that the packet with that seq number is flagged as lost and the data is retransmitted - *triple duplicate acknowledgment*
  - Why 3? Because packet delay leads to unordered recv, which might seem lost but is merely delayed, hence avoid retransmission of delayed packets. 3 was empiraclly determined to be the right threshold

## Head-of-line Blocking

- TCP *always* delivers data to the application in a contiguous, ordered, sequence. Hence, if ta packet is lost, calls to `recv()` are blocked. The unordered data is buffered in the OS until the lost packet is retransmitted and received, at which point the `recv()` is called to handle the buffered data

![](@attachment/Clipboard_2021-05-11-14-16-11.png)

- This necessarily increases the download time due to blocked recv and retransmission wait. This delay depends on relative RTT values and packet serialisation delay. For real time applications however, this is a significant problem and can cause significant delays. This is why it is common to buffer enough data to allow for smooth playback

![](@attachment/Clipboard_2021-05-11-14-21-21.png)


# QUIC

QUIC delivers *several* ordered reliable byte streams *within a single* connection. Order is preserve within a stream but not between them. You can think of each stream as if it was running multiple TCP connections in parallel, or as a sequence of messages to be sent where streams indicate message boundaries

## Packets and SEQ

Each packet has a seq number which tracks the number of packets sent (instead of bytes like in TCP). There are two seq numbers spaces, one for the initial handshake and other for the sending of data. 

Streams frames within a packet carry data and have a unique identifier and also indicate the length of the data and its offset, similarly to TCP seq numbers

$$\begin{array}{l}\text { Packet } 0 \\ \text { Stream \#1, bytes 0-1000 } \\ \text { Packet } 1 \\ \text { Stream \#1, bytes 1001-2000 } \\ \text { Packet } 2 \\ \text { Stream \#1, bytes 2001-2500 } \\ \text { Stream \#2, bytes 0-500 } \\ \text { Packet 3 } \\ \text { Stream \#1, bytes 2501-3000 } \\ \text { Stream \#2, bytes 501-1000 } \\ \text { Packet } 4 \\ \text { Stream \#1, bytes 3001-3500 } \\ \text { Stream \#2, bytes 1501-2000 }\end{array}$$

Recall that message boundaries in streams are not preserved, and similarly to TCP data can be buffered and compiled into one packet or split across multiple packets

## ACK

QUIC sends acknoledgments for each packet, it does not look at the contents of the streams within it. Hence, the *sender must recall what data from each stream was in each packet*

ACKS are sent as reverse path frames, instead of just a single header, which gives greater flexibility and extensibility. 

![](@attachment/Clipboard_2021-05-11-14-45-09.png)

ACK contain ranges, so a single ACK frame can indicate which packets were received within a range and which need to be retransmited. Similar to TCP SACK

## Retransmission and Loss Recovery

- QUIC never retransmits packets, instead it retransmits the lost data within a new packet, with a *new, unique* packet number

The other mechanisms behave the same way as in TCP

## Head-of-Line Blocking

Whether packet loss affects 1+ streams depends on how the sender chooses to distribute stream data between packets , i.e if they alternate between single streams or mix streams. This choice will affect how each stream suffers from HoLB, since if data is lost within a stream that stream will block waiting for retransmission but others continue to deliver data. This is an important point to consider when deciding what to prioritise (e.g. prioritise single streams , or spread the risk across similar to torrents) and careful use of streams can limit the duration of HoLB

## Reliability

- Streams as parallel TCP connections : open 1 QUIC connection and send multiple streams within it

- Streams as a framing device : each stream represents a single object, where end-of-stream signals the object is complete

Recall that order is preserved within but not between different streams

![](@attachment/Clipboard_2021-05-11-15-09-16.png)




</div>