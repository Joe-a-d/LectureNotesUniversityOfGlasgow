# Week 6 - Latency

- Key factor limiting performance is latency
  - can be reduced at connection time (e.g. move from TCP to QUIC)
  - can be reduced when transferring data
    - impact of TCP congestion control
    - delay-based congestion control
    - impact of explicit congestion notification
    - impact of speed of light


# TCP Congestion Control Primer

- Principles
- Loss-based
  - TCP Reno
  - TCP Cubic
- Delay-based 
  - TCP Vegas
  - TCP BBR
- Explicit congestion notification
- QUICK Cubic or BBR

## Principles Overview

The idea behind congestion control is trying to find the fastest sending rate which matches the available network capacity. As the network capacity changes, the TCP sending rate should adapt to reflect this.

Van Jacobson presented 3 fundamental principles:
  - packet loss as a congestion signal : Internet is best-effort -> discards packets -> TCP treats the discard/loss of a packet as a signal of congestion
  - conservation of packets in flight : try to keep a constant flow
  - additive increase/multiplicative decrease : add slowly , reduce fast

Sally Floyd leading person in maintaing and improving on original practical implementations
  - robust IETF standards for TCP
  - embodies congestion control principles
  - extremely high performance

### Packet Loss as a Congestion Signal

- Data flows through Routers
- Routers perform routing and forwarding (enqueue)
- Packets are discarded if the queue in a router is full
- Congestion control uses this packet loss -> queue full as a congestion signal

### Conservation of Packets

We want to keep the flow of packets roughly constant : 1-out , 1-in

- Packet is sent
- ACKS are returned by the receiver
- Signal that there is a slot for a new packet : **ACK clocking** 
- Queues neither increase nor decrease in size

By timing the ack rate , the network can automatically reduce the sending rate if ack times increase, before queues fill up

### AIMD Algorithms

The TCP adapts by *starting slowly, and gradually increasing*

- Additive Increase
  - Add a small amount to the sending speed each time interval without a loss
  - For a window-based algo $w_i = w_{i-1} + \alpha$ each RTT, where $\alpha = 1$ typically
- Loss is spotted
- Multiplicative decrease
  - Multiply the sending window by some factor $\beta < 1$ each interval loss seen
  - For a window-based algo $w_i = w_{i-1} \times $\beta$ each RTT, where $\beta = \frac{1}{2}$ typically

Faster reduction than increase leads to fast recoveries and keeps the traffic moving


# Loss-based Control

Window Based Congestion Algorithm
: algorithm which maintains a sliding window on the data which is available to be sent over the network

The sliding window determines what ranges can be sent, and uses the AIMD approach to increase or reduce that window alongside slow start and congestion avoidance mechanisms. This gives approximately equal share of the bandwidth to each flow sharing a link

## Motivation : stop-and-wait

TCP is an ACK based protocol, however stop-and wait protocols perform poorly. 

- it takes time to send a packet (t)
- need to wait for ack packets (a)
- if one calculates the link utilisation time (which we want to maximise, ideally 1) $U = \frac{t}{a}$ then one finds that stop-and-wait protocols cause the link to be idle $99.9\%$ of the time, i.e. the time it takes to send the packet is insignificant in comparison to the response waiting time.

Sliding window protocols improve on this by sending multiple packets before stopping for acknowledgement

## Sliding Window 

Congestion Window
: the number of packets to be sent before an ack arrives

By using a congestion window link utilisation time is greatly improved. In the example below the congestion window is set to 6. Note how the first ACK is received when the 7th is being sent so the window can slide over to 7. If the window is sized correctly , each ack arrives *just in time* to release a new packet

Optimal size : bandwidth X delay , though neither is known to the sender. Bandwidth in a large shared network is not possible to calculate, and the delay can only be calculated after the sending has started. 
So this poses a problem to properly implement ACK this ACK clocking.

![](@attachment/Clipboard_2021-05-11-16-11-54.png)

## TCP Reno

TCP Reno is optimised for not having information to know the correct window size. 
The two main problems it tries to solve are:
 - picking the initial window size
 - adapting the initial size to respond to changes in the network capacity

### Choosing the Window

- Set $W_{i} = 1$ , send 1 packet per RTT to start measuring path capacity (pessimistically safe approach)
- Set $W_{i} = 3$ , typical TCP Reno approach (usually safe)
- Set $W_{i} = 10$ , determined in 2010 to be safe for network speeds of the time

### Finding Path Capacity - Slow Start

- Start very slow
- Double window with each RTT until a packet is lost
- Half window (enter congestion avoidance phase)

### Finding Path Capacity - Congestion Avoidance

The congestion window is now approx the right size, so increase more cautiously (AIMD). The goal now is to adapt to changes in network capacity

- If a complete window of packets is sent without loss , increase linearly $W_i = W{i_1} + 1$
- If loss is detected via triple ack, decrease by half $W_i = W{i_1} \times 0.5$
- If loss is detected via timeout, reset to $W_{\text{init}}$
  - timeout : $\mathrm{T}_{\mathrm{rto}}=\max (1 \text { second, average } \mathrm{RTT}+(4 \times \text { RTT variance }))$

![](@attachment/Clipboard_2021-05-11-16-29-27.png)

> REM this sawtooth pattern is characteristic of a TCP connection

## Window Growth, Buffering, Throughput

The received rate is constant at approximately bottleneck bandwidth. The packets are being queued up at the link, and as the queue fills there are more and more packets queued up, and when TCP reduces the window, the queue drains but is never really empty. So whilst the sender follows the saw tooth pattern, the receiver receives constantly.

![](@attachment/Clipboard_2021-05-11-16-41-40.png)

## Summary

TCP Reno is strongest at keeping bottleneck link fully utilised. It trades delay (introduced by packets queued in buffer) by constant throughput.

Limitations 
  - assumes that packet loss is due to congestion ; not always true ; e.g performs suboptimally in wireless networks, when packet loss -> corruption
  - congestion avoidance phase takes a long time to use increased capacity

## TCP Cubic

- Modern
- Improvement on TCP Reno, in particular for fast long-distance networks
- Recovering from a packet loss during congestion avoidance can take a seriously significant amount of time

The idea behind TCP Cubic is to increase the congestion window faster than TCP Reno on fast long-distance networks, then slow down once the window approaches the largest successfully achieved window.

![](@attachment/Clipboard_2021-05-11-17-08-01.png)

### Algorithm

- On packet loss
  - window reduced by approx 1/3 (x0.7) instead of 1/2
- After packet loss
  - Increase (high-level): $W_{\text {cubic }}=C(t-K)^{3}+W_{\max }$
    - Wmax - last window reached
    - t - time since packet loss
    - K - time it will take to increase back to Wmax
    - C = 0.4 , constant that controls fairness to Reno
  - Other details exist to ensure fairness with TCP Reno on slower, shorter-RTT networks

# Delay-based Congestion Control

- Both TCP Reno and TCP cubic aim to fill the network, trading latency (packets waiting in queues) by throughput. 
- Both use packet loss as congestion signal
- If given enough data to send, the queues will overflow

## TCP Vegas - Reducing Latency

The main idea behind Vegas is to tweak the congestion avoidance phase and reduce latency by watching for the increase in delay as the queue starts to fill up, which allows the sender to slow down *before* the queue overflows. This in turn leads to smaller queues and lower latency , and no need for retransmission since packets are not lost

### Algorithm

1. Measure BaseRTT
1. Calculate ExpectedRate
1. Measure ActualRate

See slides

**TCP BBR** is an attempt at developing an algorithm which plays nicely with loss-based algorithms , and is an active research area. BBRv1 seems not to work very well, being incredibly unfair to regular TCP traffic, it greatly increases packet loss in Reno and Cubic flows. BBRv2 is an active research area


# Explicit Congestion Notification (ECN)

TCP infers congestion through measurement, ECN is an IP header to tell TCP to slow down.

- Sender sets ECN bits on transmission to signal whether ECN is supported
- Congested router sets ECN bits to 11 to send a congestion signal

## ECN and TCP

- receiver may get a TCP segment within an IP packet marked `ECN Congestion Experienced (ECN-CE)`
- `ECN Echo (ECE)` field in TCP header allos it to signal this back to the sender
- Sender reduces congestion window on receipt of ACK wih `ECE = 1`, *as if the packet has been lost* , hence TCP algorithm agnostic, leaves congestion phase implementation to protocols in place
- The sender will then set `CWR = 1` in the next packet to inform network and receiver it has reduced the window

ECN lets TCP react to congestion before packet loss occurs in a TCP congestion control algorithm agnostic way, leading to smaller queues , i.e. reduced latency without the cost of reduced throughput. 

# Impact of Propagation Delay - Light Speed

Two factors impact latency for data transfer
  - the time packets spend in queues within the network
  - the time packets spend propagating down the links between routers (content of this section's discussion)

## Reducing Propagation Delay

- make the link shorter 
- choose a medium where light transfers faster 
  - SpaceX Starlink using low earth orbit comms satellites, because faster in vacuum ; reducing latency by approx 1/2