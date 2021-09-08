# Week 1 - Protocols Review

<div id="content">

Networked System
: a cooperating set of autonomous computing devices that exchange data to perform some application goal

Each device within the network acts independently and require different things from the network which of course introduces some complexity when trying to design and understand networks.

There are 4 aspects to the network:
- **Communication** : how can two devices connected by a single link reliably exchange data?
- **Networking** : how can links be combined to form a *wide-area network (WAN)*?
- **Internetworking** : how can we connect multiple networks together to form an internet such that they act as a single global network? How can data be routed across it?
- **Transport** :  how do the end-systems ensure that the data is exchanged across the network reliably so that the meets of the applications are met?

## Communication Protocols

Network systems are fundamentally about communication protocols. A *sender* communicates with a *receiver* via some communication channel which is not infinetely fast or perfectly reliable, hence the messages must be able to endure the channel *constraints*.

Much like programming languages, protocols have well-defined syntax and semantics which define a certain protocol. These can be combined to raise the level of *abstraction* in order to provide more sophistaced services to applications

## OSI Model

The OSI model is a standard model of layered protocol design but real networks don't follow this model. They are more complex and the boundaries between them are blurred, particularly in the higher layers. For example, VPNs take network layer data in the form of IP packets and *tunnel* them inside a transport layer to some other part of the network, giving the illusion that the device is connected elsewhere


![](@attachment/Clipboard_2021-01-14-11-05-55.png)


## Physical Layer

Physical Layer
: enables communication by transmission of a raw bitstream. DU : Bits


### Encoding 

When using a wired link the signal is directly encoded onto the channel by varying some property of the channel (voltage/light intensity).

Bandwidth
: the frequency range occupied by the signal (Hz), corresponding to the complexity and information of the signal, i.e more information -> greater bandwidth

Baseband Frequency Range
: the range of the signal strength from [0-Max] Hz

Every channel has a maximum bandwidth depending on its characteristics (e.g cable length) and the signal can only be transmitted if its maximum bandwidth is less than that of the channel. 

Nyquist's Theorem
: The maximum rate at which a signal can be transmitted, which is only reached in a noise-free channel. If $B,V$ represent the bandwidth of the  channel and the number of discrete values per symbol being transmitted, then $$R_\text{max} \leq 2B \log_2 V$$

> REM note that for binary data $V = \{0,1\}$, hence $R_\text{max} \leq 2B$

### Baseband Data Encoding


![](@attachment/Clipboard_2021-01-14-11-22-41.png)

Simple, but problematic for long runs of same values sent, since it is easy to miscount the bits

![](@attachment/Clipboard_2021-01-14-11-23-16.png)

Encodes the signal using a *pair* of values:
- 1 : high-low transition
- 2 : low-high transition

This avoids the miscounting problem, but requires double the bandwidth because we encode a transition on every bit

### Carrier Modulation

Carrier modulation is used to encode signals onto a wireless channel, which allow for multiple signals to be encoded onto the same channel using different frequencies. CM works by shifting the frequency range while maintaining its baseband. 

![](@attachment/Clipboard_2021-01-14-11-43-26.png)

**Types of Modulation**
1. **Amplitude** : simple but easily corruptible
2. **Frequency** : more resistent to noise
3. **Phase** : more resistent to noise

![](@attachment/Clipboard_2021-01-14-11-49-08.png)

> REM Modulation schemes are often combined

### Spread Spectrum Communication

Single frequency channels are prone to interference, so in order to deal with this problem the carrier frequency is repeatedly changed many times per second by using a pseudo-random sequence generator know to both the carrier and the sender. At each time slot a random sequence chooses which carrier frequency to use. (e.g. 802.11b Wi-Fi uses frequencies centered at either 2.4GHz or 5 GHz)

### Shannon-Hartley Theorem

The impacts of noise on the data rate of a channel can be predicted. In the simplest case where it's assumed that the noise affects all frequencies by the same extent, the *maximum* data rate is given by the *Shannon-Hartley Theorem*.

Shannon-Hartley Theorem
: Take $B,\ S,\ N$ to represent the bandwidth of the channel, the signal the noise strengths respectively. Then, $$R_\text{max} = B\log_2(1+\frac{S}{N})$$


## Data Layer

The DL starts to provide meaning to the bits by structuring them, it provides:

- Framing
- Addressing 
- Media Access Control

Data Link Layer:
: responsible for mediating access to physical layer and structuring the raw bitsream. DU : Frames

### Framing \& Addressing

Frames are essentially fenced packets, which signal to the next layer the significant part of the data , i.e the *payload* and often whether that data was corrupted via some sort of error code or checksum

> EXAMPLE Ethernet Frame Format

![](@attachment/Clipboard_2021-01-14-12-13-08.png)


### MAC

MAC is needed to determine which machine gets access to the channel when
multiple hosts try to access it simultaneously. Because if that happens then the signals are said to *collide* and will overlap, resulting in an unreadable message.

**CSMA** listens to the channel before sending, if it hears no traffic then it
starts transmitting. Note however, that if the message takes time to reach
the node , i.e. if there’s a *high propagation delay* then there is an increased probability of a collision occurring mid-transit, an improved algorithm is **CSMA/CD** where the sending node keeps listening even during sending, if a collision occurs then both stations cease transmission immediately. This is an improvement because even though the frames are still
corrupted, it saves time and bandwidth by reducing the time the channel is blocked due to collisions.

> REM the wait time should be random to avoid deterministic repeated collisions and increase with number of collisions


## Network Layer - IP

The network layer allows several independently operated networks to be combined, by providing an inter-networking function that allow us to buil an *internet*, hence giving the appearance of a single network.

Network Layer
: provides end-to-end delivery of data. PUD: packets

The use of a common network layer protocol allows us to decouple the operation of the networks from the applications. It doesn't matter how the bottom layers were implemented (e.g. wi-fi, fibre etc) because the information passed onto the top layer is mediated by a single common protocol - IP. \mymarginpar{the same applies for top-bottom data} The generality of this approach does of course mean that there is no room for optimization traffic for any particular use case

The IP provides:
- simple, best effort, *connectionless* packet delivery service
- addressing 
- routing (end-to-end)
- fragmentation and reassembly of packets

### IPVv \& IPv6

The figures below show a packet being sent in the payload data of a data link layer packet. The packets are sent left-right , top-bottom.

The major motivation for the creation of IPv6 is that the Source and Destination addresses are only 32b which are not enough for the current internet.

\mymarginpar{see [here](https://packetpushers.net/ip-fragmentation-in-detail/) for the function each frame}

IPv6 not only increases the number of available addresses but it also simplifies the header. It removes the support for in-network fragmentation and instead requires the hosts to adjust the size of the packets being sent , and it also removes the checksum since it is usually redundant.


![](@attachment/Clipboard_2021-01-14-14-46-41.png)

### Addressing

Addresses encode location of a network interface, and since devices can have multiple interfaces it follows that they can have multiple addresses. Furthermore, a host can support both IPv4 and IPv6.


The structure of an IP address is comprised of the following:

Network - identifies the network
Host - particular attachment point within network

example IPV4 : 20 bits network , 12 bits host

during routing only look at network part, host only when destination reached

DNS resolves names, but part of applicaiton only

### Routing

AS - 

AS & Inter-domain routing

- each network manages itself, usually using dustance vector or link state algorithms for shortest path routing

- most internet trafic crosses AS borders

We can represent each AS network as a node in a graph

BGP is a routing protocol responsible for cooperation between AS
  - advertise prefixed of each AS allowed & disallowed

   
AS-level topology
  - edge networks can use default route, only need to adverstise their prefixes and customers, and use default route for all other trafic
  - core networks need full routing table (Default Free Zone)


### Forwarding

- Given routes established, how are packets actually forwarded?
  - best effort
  - connectionless , no asking, just send, o guarantees
  - time taken to transit the network may vary
  - undelivered packets are discarded


# Transport Layer

ADD FUNCTION

Transport isolates applications from the network
- demultiplexes traffic
- enhances network quality of service to offer appropriate reliability
- performs congestion control


## UDP
- user datagram protocol

- unreliable delivery service -> useful for apps that prefer timeliness over reliability, and as a building block for new protocols

- exposes raw IP service to applications, adding only the concept of a port number to identify multiple applications running on a single host

- connectionless , no cong control, no order guarantee

- applications VoIP , Streaming, Gaming ; because need low latency but can tolerate data loss 

![](@attachment/Clipboard_2021-01-21-17-52-29.png)


## TCP
- transmission control protocol

- reliable, retransmission, reordering -> reliable and as fast as possible

- connection oriented, apps must first set a connection between sender <-> receiver

- lost packets are retransmitted and ordering is preserved

- adapts sending rate

- sender writes a seq of bites into a tcp connection which is delivered to the receiver

- limitations:
1. message boundaries are not preserved . delivers a seq of bytes not messages , so even if the sender sends 2 messages of n bites each. There is no guarantee that the sender will receive it as 2 n bites messages. These can be split
2. delays data following lost packets. trade-off between latency and reliability

![](@attachment/Clipboard_2021-01-21-17-52-43.png)

TCP delivers data as segments within an IP packet 

![](@attachment/Clipboard_2021-01-21-17-57-17.png)

Ports : id apps

Seq : detects loss
Ack : checks seq

Checksum : packet corruption

a lot of information ; complex ;

### TCP connection stages

1. Initial 3-Way Handshake

- packet from sender with SYN set, which indicates the start of a connection
- receiver sends a packet with SYN set and ACK set to signal that the acknowledgement  number is valid
- sender completes the handshake by sending an ACK to receiver


2. Exchange Data 

- initial package seq=0 , each packet includes 1500b
- receiver replies with ack of expected packet seq number 
- if packet lost , receiver keeps sending ack (max 3)
- sender resends lost packet
- receiver sees a delay while missing data is retransmitted then receives a burst of data

3. Closing 3-Way Handshake

![](@attachment/Clipboard_2021-01-21-17-59-26.png)


congestion window
: mantained by the sender ; determines number of bytes that can be sent before an ack is needed

### Congestion Control

- algorithm which adapts its transmission rate to match the network capacity

STAGE 1 : SLOW START

- starts by sending slowly, but increases exponentially until net capacity met

STAGE 2 : CONGESTION AVOIDANCE

- sawtooth patteern ; allows to adjust rate to match changes in the network available capacity

# Higher Layer Protocols

Session, Presentation, Application

Blurry boundaries


Goal : support application needs by trnanslating those needs into protocol mechanisms
 - manage transport connections
 - name and locatte application-level resoruces
 - negotiate data formats and perform format conversion
 - present data in an appropriate manner
 - implement apllication-level semantics


## Session

- managing connections

- simple applications single client - server (e.g. HTTP)
  - little session layer support
- more complex multiple client server (e.g video calls)
  - finding participants and forwarding messages
- more sophisticated P2P (e.g bittorrent)
  - setting up connections in presence of firewall
  - rapidly adapt to changes in group participants

- multicast & broadcast
  - similar to P2P require group membership changes support

## Presentation

- manages presentation, representation and conversion of data
  - media types specification 
  - channel encodings , data adpated to fit comms channel (e.g email, attachments look like text, base64 encoding)
  -  internationalisation

## Application 

- protocol functions specific to application logic

## Financial & Political

- OSI model is accurate enough to be useful, but it's just a model. It misses two key layers
  - Political
  - Financial

- Networks are only useful if they allow communication between different hosts, which often means cooperaion between different vendors. Getting the political and financial incentives right is key for cooperation to happen which require the creation of standard protocols

- Protocol standards are the result of discussion between many engineers and are only implemented when a rough consensus is reached



</div>