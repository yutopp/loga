# Loga

[![Loga](https://circleci.com/gh/yutopp/loga.svg?style=svg)](https://circleci.com/gh/yutopp/loga)

*WIP*

A logging library for OCaml.

# How to install

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

Then you can use a (default) logger like below! This macro shows date, severity, a location and messages.

``` ocaml
[%loga.info "Hello %s %d" "world" 42];
```

``` shell
# Output
2020-05-20T13:23:53+09:00 [     INFO] (example/log_example.ml:9) Hello world 42
```

Default severity of a logger is `debug`. You can change it by using `set_severity`.

``` ocaml
Loga.Logger.set_severity Loga.logger Loga.Severity.Alert;
(* This info will not be printed. *)
[%loga.info "Hello %s %d" "world" 42];
```

And a logger prints logs to `stdout` by default. You can also change it by using `set_formatter`.

``` ocaml
Loga.Logger.set_formatter Loga.logger Format.err_formatter;
(* This log is printed to stderr. *)
[%loga.info "Hello %s %d" "world" 42];
```

Previous examples use a default logger. You can use a custom local logger.

``` ocaml
let logger = Loga.Logger.create_default () in
(* Overriding `Loga` is important. TODO: fix this interface... *)
let (module Loga) = Loga.with_logger logger in
(* It uses a logger set by `with_logger` instead of the default logger. *)
[%loga.info "Hello %s %d" "world" 42];
```

# How to develop

## Build

```
https://github.com/yutopp/loga.git
cd loga
opam pin add loga . --strict
```

## Run tests
``` 
dune runtest
```
