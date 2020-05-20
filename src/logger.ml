(*
 * Copyright yutopp 2017 - .
 *
 * Distributed under the Boost Software License, Version 1.0.
 * (See accompanying file LICENSE_1_0.txt or copy at
 * http://www.boost.org/LICENSE_1_0.txt)
 *)

type t = {
  mutable severity : Severity.t;
  mutable formatter : Format.formatter;
  mutable timer : Timer.gen_t;
}

type location_t = string * int

let severity_to_int s =
  let open Severity in
  match s with
  | Emergency -> 0
  | Alert -> 1
  | Critical -> 2
  | Error -> 3
  | Warning -> 4
  | Notice -> 5
  | Info -> 6
  | Debug -> 7

let more_severe_than_or_equal a b = severity_to_int a <= severity_to_int b

type 'a format_t = ('a, Format.formatter, unit, unit) format4

let create ~severity ~formatter ~timer = { severity; formatter; timer }

let create_default () =
  create ~severity:Severity.Debug ~formatter:Format.std_formatter
    ~timer:Timer.current_gen

let set_severity logger severity = logger.severity <- severity

let set_formatter logger formatter = logger.formatter <- formatter

let set_timer logger timer = logger.timer <- timer

let printer ~logger =
  let open Printer.Builtin in
  datetime_printer logger.timer
  >> severity_printer >> position_printer >> format_printer >> endline_printer

let log logger severity (module_name, line) fmt =
  let pp = printer ~logger in
  match more_severe_than_or_equal severity logger.severity with
  | true ->
      let ctx = Context.make ~severity ~module_name ~line in
      pp (fun _ -> ()) ctx logger.formatter fmt
  | _ ->
      (* ignore *)
      Printf.ifprintf logger.formatter fmt

let emergency logger location fmt = log logger Severity.Emergency location fmt

let alert logger location fmt = log logger Severity.Alert location fmt

let critical logger location fmt = log logger Severity.Critical location fmt

let error logger location fmt = log logger Severity.Error location fmt

let warning logger location fmt = log logger Severity.Warning location fmt

let notice logger location fmt = log logger Severity.Notice location fmt

let info logger location fmt = log logger Severity.Info location fmt

let debug logger location fmt = log logger Severity.Debug location fmt
