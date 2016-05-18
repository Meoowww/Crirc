# CrystalIrc

A crystal lib for irc client.

Works for crystal v0.17.

## Installation

[![travis](https://travis-ci.org/Meoowww/CrystalIrc.svg)](https://travis-ci.org/Meoowww/CrystalIrc)

Add this to your application's `shard.yml`:

```yaml
dependencies:
  CrystalIrc:
    github: Meoowww/CrystalIrc
```


## Usage


```crystal
require "CrystalIrc"

cli = CrystalIrc::Bot.new ip: "irc.mozilla.org", nick: "PonyBot"
chan = CrystalIrc::Chan.new("#ponytown")

cli.on("JOIN") do |irc, msg|
  name = msg.from.split("!").first
  irc.privmsg(chan, "Welcome every ponies #{name} :)")
end

cli.connect
cli.join([chan])
```
":niark JOIN :#ponytown"


## Development

TODO: Write development instructions here

## Contributing

1. Fork it ( https://github.com/pouleta/CrystalIrc/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [Nephos](https://github.com/Nephos) Arthur Poulet - creator, maintainer
