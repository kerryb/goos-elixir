# GOOS in Elixir

This is an attempt to work through _[Growing Object-Oriented Software Guided by
Tests](http://www.growing-object-oriented-software.com/)_, but in Elixir, which
is not exactly known for being an object-oriented language … [or is
it?](https://elixirforum.com/t/the-oop-concept-according-to-erlang/21078/3)

It’s quite possible (a) that this is a terrible idea, (b) that I’ll get bored
and abandon it part-way through, or (c) both of the above.

I’ve previously [done this in Ruby](https://github.com/kerryb/goos-ruby).

## Library choices

  * Gui: [Scenic](https://hexdocs.pm/scenic/welcome.html)
  * XMPP client: [Romeo](https://github.com/scrogson/romeo)

## Rerequisites

### XMPP server

I used Openfire, configured as per chapter 11 of the book. I used OpenJDK
(`brew install openjdk`), then had to add `export
JAVA_HOME=/usr/local/Cellar/openjdk/21.0.1` to my profile, and also recursively
`chown` the `/usr/local/openfire` directory to my local user, before running
`/usr/local/openfire/bin/openfire.sh` and using the web console to add users
and disable kicking (Server Settings → Resource Policy).

There’s a `make` target to run Openfire. Once it’s installed, to start it (in
the foreground), run:

```
make openfire
```

### XMPP client

I initially tried [XMPP](https://github.com/processone/xmpp), but couldn’t get
it to compile under the latest (at the time) versions of Erlang (26.1.2) and
Elixir (1.15.7), so I ended up going with
[Romeo](https://github.com/scrogson/romeo). That didn’t compile either, but at
least it’s written in Elixir rather than Erlang, so I was able to [fork
it](https://github.com/kerryb/romeo.git) and fix the errors without too much
trouble.

## Running the tests

With openfire running (see above), run either `mix test`, or just `make`.

## Progress

The repository has tags (`chapter-10`, `chapter-11` etc) marking the state at
the end of each chapter.

### Chapter 10: The Walking Skeleton

This mainly involves just creating the application with some placeholder
modules and functions. It doesn’t do anything, but it does at least compile.

### Chapter 11: Passing the First Test

The code follows the book reasonably closely, with the sniper and fake auction
server being implemented as `GenServer`s to allow them to maintain state. XMPP
messages are handled as normal by these processes using `handle_info`, rather
than by registering separate listeners.

Testing the contents of the Scenic GUI isn’t straightforward, and the current
implementation (in `AuctionSniper.AuctionSniperDriver`) is far more coupled to
Scenic internals than I’d like.

### Chapter 12: Getting Ready to Bid

I didn’t see the “surprise failure” described in the book (where two tests try
to simultaneously connect to the XMPP server), because the application is
started in the test using `ExUnit.start_supervised/2`, which ensures the
process is terminated before running the next test. However, this is only true
because the two end-to-end tests are in the same module. ExUnit always runs
testts in a single module sequentially (in a random order), but with `async:
true` they could be run in parallel with other tests in different modules.

In the process of adding support for multiple messages, I refactored
`FakeAuctionServer` to keep a list of received messages, and check these when
asserting that a particular message has been received. This is simpler than the
way I did it in the previous chapter, and is also closer to the implementation
in the book.

Rather than mocking an `AuctionEventListener` interface (this would be a
behaviour in Elixir), `AuctionMessageTranslator` sends a message to a process.
In production this is the main application server, but in the test it’s the
test process itself, so we can simply use `assert_receive`.

The book includes an unused `chat` argument in the signature for
`process_message`, but they specifically say “as it happens, we don’t need one
for the current functionality”, so I’m calling Yagni for now.
