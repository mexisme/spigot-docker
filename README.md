Build with Packer 0.12 or later (to support the "changes" attr)

Set-up with:
```
bundle install
```
NB: Should work immediately with Ruby 2.3.1

Build with:
```
bundle exec rake build
```

Run with:
```
bundle exec rake run DIR=...
```
NB: Set `DIR` tp the directory for persisting the world-data and config files.
