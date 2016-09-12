# Bcupgrade - brew cask upgrade

Upgrade all installed brew casks.

## Requirement

- [Homebrew Cask](https://caskroom.github.io/) v0.60.1+


This script uses `brew cask info` result.

```
% brew cask info atom
atom: 1.10.1
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

    % bcupgrade

`bcupgrade` displays a confirmation prompt \[y/n\] when it attempts to re-install.

```
% bcupgrade

Create cask list...
["1password", "alfred", "atom", "bartender"]

Check update cask...
["1password" "atom"]

Upgrade 1password? [y/n] n

Upgrade atom? [y/n] y
remove atom
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

## Development

After checking out the repo, run `bin/setup` to install dependencies.
Then, run `rake spec` to run the tests.
You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.
To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/DriftwoodJP/bcupgrade.
This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

