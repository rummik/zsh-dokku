 ZSH Dokku [![Donations][]][gratipay]
===========
A very early wrapper around Dokku's SSH API.

[Donations]: http://img.shields.io/gratipay/rummik.png
[gratipay]: https://www.gittip.com/rummik/


## Getting Started
Install with [Antigen][]: `antigen bundle rummik/zsh-dokku`

Or if you feel like doing it the old-fashioned way:
```sh
mkdir -p ~/src
git clone git://github.com/rummik/zsh-dokku.git ~/src/zsh-dokku
print 'source ~/src/zsh-dokku/dokku.plugin.zsh' >> ~/.zshrc
```

[Antigen]: https://github.com/zsh-users/antigen


## Documentation
Specify a default remote host with `DOKKU_HOST=your.server.tld` in your `~/.zshrc`


## License
Copyright (c) 2015
Licensed under the MPL license.
