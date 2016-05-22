Credo-pronto
============

[Pronto](https://github.com/mmozuras/pronto) runner for [credo](https://github.com/rrrene/credo)

Configuring runner
==================

First need install erlang-elixir-mix properly

Now you will need a global installation of mix credo and bunt.

To install blunt (globally)
```
git clone https://github.com/rrrene/bunt
cd bunt
mix archive.build
mix archive.install
```

To install credo (globally):
```
git clone https://github.com/rrrene/credo
cd credo
mix archive.build
mix archive.install
```

Installation
============

After install successfully credo globally you simple need install this gem

```
gem install pronto-credo
```

After the gem is installed, Pronto will already detect credo runner inside a
elixir project.

Configure checkers
==================

You can configure what checkers need in the project using `.credo.exs`
[configuration file](https://github.com/rrrene/credo/blob/master/.credo.exs)

Credits
=======

- [pronto-tailor](https://github.com/ajanauskas/pronto-tailor)
