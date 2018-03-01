# Crirc

A crystal library to create irc client/bot/server.

Works with crystal v0.23.0


## Installation

[![travis](https://travis-ci.org/Meoowww/Crirc.svg)](https://travis-ci.org/Meoowww/Crirc)

To install the lib, you will have to add the Crirc dependancy to your project.

Add this to your application's `shard.yml`:

```yaml
dependencies:
  Crirc:
    github: Meoowww/Crirc
```

Then, run ``crystal deps install`` to fetch the lib.

## Development

The project is built around 4 layers of objects:

- **Network**: A network object manage a socket / IO. The interface is described by <https://meoowww.github.io/Crirc/Crirc/Network/Network.html>.
- **Controller**: A controller belongs to a network object, and handle the logic and data. Its interface is described by <https://meoowww.github.io/Crirc/Crirc/Controller/Controller.html>.
- **Protocol**: A protocol object represent a IRC entity (chan, user, message, ...).
- **Binding**: The `Binding::Handler` allows a given `Controller` to respond to incoming transmissions.

## Documentation

The documentation is built automaticaly when a commit is pushed on master on github, via Travis: <https://meoowww.github.io/Crirc/>.

A full implementation of a bot is published and maintained on <https://github.com/Meoowww/DashBot>.


## Contributing

1. Fork it ( https://github.com/Meoowww/Crirc/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request


## Contributors

- [Nephos](https://github.com/Nephos) Arthur Poulet - creator, maintainer
- [Damaia](https://github.com/Lucie-Dispot) Lucie Dispot - developer
