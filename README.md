# Loga

[![Loga](https://circleci.com/gh/yutopp/loga.svg?style=svg)](https://circleci.com/gh/yutopp/loga)

*WIP*

A logging library for OCaml.

# HOW TO INSTALL

```
opam install loga
```

# How to use

Add a `loga` and `loga.ppx` to your dune file.

Example:

```
(libraries loga)
(preprocess (pps loga.ppx)
```

Then you can use logger like below!

``` ocaml
let () =
    [%loga.info "Hello %s %d" "world" 42];
```

# How to develop

## Build

```
git clone git@github.com:yutopp/loga.git
cd loga
opam pin add loga . --strict
```

## Run tests
``` 
dune runtest
```
