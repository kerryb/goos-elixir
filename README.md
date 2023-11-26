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

## Rerequisites

### XMPP server

I used Openfire, configured as per chapter 11 of the book. I used OpenJDK
(`brew install openjdk`), then had to add `export
JAVA_HOME=/usr/local/Cellar/openjdk/21.0.1` to my profile, and also recursively
`chown` the `/usr/local/openfire` directory to my local user, before running
`/usr/local/openfire/bin/openfire.sh` and using the web console to add users
and disable kicking (Server Settings → Resource Policy).

### XMPP client

I initially tried [XMPP](https://github.com/processone/xmpp), but couldn’t get
it to compile under the latest versions of Erlang (26.1.2) and Elixir (1.15.7),
so I ended up going with [Romeo](https://github.com/scrogson/romeo). That
didn’t compile either, but at least it’s written in Elixir rather than Erlang,
so I was able to [fork it](https://github.com/kerryb/romeo.git) and fix the
errors.
