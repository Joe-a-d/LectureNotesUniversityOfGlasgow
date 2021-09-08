# 20, 21 - Software Architecture

- We'll be looking at the software design and design patterns for whole systems

# Components

Component
: a physical manifestation of an object that has a well-defined interface and a set of implementations for the interface

- components represent a software bundle of *self contained* state and behaviours with well defined interfaces
- some can perform in isolation while others require information and/or functionality from other components. When this is the case we say that the system is *component-oriented*
- useful because they allow us to decouple the macro behaviour of the system without worrying about the individual objects
- e.g. reservation system : booking, payment, ticket issuing are all atomic behaviours which when combined allow the user to book a trip but some of the individual components can be used elsewhere (e.g. payment system) , while others are inherently linked to other components (e.g. issuing ticket requires feedback from payment component)

### Components vs Objects

- components are deployable entities as opposed to being compiled into an application they are installed directly on an execution platform, hence they can not be created and destroyed during the lifetime of the system.
- language agnostic. Objects are inherently linked to the syntax of the language, and their classes must follow the rules of a particular OOP language. components can even be used within other paradigms
- components are opaque, and can only be interacted with via their interfaces
- components are actual instances not ADTs which serve as templates
- components are standardised. 

> REM adapted from [Ian Sommervile, 2008](https://ifs.host.cs.st-andrews.ac.uk/Books/SE9/Web/CBSE/objects.html)

### Why use objects if loose coupling is good?

- opaque nature of components
  - require comms via middleware
  - extra comms are costly
  - middleware must : encode , transmite, decode
- maintenance system API costs
- hard to change interfaces without interfering with other parts of the system

- it's up to the components engineer of a project to decide which objects should be made components 

### General vs App Specific

- **General**
  - functionality common across different apps (e.g. card payment)
  - well documented and stored in a component repo
- **App**
  - specific to app's business logic (e.g. issuing company vouchers)
  - *"app glue"* - responsible for coordinating behaviour of general components so that app specific needs can be met

- *Glass , 2001* suggested that SE are good at building general components but bad at abstracting away app specific components to general ones (e.g. airline booking -> restaurant booking)

### Which functionality to expose? Atomicity vs Reusability

- packing too much
  - difficult to maintain and use, since lots of functionality will increase the likelihood of it being use by several systems. Higher risk of introducing breaking changes upon update
- packing too little
  - more comms needed since cooperation between a lot of components required
  - complex interactions

- Solution?
  - nest simpler components within more complex ones
    - some functionality of the component is therefore encapsulated within this *replaceable* sub-components

### Diagram Notation

![](@attachment/Clipboard_2021-07-03-15-57-21.png)
![](@attachment/Clipboard_2021-07-03-16-01-26.png)

- Boxes represent components
- the component (A) *providing* the interface (I) has a *facet* coming out of it
- the component (B) *requiring* the interface (I) has a *connector* coming out of it

> REM UML notation

- An interface in a component is more like a network port , it is an actual entity being consumed and *not a template* to be instantiated
  - **implication** if a component is denoted as exposing two interfaces of the same type, they will be different instances and have different endpoint addresses at run time

### Separation of Concerns - Design by Contract

- the interface definition is equivalent to a contract between the provider and the consumer
  - the provider guarantees some benefits offered via the interface
  - the consumer must abide oblige by the terms provide via the interface by the provider  


#### Drawing and checking the terms of the contract

The documentation for an interface can include

- visible component state
- invariants , describing the legal states of the providing component
- For each method in the interface:
 - A signature (identifiers, types etc)
 - Pre-conditions , describing the required state of the providing component before it can be invoked
 - Post-conditions , describing the state after completion
 - Semantics
 - The visibility of each method

- how the different parts of the contracts are expressed varies
  - e.g. below the formal notation `javax.validation` is used alongside informal notation

![](@attachment/Clipboard_2021-07-03-16-27-19.png)

- once specified , contracts can be checked:
  - statically at compile time
  - via tests
  - within program logic itself
  - by the component middleware at runtime

### Leaky abstractions

- whenever two components (provider, consumer) are wire together in an assembly, their future evolution is influenced by assumptions about the way the providing interface will be **used** and **realised**
- leakage goes both ways
  - the developer of the consumer wants more info about the implementation; sometimes the implementation details of the provider are not properly abstracted , leading to a leak. A disconnect between the interface provided and the actual implementation may lead to improper use of the interface by the consumer
  - on the other hand , the provider might itself be constrained by the underlying implementation when implementing the interface
- e.g. of where assumptions might be made
  - the ordering of objects received from an iterator over an unordered set
  - the behaviour and structure of a DB (assuming to know how queries will be evaluated)

- **Hence** , even though interfaces exist so that we can decouple the internal implementation from the outer consumption "modules" this does not always happen due to the semantics of a component's design becoming part of the interface itself.
  - the distinction between what the I provides and how is murky, because the how matters to the consumer

> REM : safe component composition is an area of active research

# Architectural Patterns/Styles

- often best represented as component diagrams due to system longevity 

### MVC

- separates the system into 3 main components
  - Model : represents the data, state of the application
  - View : present content via the UI
  - Control : manipulates the data and interacts with the UI ; initial entry point
- (usually) Both M and V belong to the UI
- often the View/Control components are coupled together

#### Adaptations

- MVC is an overview on how to organise the software system, but  is flexible enough that implementationd details vary
  - retention of some mode info in View (for almost static parts of the model)
  - View can be updated as a result of notifications from the model (bypass control; scheduling)
  - View and Control interact directly

![](@attachment/Clipboard_2021-07-03-17-06-24.png)

## Distributed Patterns

- **distributed pattern**
  - inspired by distributed systems developed alongside computing networks
    - characterised by different physical presences requiring standardised comms
  - **good when**
    - services provided by the system must be accessible from many different locations
    - too much info for a single machine too handle
    - requires software provided by different organisations

- **benefits of info storage and service provision**
  - easy to maintain (unnecessary duplication of data ; consistent organisation practices)
  - easy to access (single entry point)
  - changes to service functionality can be done in the server rather than in multiple clients

### Client-Server

- information and services are kept in a centralised server
- **server** 
  - provides access to clients via an API
  - ensures data integrity by validating requests
- **client**
  - polls server for information/service
  - presents response to user (people, other software components)

![](@attachment/Clipboard_2021-07-03-17-43-19.png)

#### Protocols, Sessions, APIs

- protocol : specifies how comms occur ; defines what a legal message looks like (API)
  - 2 interfaces
    - client side : init comms ; "hello server"
    - server side : main API ; defines what is legal ; "I speak X"
- session : represent state (as seen by server) for an entire connection from hello to goodbye ; handles behaviour ; 1 per client ; created after connection is established
  - multiple allowed

#### Case Study - Email

![](@attachment/Clipboard_2021-07-03-17-55-56.png)

- `EmailClient` represents a client app , e.g. Mail on macOS
- `EmailServer` represents the email provider server , e.g. Gmail
  - 2 functions implemented by subcomponents
  - Transport : client asks server to send email (IMAP)
  - Retrieval : client asks server to check for new email (SMTP)

### Client Size Trade-Offs

- Thin client
  - dumb client , very little program logic
  - most functionality lives on the server
  - client polls server and displays results
  - **but**
    - fully dependent on server ; server overload ; high latency

- Fat client
  - client is involves in info management, validation, processing and storage
  - reduces latency, since less server polls are needed
  - reduces computation costs on the server
  - **but**
    - not centralised problems (inconsistent data, harder to maintain)

- fat clients have become more popular as clients and caching techniques have improved

### Limitations

- latency
- single point of reference means that scalability is bounded by the physical resources (computational power, bandwidth, memory) available to the server , i.e. more clients -> more/bigger/more powerful server(s)
- single point of failure (backups reintroduce the inconsistent data issue)


### P2P

- introduced to improve on client-server by providing for greater scalability and redundancy
- services and data are moved into the clients
  - every peer is both a client and a server
- since all peers are responsible for hosting and management, adding one peer implies increased demand for resources but the peer itself will add resources to the system by acting as a server. Hence, the scalability problem is solved
- practical applications involve
  - distributed computing [^1]
  - hosting large amounts of data

#### Peer Discovery

- How to find trustworthy peers offering the required service/data?
  - globally known register (similar to DNS resolution)
  - search within the peer network
    - query a peer and cascade until resource is found (similar to network topology algos)
  - hybrid approach

![](@attachment/Clipboard_2021-07-03-18-35-20.png)

## Information Processing Patterns

- the goal is to address challenges of efficient information management within a system

- until now we have not concerned ourselves with how massages are passed between components, and just assumed that the middleware component handles it *synchronously* and *instantaneously* which is not always the case
  - comms channels may be unreliable , leading to interrupted flow of computation
  - client must choose where to get info before starting to compute
    - computation time is inherently dependent on number of requests made
  - cascade of inter-component request/responses lead to latency, even though some applications may note need responses the requests are done in a pre-determined manner (redundancy)
  - no parallel computations (idle time, redundancy)
- **I.E** sync comms can constrain design flexibility for certain types of computation

#### Study Case - Sync vs Async 

> Consider, for example a component developed to search for the best possible price for a home insurance premium, given some constraints (property value, contents value, minimum excess, whether the purchaser wants legal cover and so on). The component needs to contact a large number of insurance providers and request a quotation according to the specifications of the customer. The component will then select the top five quotations and present them to the customer for review

- **Sync**
  - Wait for each providers response before polling the next one
  - Waiting time is equal to the sum of all response/request times
  - must wait for unavailable provider responses
  - must complete each quote request in turn

![](@attachment/Clipboard_2021-07-03-19-04-39.png)

- **Async**
  - contact all providers without waiting for reply
  - return results once all requests are returned or after timeout

![](@attachment/Clipboard_2021-07-03-19-10-52.png)

### Message Oriented

- basis for inter-component async comms
  - messages are discrete elements passing through a mesage bus
  - bus routes messages following a *routing policy*

- *a.k.a (depending on which parts of the architecture are most significant for the design problem)*
  - message driven pattern because all the internal computation in a component is the result of receiving a message from another component
  - message broker pattern because a broker is responsible for deciding which component receives a message

![](@attachment/Clipboard_2021-07-03-19-18-01.png)

- IBroker : interface for client to send via the bus
- IQueue : interface for client to read from the bus
- MessageBus
  - Queues : message storage / buffer
  - Broker : redirects messages to appropriate client or drops it

#### Configuration

- MOAs can be configured by two mechanisms:
  1. the relationship between queues and clients 
    - having multiple clients connected to same queue
    - having a single client listen to different queues (e.g. error/normal messages)
  1. the policy applies by the broker to distributing messages
    - queues have a semantic meaning, so the broker will choose different queues depending on the type of the incoming message
    - other factors such as how busy each queue is, which client should handle it

#### Example - Stock Control System

- diagram illustrates the flow of stock between the
different geographical locations managed by the stock control system. The
supermarket chain has a large number of stores, each with a limited capacity for
holding stock

![](@attachment/Clipboard_2021-07-05-17-26-24.png)

- Each component has it’s own queue of messages maintained by the MessageBus. In
addition, each component can send a message to any other component via the
broker. In practice, only the following messages are required:
  -  Store to RDC requests for new supplies.
  -  RDCs to Suppliers requests for new stock to be manufactured and delivered.
  -  Suppliers to RDCs notifications when the requested products will be delivered.
  - Between RDCs requesting stock to be transferred as available and notifications when that stock will be delivered.

![](@attachment/Clipboard_2021-07-05-17-27-47.png)


#### Advantages

- Comms security is centralised
- The broker can be configured dynamically, adapting its policy to changing systems needs, and current state
- Inter-component monitoring is centralised , useful for debugging and auditing


### Pipe and Filter

- good for when multiple transformations are required between the initial and final output (e.g. media processing, textual analysis , data synthesis)
  - steps in the transformation can take variable amount of processing time ; can create bottlenecks
  - steps may need to evolve and adapt or be re-ordered to comply with new systems needs 
  - one may want to easily reuse some functions in combination

![](@attachment/Clipboard_2021-07-05-17-36-59.png)

- the needs mentioned above are met by leveraging the *homogeneous format* of the data being processed

- **filters** represent individual transformations to be applied to the data
- **pipes** represent the interface **common** to all filters
- **pipeline** represents the entire connection of pipes and filters
- **scheduler** is responsible for deciding which of the other components should execute at anyone time, managing the load in order to avoid bottlenecks
- **control** is the interface used by the scheduler

- the architecture has several different variables, covered below

#### Push/Pull Driven Data Flows 

- **difference** : how the data moves through
- **push**
  - data is driven into the system by a data provider (source), which submits the data to the first filter until its buffer is full
  - data is processed and passed on to the next filter
  - output is written to the passive sink
  - **appropriate** for systems where data is unpredictably and continuously generated (e.g. multimedia format conversion)
- **pull**
  - the requester (sink) actively polls the last filter, initiating a chain of pulls all the way up to the data source
  - **appropriate** for systems where data needs to be processed as a result of some external event in the data requester (e.g. a large scientific experiment that integrates a large collection of diverse data sets)

![](@attachment/Clipboard_2021-07-05-17-45-00.png)

#### Sequential/Concurrent Data Processing Filters

- **difference** : how the data is processed within each individual filter
- **sequential**
  - data is processed by each filter in turn
- **concurrent**
  - chunks of data are fed into the pipeline as soon as they become available

![](@attachment/Clipboard_2021-07-05-18-01-00.png)

#### Re-orderable/Inter-changeable Filters

- **difference** : how the filters can change within the pipeline
- **reorderable**
  - the filters order can be changed
- **interchangeable**
  - filters can be swapped out by others with the same interface, but the order remains the same
  - less flexible, since it requires different interfaces

![](@attachment/Clipboard_2021-07-05-18-02-53.png)

#### Branching Data Filters

- **difference** : leaf nodes other than the sink/source are allowed
- a branching filter can
  - replicate the data stream to the outgoing filters
  - filter each data item into one of the outgoing branches
- **advantages**
  - perform auxiliary functions on exact copies of the data (e.g logging)
  - applying two different transformations to the same incoming data source simultaneously (e.g. encoding video at different compression rates)
  - separate data items into different categories for alternative processing (e.g. different languages subtitles encoded into video)

![](@attachment/Clipboard_2021-07-05-18-05-34.png)

### Plugin

- used for extending the functionality of a specific application, not for building an entire one
  - if built entirely on plugins risk of **inner platform effect** , where essentially programmers build an entire programming language instead of exploiting the the benefits of the underlying programming language

- **registry** : stores the spec of all plugins
  - the main app can query the registry for available plugins
- **loader** : instantiates and configures the component 

![](@attachment/Clipboard_2021-07-05-18-16-57.png)

[^1]: https://foldingathome.org