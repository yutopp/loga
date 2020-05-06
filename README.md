# Loga

*WIP*


# HOW TO INSTALL

Clone this repository, then execute `opam pin`.

```
opam pin add loga . --strict
```

(TODO: Register to opam...)

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
    [%Loga.info "Hello %s %d" "world" 42];
```

# How to run

``` 
dune runtest
```
