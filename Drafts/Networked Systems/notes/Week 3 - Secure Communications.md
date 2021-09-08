# Week 3 - Secure Communications

<div id="content">

# The Need for Secure Communications

We'll focus on the following 4 broad topics (see subsection)

1/2 It is possible to monitor traffic by wiretapping the network links and/or modify routers so that they save a copy of the packets which they forward

3. It is also possible for routers to corrupt packets being forwarded, though this cannot be stopped by the sender, an integrity message (e.g. digital signature) can be added so that the receiver can check its authenticity

4. Middleboxes which modify messages to improve comms (e.g. NATs, Firewalls) which can lead to network ossification. Security protocols also play a role here by limiting the ability of these devices to act on packets and ensuring that the network can continue to evolve



## Network Traffic Monitoring & Privacy

People and organisations are often naughty, but there are genuine reasons for traffic monitoring. Problem: how to prevent malicious attackers and monitoring whilst not also preventing benign monitoring?

## Protecting Message Integrity

Organisations may want to change messages in transit, for example governments and law enforcement agencies may require ISPs to censor messages and/or modify DNS responses for a valid and morally unambiguous reason (e.g. child pornography). Again, the same techniques can be used by malicious third-parties

### Study Case - DNS-over-HTTPS

DoH is a recent development in network security which was designed to protect users against phishing attacks, by encrypting DNS traffics. However, ISPs intentionally spoof DNS responses to block websites hosting child pornography material, which meant that these kind of domains would now also be encrypted and therefore no longer be able to be blocked


## Preventing Protocol Ossification

Middleboxes must understand protocols used by the network traffic, e.g. NAT needs to know the format of an IP packet and where the ports are located in a UDP and TCP header. This means that the network becomes more complex, which in turn leads to protocol ossification since changing end-to-end protocols becomes very difficult due to the fact that middleboxes wouldn't be able to understand the changes

Encryption is one way to prevent ossification, since the more of a protocol that is encrypted the easier it is to change, since middleboxes cannot understand or modify the data. However, this also makes it harder for middleboxes so provide useful services

# Principles of Secure Communication

The goal of secure communication is that a message can be delivered from a sender to a receiver securely, avoiding:
- **eavesdropping** , by being encrypted
- **tampering**, by authenticating to ensure the message is not modified in transit
- **spoofing**, by validating the identity of the sender

## Ensuring Confidentiality

Recall that data traversing the network can be read by any device on the path, so in order to provide confidentiality we need to use encryption to make intercept data meaningless.

### Symmetric

Converts plain text into cipher-text , and vice-versa using a common *key*. 
The problem that arises is *how to securely distribute the key*?

- Very fast
- Public algorithms
- Advanced Encryption Standard (AES)


### Public Key Algorithms

Solution to the *"key distribution"* problem. The algorithms are also public, but in this case two keys are used. A *public key* can be widely distributed, but its corresponding *private key* is kept secret. If one key is used to encrypt, the other key is needed to decrypt the message

In order to encrypt the message, the sender looks up the receiver's public key and uses that to encrypt the message

- Very slow
- Diffie-Hellman
- Rivest-Shamir-Adleman (RSA)
- Elliptic curve-based 


### Hybrid

A combination of both public-key and symmetric cryptography for security and speed:

The keys are shared using public-key algos given that keys are small, speed is not a relevant factor here. Once the keys have been shared other comms can use symmetric cryptography

1. Sharing the key:
    1. Sender chooses a random value, $K_s$, that can be used as key for the symmetric encryption algorithm
    2. Sender looks up the receiver’s public key, $k_{\text{pub}}$, uses it to encrypt $K_s$, and sends the result to the receiver
    3. Receiver uses the corresponding private key, $K_{\text{priv}}$, to decrypt the message and retrieve $K_s$

2. Future messages are shared using symmetric cryptography with $K_s$

## Authenticating Messages

Authentication relies on both *public-key cryptography* and a *cryptographic hash* (e.g. SHA256 (recommended), MD5)

Cryptographic hash
: takes arbitrary input and produced a fixed length output hash

Fundamental properties:
- Any change to input generates different output
- Infeasible to find two inputs that give the same output
- Calculating the hash is fast
- Reversing a hash is infeasible

## Validating Identity

### Digital Signatures

Signature creation:

1. Calculate a hash for the message being sent
2. Encrypt the hash with the sender's own private key
3. Attach encrypted hash to message

Note that only the sender could have encrypted the message, but everyone can decrypt the message, guaranteeing authenticity but not privacy

Signature verification:

1. Receiver decrypts the message
2. Hash is calculated
3. Signature is decrypted using the sender's public key
4. If the calculated hash matches the one included with the message, then authentic

## Public Key Infrastructure

How can one map a PK to its owner?

1. In-person exchange
2. Exchanged via a trusted 3rd-party, i.e. the message is signed by someone whose key one already has
3. Someone of trust gives the receiver's key, usually the trusted party is a certificate authority


# TLS 1.3

TLS is used to encrypt and authenticate data carried **within** a TCP connection

>The primary goal of TLS is to provide a secure channel between two
communicating peers; the only requirement from the underlying
transport is a reliable, in-order data stream. Specifically, the
secure channel should provide the following properties:
>
>**Authentication**: The server side of the channel is always authenticated; the client side is optionally authenticated. Authentication can happen via asymmetric cryptography (e.g., RSA, the Elliptic Curve Digital Signature Algorithm (ECDSA), or the Edwards-Curve Digital Signature Algorithm (EdDSA) or a symmetric pre-shared key (PSK).
>
>**Confidentiality**: Data sent over the channel after establishment is only visible to the endpoints. TLS does not hide the length of the data it transmits, though endpoints are able to pad TLS records in order to obscure lengths and improve protection against traffic analysis techniques.
>
>**Integrity**: Data sent over the channel after establishment cannot be modified by attackers without detection.[^1]

## Overview

TLS is not a transport protocol in itself, so it relies on an underlying TCP connection in order to exchange data. Once the connection has been established TLS runs within it, and it consists of two main parts:

1. Handshake protocol : responsible for authenticating the communicating parties and agreeing on the encryptiong keys to use

2. Record protocol : uses the paramaters agreed upon in `1.` to protect the traffic between the peers. Furthermore, it turns the TCP byte stream into a series of records, providing framing delivering data block by block each of which are encrypted and authenticated.

## Handshake

The TLS handshake starts immediately after the initial TCP handshake

1. TLS `ClientHello` sent alongside `ACK`
2. TLS `ServerHello` send in response
3. TLS `Finished` message concludes and carries the first block of secured data

![](@attachment/Clipboard_2021-02-15-15-04-46.png)

> REM adds 1-RTT to connection establishment

### ClientHello

- Sent from the client to the server
- Indicates the TLS version to be used
- Provides the crypto algos the client supports
- Provides the name of the server to which the client is connecting
  - this is because it is common for web servers to host more than one website, so the server name specifies the site

### ServerHello

- Sent from the server in response to `ClientHello`
- Indicates the TLS version to be used
- Provides the crypto algo selected by the server, from the set the client suggested
- Provides the server's PK and signature used to verfy its identity

### Finished

- Sent from the client to the server
- Provides the client's PK
- Provides the certificate needed to authenticate the client to the server (optional)
- May contain data sent from client to the server

### Cryptographic Algorithms

Client and server use ECDHE key exchange algorithm. For our purposes the key aspect of the algorithm is that the symmetric key is never exchanged over the wire. Instead, the public keys are shared and the symmetric key is derived from those

Symmetric encryption algorithms are proposed by the client and chosen by the server (usually AES or ChaCha20)

## Record protocol

The record protocol allows for the exchange of records of data, which can contain up to $2^14b$ of data. TCP does not preserve record boundaries, so TLS is responsible for framing the records so that reading from a TLS connection will block until a complete record is received


## 0-RTT mode

Usually v1.3 takes 1-RTT to establish a connection, after the TCP connection setup. There's an initial SYN-ACK exchange and then an additional RT for the TLS `Hello`s. However, if the client and the server have previously communicated, TLS allows for re-use of the same encryption key. How?

- The server sends additional keys as part of `ServerHello` that the client can use the next time
- When the client next connects it can include encrypted data using the *pre-shared* key

Hence, data can be exchanged along with the initial connection setup handshake. However, TLS hello messages don't contain a sequence number, hence there is no protection against duplicate messages.

## Limitations

- Does not encrypt server name

- IP addresses and TCP port numbers are not protected, since TLS operates within TCP. Ultimately this means that information about who is communicating and what application is being used is exposed

- Relies on a PKI to validate PKs; There are significant concerns about the trustworthiness of the infrastructure

- 0-RTT duplicates


# Discussion - Issues to consider when developing applications using TLS 1.3

## End-to-End Principle

For communication to be secured it must be end-to-end, i.e. it must travel between sender-receiver without being decrypted along the path. There are various concerns to have when trying to satisfy this principle, even the seemingly simple task of identifying the final recipient can be difficult in today's internet. Take for example the case where data is sent to a data centre or CDN, and the multitude of possible attack vectors. If the data is moving between two users, should it be encrypted between the two users or between each user and the data centre?


Many applications use some form of *in-network* processing, e.g. videoconferencing systems often use a central server to mix the audio and scale the video to produce thumbnails. This central server receives and sends video from/to all participants and if an attack were to occur would mean that the data from all participants could be recorded and shared with un-trusted parties.

The choice of using a central server is not random, it is a trade-off between security and available bandwidth, and while for audio the bandwidth is small enough for this not to matter, for video the combined bandwidth may be significant. Furthermore, features such as cloud recording would be much more difficult to implement

## Postell's Law

Network protocols can be reasonably complex and difficult to implement. *Postel's Law*, named after John Postell, states that you should 

> *Be liberal in what you accept, and conservative in what you send*

and is often quoted when thinking about how to implement network protocols so that one is both able to reduce the amount of possible errors generated and handle incorrect protocol data.

Note however, that this only makes sense if one trusts the sender and if the errors are genuine mistakes and not malicious attacks. Today's network is a different beast however, as Poul-Henning Kamp puts it

> *"Postel lived on a network with all his friends.
We live on a network with all our enemies.
Postel was wrong for todays internet."*

See [^2] for more

## Validating Input Data

One of the key points made in [^2] is that networked applications work with data supplied by un-trusted third parties, which may not conform to protocol specs. Whether this is due to ignorance, bugs or malice developers must make sure that they carefully validate all data before use

## Writting Secure Code

Developers should *always* assume that their network applications will be deployed in a hostile environment, so they should:

- carefully specify behaviour with both correct and incorrect inputs
- carefully validate inputs and handle errors
- take extra care when using type and memory unsafe languages

> The best encryption doesn't help if the endpoints can be compromised


</div>

[^1]: E. Rescorla, “The Transport Layer Security (TLS) Protocol Version 1.3”,
IETF, August 2018, RFC 8446, https://tools.ietf.org/html/rfc8446
[^2]: https://tools.ietf.org/html/draft-iab-protocol-maintenance-04