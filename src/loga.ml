(*
 * Copyright yutopp 2017 - .
 *
 * Distributed under the Boost Software License, Version 1.0.
 * (See accompanying file LICENSE_1_0.txt or copy at
 * http://www.boost.org/LICENSE_1_0.txt)
 *)

module Severity = Severity

let s_base_severity = ref Severity.Debug

module type LOGGER = sig
  type t

  type location_t = string * int

  type 'a format_t = ('a, Format.formatter, unit, unit) format4

  val create : severity:Severity.t -> time:'a -> t

  val set_severity : t -> Severity.t -> unit

  val log : t -> Severity.t -> location_t -> 'a format_t -> 'a

  val emergency : t -> location_t -> 'a format_t -> 'a

  val alert : t -> location_t -> 'a format_t -> 'a

  val critical : t -> location_t -> 'a format_t -> 'a

  val error : t -> location_t -> 'a format_t -> 'a

  val warning : t -> location_t -> 'a format_t -> 'a

  val notice : t -> location_t -> 'a format_t -> 'a

  val info : t -> location_t -> 'a format_t -> 'a

  val debug : t -> location_t -> 'a format_t -> 'a
end

module Logger : LOGGER = struct
  type t = { mutable severity : Severity.t }

  type location_t = string * int

  type 'a format_t = ('a, Format.formatter, unit, unit) format4

  let create ~severity ~time:_ = { severity }

  let set_severity logger severity = logger.severity <- severity

  let printer () =
    let open Loga_printer.Builtin in
    datetime_printer >> severity_printer >> position_printer >> format_printer
    >> endline_printer

  let log logger severity (module_name, line) fmt =
    let pp = printer () in
    match Severity.more_severe_than_or_equal severity logger.severity with
    | true ->
        let ctx = Loga_context.make ~severity ~module_name ~line in
        pp () ctx Format.std_formatter fmt
    | _ ->
        (* ignore *)
        Printf.ifprintf Format.std_formatter fmt

  let emergency logger location fmt = log logger Severity.Emergency location fmt

  let alert logger location fmt = log logger Severity.Alert location fmt

  let critical logger location fmt = log logger Severity.Critical location fmt

  let error logger location fmt = log logger Severity.Error location fmt

  let warning logger location fmt = log logger Severity.Warning location fmt

  let notice logger location fmt = log logger Severity.Notice location fmt

  let info logger location fmt = log logger Severity.Info location fmt

  let debug logger location fmt = log logger Severity.Debug location fmt
end

let default_logger = Logger.create ~severity:Severity.Debug ~time:0

(* dummy implementations for auto complete.
   NEVER called because these function names are rewritten by ppx *)
let emergency _ = failwith ""

let alert _ = failwith ""

let critical _ = failwith ""

let error _ = failwith ""

let warning _ = failwith ""

let notice _ = failwith ""

let info _ = failwith ""

let debug _ = failwith ""
