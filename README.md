[![Gem Version](https://badge.fury.io/rb/bcupgrade.svg)](https://badge.fury.io/rb/bcupgrade)

# Bcupgrade - brew cask upgrade

Upgrade all installed brew casks.

## Requirement

- [Homebrew Cask](https://caskroom.github.io/) v0.60.1+


This script uses `brew cask info` result.

```
% brew cask info atom
atom: 1.10.2
https://atom.io/
/usr/local/Caskroom/atom/1.7.3 (does not exist)
/usr/local/Caskroom/atom/1.8.0 (68B)
/usr/local/Caskroom/atom/1.9.0 (2,546 files, 224.9M)
From: https://github.com/caskroom/homebrew-cask/blob/master/Casks/atom.rb
==> Name
Github Atom
==> Artifacts
Atom.app (app)
/Applications/Atom.app/Contents/Resources/app/apm/node_modules/.bin/apm (binary)
/Applications/Atom.app/Contents/Resources/app/atom.sh (binary)
```

## Installation

    % gem install bcupgrade

## Usage

```
% bcupgrade --help
Usage: bcupgrade [options]
    -d, --dry-run                    Show output without running
    -r, --remove                     Remove previous version casks with installing
    -y, --yes                        Install cask without prompt
    -v, --version                    Show version number
```

`bcupgrade` with no arguments to check & upgrade all casks. 

- displays a confirmation prompt `[y/n]` when it attempts to re-install.
- Install latest version. (`brew cask install --force #{cask}`)

```
% bcupgrade

==> Check 'brew cask list'...
["1password", "alfred", "atom", "bartender"]

==> Check 'brew cask info' for the latest available version...
1password / 6.3.2
atom / 1.10.2

Upgrade 1password? [y/n] n

Upgrade atom? [y/n] y
install atom
==> Satisfying dependencies
complete
==> Downloading https://github.com/atom/atom/releases/download/v1.10.2/atom-mac.zip
############################################################################################################################## 100.0%
==> Verifying checksum for Cask atom
==> It seems there is already an App at '/Applications/Atom.app'; overwriting.
==> Removing App: '/Applications/Atom.app'
==> Moving App 'Atom.app' to '/Applications/Atom.app'
==> Symlinking Binary 'apm' to '/usr/local/bin/apm'
==> Symlinking Binary 'atom.sh' to '/usr/local/bin/atom'
🍺  atom was successfully installed!
```

`bcupgrade` with arguments to check & upgrade selected casks.

```
% bcupgrade dropbox firefox
```


## Configuration File

If you want to ignore upgrade casks, you can add settings in the user's `~/.bcupgrade` (YAML syntax).

```
ignore:
  - omniplan
  - sublime-text2
```


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/DriftwoodJP/bcupgrade.
This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

