# Lyricli #
## The command line client for lyrics ##

This is a quick introduction for Lyricli. Right now it's in really early
stages of development, so it's lacking in a lot of stuff (mainly tests
and documentation) ... But it generally works and here's a tutorial to
see how to get it working.

### Installing ###

`gem install lyricli`

### Usage ###

Lyricli can be invoked with the command `lrc` and there are three basic
ways of using it:

`lrc`

When you run it without arguments, it will look in the available sources
to try to find a playing song and extract the lyrics.

`lrc artist song`

When you run it with arguments, it will use them to search for the
lyrics. This won't work if you manually disable the arguments source in
your configuration file.

#### Commands ####

The third way to use it is by passing it one of the following special
commands:

* `lrc -l` or `lrc --list-sources` lists the available sources.
* `lrc -e` or `lrc --enable SOURCE` enable a source from the list.
* `lrc -d` or `lrc --disable SOURCE` disable a source from the list.
* `lrc -r` or `lrc --reset SOURCE` reset all configuration for a source.
* `lrc -v` or `lrc --version` show the installed version of lyricli.
* `lrc -h` or `lrc --help` display some help

#### It always gives me rdio even if using iTunes ####

Due to the way the rdio API works, we can't tell if you're actively
listen and it always returns the last song. Currently the best way to
have the sources correctly is to enable **rdio first** and then
**itunes**. If you enabled itunes first, you can just disable and
re-enable and it should fix it.

### Roadmap ###

There is not much defined right now as a roadmap, but this needs to be
done:

* Specs for all the components
* YARD documentation for all the components

And the first thing I want to work on after that is done is separating
the Lyrics Engines so we can add/remove lyrics engines in a similar way to how
we currently add/remove sources.

Also, I want to add the last song to the configuration, so you can check
that. This would let us "watch" lyricli without hammering the lyrics
wiki api

Also, during the enable phase, sources like iTunes should check for
proper OS and stop if they're not in their home turf.

### Leave Feedback Please! ###

If you decide to use or hack away at Lyricly, please don't forget to
post any issues you find.

### License ###
Licensed under 3-clause-BSD.
