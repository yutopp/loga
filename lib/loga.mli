(*
 * Copyright yutopp 2017 - .
 *
 * Distributed under the Boost Software License, Version 1.0.
 * (See accompanying file LICENSE_1_0.txt or copy at
 * http://www.boost.org/LICENSE_1_0.txt)
 *)

val set_base_severity : Loga_severity.t -> unit

val log : (int * string * int)
          -> ('a, Format.formatter, unit) format
          -> 'a

(* dummy interfaces for auto complete *)
val emergency : ('a, Format.formatter, unit) format -> 'a
val alert     : ('a, Format.formatter, unit) format -> 'a
val critical  : ('a, Format.formatter, unit) format -> 'a
val error     : ('a, Format.formatter, unit) format -> 'a
val warning   : ('a, Format.formatter, unit) format -> 'a
val notice    : ('a, Format.formatter, unit) format -> 'a
val info      : ('a, Format.formatter, unit) format -> 'a
val debug     : ('a, Format.formatter, unit) format -> 'a
