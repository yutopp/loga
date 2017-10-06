(*
 * Copyright yutopp 2017 - .
 *
 * Distributed under the Boost Software License, Version 1.0.
 * (See accompanying file LICENSE_1_0.txt or copy at
 * http://www.boost.org/LICENSE_1_0.txt)
 *)

let s_base_severity = ref Loga_severity.Debug

let set_base_severity serverity =
  s_base_severity := serverity

let log (severity_i, module_name, line) fmt =
  let severity = (Loga_severity.of_int severity_i) in
  match Loga_severity.more_severe_than_or_equal severity !s_base_severity with
  | true ->
     let ctx =
       Loga_context.make ~severity:severity
                         ~module_name:module_name
                         ~line:line
     in
     let printer =
       let open Loga_printer.Builtin in
       datetime_printer
       >> severity_printer
       >> position_printer
       >> format_printer
       >> endline_printer
     in
     printer () ctx Format.std_formatter fmt
  | _ ->
     (* ignore *)
     Printf.ifprintf Format.std_formatter fmt

(* dummy implementations for auto complete.
   NEVER called because these function names are rewritten by ppx *)
let emergency _ = failwith ""
let alert     _ = failwith ""
let critical  _ = failwith ""
let error     _ = failwith ""
let warning   _ = failwith ""
let notice    _ = failwith ""
let info      _ = failwith ""
let debug     _ = failwith ""
