(*
 * Copyright yutopp 2017 - .
 *
 * Distributed under the Boost Software License, Version 1.0.
 * (See accompanying file LICENSE_1_0.txt or copy at
 * http://www.boost.org/LICENSE_1_0.txt)
 *)

type t =
  | Emergency
  | Alert
  | Critical
  | Error
  | Warning
  | Notice
  | Info
  | Debug

let string_of s =
  match s with
  | Emergency -> "EMERGENCY"
  | Alert -> "ALERT"
  | Critical -> "CRITICAL"
  | Error -> "ERROR"
  | Warning -> "WARNING"
  | Notice -> "NOTICE"
  | Info -> "INFO"
  | Debug -> "DEBUG"
