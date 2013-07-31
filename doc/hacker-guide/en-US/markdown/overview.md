Major components
================

libglusterfs
------------

`libglusterfs` contains supporting code used by all the other components.
The important files here are:

`dict.c`: This is an implementation of a serializable dictionary type. It is
used by the protocol code to send requests and replies. It is also used to pass options
to translators.

`logging.c`: This is a thread-safe logging library. The log messages go to a
file (default `/usr/local/var/log/glusterfs/*`).

`protocol.c`: This file implements the GlusterFS on-the-wire
protocol. The protocol itself is a simple ASCII protocol, designed to
be easy to parse and be human readable.

A sample GlusterFS protocol block looks like this:

```
  Block Start                            header
  0000000000000023                       callid
  00000001                               type
  00000016                               op
  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx       human-readable name
  00000000000000000000000000000ac3       block size
  <...>                                  block
  Block End
```

`stack.h`: This file defines the `STACK_WIND` and
`STACK_UNWIND` macros which are used to implement the parallel
stack that is maintained for inter-xlator calls. See the \textsl{Taking control
of the stack} section below for more details.

`spec.y`: This contains the Yacc grammar for the GlusterFS
specification file, and the parsing code.

Taking control of the stack
---------------------------

One can think of STACK_WIND/UNWIND as a very specific RPC mechanism.
