(*
 * Copyright yutopp 2017 - .
 *
 * Distributed under the Boost Software License, Version 1.0.
 * (See accompanying file LICENSE_1_0.txt or copy at
 * http://www.boost.org/LICENSE_1_0.txt)
 *)

type 'a cont = Format.formatter -> 'a

module Builtin = struct
  let endline_printer _k _ctx formatter _fmt = Format.fprintf formatter "\n%!"

  let format_printer k _ctx formatter fmt : 'a = Format.kfprintf k formatter fmt

  let position_printer k ctx formatter _fmt : 'a =
    let module_name = Loga_context.module_name ctx in
    let line = Loga_context.line ctx in
    Format.kfprintf k formatter "(%s:%d) " module_name line

  let severity_printer k ctx formatter _fmt : 'a =
    let severity = Loga_context.severity ctx in
    Format.kfprintf k formatter "[%9s] " (Severity.string_of severity)

  let datetime_printer k _ctx formatter _fmt : 'a =
    let (tz, _) = Unix.mktime (Unix.gmtime 0.0) in
    let {
      Unix.tm_year = year;
      Unix.tm_mon = month;
      Unix.tm_mday = mday;
      Unix.tm_hour = hours;
      Unix.tm_min = minutes;
      Unix.tm_sec = seconds;
      _;
    } =
      Unix.localtime (Unix.gettimeofday ())
    in
    let tz_hours = -int_of_float tz / 3600 in
    let tz_minutes = -int_of_float tz / 60 mod 60 in
    Format.kfprintf k formatter "%04d-%02d-%02dT%02d:%02d:%02d%0+3d:%02d "
      (year + 1900) (month + 1) mday hours minutes seconds tz_hours tz_minutes

  let ( >> ) first_printer second_printer =
    let printer k ctx formatter fmt : 'a =
      let k0 formatter = second_printer k ctx formatter fmt in
      first_printer k0 ctx formatter fmt
    in
    printer
end

module type Builder = sig end

module Default_printer_builder : Builder = struct end
