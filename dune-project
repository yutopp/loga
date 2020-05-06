(lang dune 2.5)
(name loga)
(version 0.0.3)

(generate_opam_files true)

(source (github yutopp/loga))
(license "Boost License Version 1.0")
(authors "yutopp")
(maintainers "yutopp@gmail.com")

(package
 (name loga)
 (synopsis "Logging library for OCaml")
 (depends
  (ocaml               (and :build (>= 4.06.0)))
  (dune                (and :build (>= 2.5)))
  (ounit               :with-test)
  (ppxlib              (>= 0.11.0))
  (ocaml-compiler-libs (>= v0.9.0))))
