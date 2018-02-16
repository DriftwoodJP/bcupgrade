[![Gem Version](https://badge.fury.io/rb/bcupgrade.svg)](https://badge.fury.io/rb/bcupgrade)
[![Build Status](https://travis-ci.org/DriftwoodJP/bcupgrade.svg?branch=master)](https://travis-ci.org/DriftwoodJP/bcupgrade)
[![Maintainability](https://api.codeclimate.com/v1/badges/530785088f8f43bc075b/maintainability)](https://codeclimate.com/github/DriftwoodJP/bcupgrade/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/530785088f8f43bc075b/test_coverage)](https://codeclimate.com/github/DriftwoodJP/bcupgrade/test_coverage)

# Bcupgrade - brew cask upgrade

Awesome `brew cask upgrade` command.




## Requirement

- [Homebrew Cask](https://caskroom.github.io/) v1.4.2 or later.
- Ruby v2.3.3 or later. (System ruby on macOS High Sierra)




## Installation

```
% gem install bcupgrade
```




## Usage

`bcupgrade` with no arguments to check & upgrade all casks. 

- Displays confirmation prompts `[y/n]`.
- Install latest version. (`brew cask reinstall #{cask}`)

```
% bcupgrade

==> Outdated cask...
omnioutliner (4.6.1) != 5.2
scrivener (2.81.2,106) != 3.0.1,966

Not upgrading pinned package:
["iterm2", "omniplan1", "omnioutliner", "sketch"]

Upgrade scrivener? [y/n] yes

==> Upgrade scrivener
==> Satisfying dependencies
==> Downloading https://scrivener.s3.amazonaws.com/mac_updates/Scrivener_1012_966.zip
######################################################################## 100.0%
==> Verifying checksum for Cask scrivener
==> Uninstalling Cask scrivener
==> Moving App 'Scrivener.app' back to '/usr/local/Caskroom/scrivener/2.81.2,106/Scrivener.app'.
==> Purging files for version 2.81.2,106 of Cask scrivener
==> Installing Cask scrivener
==> Moving App 'Scrivener.app' to '/Applications/Scrivener.app'.
🍺  scrivener was successfully installed!
```

`bcupgrade` with arguments to check & upgrade selected casks.

```
% bcupgrade dropbox firefox
```


### Options

```
% bcupgrade --help
Usage: bcupgrade [options] [cask1 cask2...]
    -d, --dry-run                    Check outdated cask without upgrading
    -y, --yes                        Automatic yes to prompts
    -v, --version                    Show version number
```


### Configuration File

If you want to ignore upgrade casks, you can add settings in the user's `~/.bcupgrade` (YAML syntax).

```
ignore:
  - iterm2
  - omniplan1
  - omnioutliner
  - sketch
```

To stop from being upgraded: like `brew cask pin`




## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/DriftwoodJP/bcupgrade.
This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.




## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

