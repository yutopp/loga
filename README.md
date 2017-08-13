# Loga

*WIP*

# HOW TO INSTALL

Clone this repository, then execute `opam pin`.
```
opam pin add loga . --strict
```

# Example

``` 
omake && omake example && ./example/log_example 
```

You can check that the source codes which preprocessed by ppx-loga.
```
omake && ocamlc -dsource -ppx ./src/ppx_loga.opt example/log_example.ml
```
