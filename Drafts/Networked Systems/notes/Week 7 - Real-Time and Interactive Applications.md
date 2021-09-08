# Week 7 - Real-Time and Interactive Applications

Real-Time Applications (RTA) and the Internet
  - What
  - Requirements and Constrainsts
  - Quality-of-service and quality-of-experience

Interactive Applications (IA)
  - Conferencing app architectures
  - Signalling, session description, real-time media traffic

Streaming applicationns
  - HTTP adaptive streaming for video on demand

# Real-Time Applications

Real-Time Traffic
: traffic which must arrive at its destination beffore some deadline


Real-time applications are characterised by the fact that the system fails if data is not delivered by a certain time.

- No system can be engineered to be 100% reliable
- Deadlines can be absolute or relative
  - absolute : data must arrive before a certain time (e.g railway signalling)
  - reative : data must be delivered periodically, witin some time after te previous (e.g. smootg video playback)
- Not necessarily high performance , *predictabiltiy* favoured over high bandwith and low latency

# Requirements

## Streaming Requirements

- no absolute deadline, smooth favoured over immediacy. Latency is acceptable at the start whilst buffering
- Bit rate depends on desired quality . Trade-off between frame rate and frame quality
  - more predictable -> smoother motion -> lower resolution

## General

- RTAs need to be loss tolerant
- Limited Elasticity : RTA is inelastic
  - recall that congestion control adapts the speed of transmission to match network capacity , i.e. transfers are elastic
  - affects the way we send the data
  - RTA as a lower bound on acceptable bit-rate to preserve meaning/intelligibility (e.g. transmitting speech, video)
  - RTA as a upper bound on sending rate , capped by frame/sampling rate

### Quality of Service

- It is not always possible or required to reserve network capacity for RTT
- Adds complexity : requires signalling, authorisations and accoutning
  - raises questions about resource reservation implications : useful if the network does not have capacity , but Inter-domain 
  reservations and accounting can be difficult to agree and implement ; it also raises questions about privacy
  
### Quality of Experience

- Ultimately wat matters is *subjective* quality of experience , i.e. does it meet the user's needs
- How to measure tis varies depending on the task at hand , and often require user trials
  - technical metrics also exist (e.g. ITU-T E model for speech quality evaluation based on latency and packet loss)  

# Interactive Applications

DEFN

## Conferencing

DEFN

- e.g. Telepony, VOIP, Video COnferencing
- Long history of research and standardisation (modern standards since 90s)
- Browser-based conferencing from mid 2010s (webRTC)

## Interactivity Requirements

- interactive application determined by task and human perception
- Phone/Video conference : lip-sync essential to usability ; low latency
- Unidirectional (lecture style) : higher latency tolerated
- Speech data is ighly loss tolerant (loss concealement can hide 10-20% loss)
- Video ard to conceal (retransmission possible in some cases)

## Media Transmission Path

- INSERT SCREENSHOT

SENDER
1. Frames of media data are captured periodically and buffered
2. Codec compresseds media frames
3. Compressed frames are fragmented into packets
4.  - Transmistted using RTP insude UDP 
5.  - RTP adds sequencing, timing, source id and payload id (identifies the compression algorithm)
6.  Transmited

## Media Reception Path

- UDP packets are separated according to sender
- Channel coder repairs loss using forward error correction
- Playout buffer used to reconstruct order, smooth timing
- Media is decompressed, packet loss concealed, and clock skew corrected
- Render media

![](@attachment/Clipboard_2021-05-17-21-54-55.png)

## Media Transport : RTP

How do we actually get te audio and video data from te sender to the receiver, once it is captured and compressed?

- Runs within UDP
- Use RTP, composed of two parts
- Data Transfer Protocol : RTP - media payload formats 
	- whic describe how you take the output of eac compression algorithm and map it onto a set of packets to be transmitted ; it describes ow to split a frame of video/audio such tat each UDP packet which arrives can be independently decoded even if some are lost - *application level framing*
	- runs over TLS for encryption purposes
- Control Protocol : RTPC - extends
	- caller ID
	- retransmission requests
	- detailed user experience
	- congestion control
	
### Timing Recovery

- packets are send in epriodic intervals
- Queing delays in te network disrupt timing , playing te packets immediately upon arrival leads to gaps hence receiver buffers to smooth out variation
- TODO INSERT BUFFERING SOT SLIDE 1
- Tradeoff latency for smooth playback

### Application Level Framing

- receivers must make best use of packets wich arrive to compensate for losses
- By inserting te payload format into te RTP packet we can make sure that eac packet would be independently usable, i.e when a packet arrives it sould be independently decodable
- D.Clark and D.Tenneouse "Arcitectural considerations for a new generation of protocols" 1990 

### FEC vs Retransmission

- retransmission takes too long, given the small delay bounds inherent to IRApps discussed above,  *forward error correction (FED)* is often use instead
- FEC packets are sent along with te original data wich contain error correcting codes (e.g. XOR of the original packets), so that if original are lost but FEC arrive, original can be reconstructed

![](@attachment/Clipboard_2021-05-17-21-51-31.png)

## WebRTC Data Channel

- most video conferencing applications also provide a *peer-to-peer* data channel on top of audio-visual media
  - supports file transfer, chat session, comms interactive features (raise hand, emojis etc) 
- uses protocol SCTP over UDP , which makes it easy to build P2P applications with WebRTC. Chosen over QUIC simply because it predates it
  - message oriented abstraction
  - multiple sub-streams
  - congestion controlled

## Signalling and Session Descriptions

- Video conf apps run P2P for low latency
- *Signaling protocols* are required in order to find the peer and establish paths
- *Control protocol* responsible for communicating session details
  - media transport connections required
  - media formats and compression algos
  - IP addresses and ports
  - Source 
  - Options and params
- *Session Description Procol* , standard format to send this data

### SDP Offer/Answer

- Session descriptors negotiate interactive session following the *Offer/Answer* pattern
  - **Offer** : initiates communication by transmitting list of codecs, caller ID, options and addressing details
  - **Answer** : supllies addressing details, accepts call, subsets codecs and options which are mutually acceptable
  - ICE algo (see lec2) probes NAT bindings, establishing the path
  - Data flows

- SDP was originally designed as a one-way announcement format, hence has an insufficient structure in syntax, semantic overloading making it complex to use

- There are two main ways to use this pattern , depending on the system : 
  - Session Initiation Protocol (SIP)
  - WebRTC

### Control of Inteactive Conferencing : SIP

- used for telephony and video conferencing
- *Inderict signaling setup* : relies on a set of conferencing servers, each representing a caller and sender 
- SIP messages sent via servers passing the essential metadata required and negotiating session via SDP
- Responder is alerted, NAT bindings are established and media flows when call is accepted using a *direct P2P* path using ICE

![](@attachment/Clipboard_2021-05-17-21-40-19.png)

### Browser-based Conferencing : WebRTC

- modern system designed to integrate video conferencing into web browsers and web apps
- main difference is that it uses a single server as intermediary (e.g. zoom owned server)
- implemented in web browsers exposing *standard* JS API
- messages are delivered via HTTP
  - session negotiation still uses SDP
- media transport uses RTP, equivalent to SIP
- P2P channel is created

![](@attachment/Clipboard_2021-05-17-21-40-42.png)
![](@attachment/Clipboard_2021-05-17-21-47-49.png)

## Streaming

- RTP used to be used (alongisde control protocol RTSP) , nowadays most use HTTPS
  - performance is much worse, very high laterncy
  - done so that it integrates bettewe with CDNs

### HTTP CDNs

- service that provides a global set of web caches and proxies, used to distribute the web content of a web app
  - highly effective for delivering and caching content, chooses server geographically closer to request
  - global deployment : agreements with most ISPs to host caches near edge of network, hence clients are always nearby caches
  - only works with HTTP-based content
- major players : akamai, cloudfare, fastly

### HTTP Adaptive Streaming - MPEG DASH

- streaming video is delivered over HTTPs *from* a CDN node
- content is encoded in multiple chunks (approx 10s)
  - each made available in many different versions at different encoding rates
- a manifest file provides an index of available chunks
- clients fetch manifest, download chunks in turn. Standard HTTPs with a twist, they monitor download rate and can choose which encoding rate to fetch next - *adaptive bitrate*

### DASH and Congestion Control

- the DASH rate adaption and the TCP congestion control work at different time scales
  - TCP adjusts window once per RTT
  - DASH measures avg download speed of TCP connection over approx 10s (i.e on a per chunk basis) in order to choose next chunk

- videos played using DASH often have relatively poor quality for first few seconds since conservative download rate is chosen to start, and once connection download speed is chosen that's adapted

### DASH Latency

- takes a long time for streaming video to get started due to
  - chunk duration is key, since each chunk must be downloaded and decompressed before playout can occur
    - there is no packet loss, the latency equals chunk duration
  - playout buffering
  - encoding delays for live streaming

### Sources of latency - TCP

- packets losses delay download of the chunk
  - 4x packet transmission latency (lost + 3 duplicate ACKs)
  - 1x RTT for retransmission
- window is reduced

### Sources of latency - Chunks and Video

- recall chunks are independently decodable
- recall video compression is based on prediction (I/P frames)
  - I frames big, and how often these are sent will affect sending rate
- Trade-off between chunk size and compression overhead
  - overheads become excessive for chunk duration <= 2s


### Future

- improving on high latency 
  - possibly using WebRTC
    - might encourage CDNs to support RTP
  - possibly using QUIC
    - HTTP/3 delivers requests over QUIC
    - YouTube already delivers video this way
