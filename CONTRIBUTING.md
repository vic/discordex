# Contributor Guide

First of all, thank you for thinking about contributing to Discordex.

All kinds of contributions are welcome, from better documentation,
bug reports, and of course, code. Feel free to dig in the issues and
search if anyone has reported or is working on the feature you want
before duplicating effort.


## Discord Documentation

http://discordapi-unoffical.readthedocs.org/en/latest/index.html

## Testing

Read http://blog.plataformatec.com.br/2015/10/mocks-and-explicit-contracts/

We believe having test before code is a good-thing, so we invite you to
follow a TDD way.

All tests that actually use Discord HTTP api are tagged but are not run by
default. You can run them with:

```shell
mix test --include discord_api
```
