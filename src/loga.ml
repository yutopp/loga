module Severity =
  struct
    type t =
      | Emergency
      | Alert
      | Critical
      | Error
      | Warning
      | Notice
      | Info
      | Debug

    let of_int n =
      match n with
      | 0 -> Emergency
      | 1 -> Alert
      | 2 -> Critical
      | 3 -> Error
      | 4 -> Warning
      | 5 -> Notice
      | 6 -> Info
      | 7 -> Debug
      | _ -> failwith "unexpected"

    let string_of k =
      match k with
      | Emergency   -> "EMERGENCY"
      | Alert       -> "ALERT"
      | Critical    -> "CRITICAL"
      | Error       -> "ERROR"
      | Warning     -> "WARNING"
      | Notice      -> "NOTICE"
      | Info        -> "INFO"
      | Debug       -> "DEBUG"
  end

let kfprint_datetime k formatter =
  let tz, _ = Unix.mktime (Unix.gmtime 0.0) in
  let Unix.{
    tm_year = year;
    tm_mon = month;
    tm_mday = mday;
    tm_hour = hours;
    tm_min = minutes;
    tm_sec = seconds;
  } = Unix.localtime (Unix.gettimeofday ()) in
  let tz_hours = -(int_of_float tz) / 3600 in
  let tz_minutes = -(int_of_float tz) / 60 mod 60 in
  Format.kfprintf k formatter
                  "%04d-%02d-%02dT%02d:%02d:%02d%0+3d:%02d "
                  (year + 1900) (month + 1) mday
                  hours minutes seconds tz_hours tz_minutes

let default_printer (severity, module_, line) formatter fmt =
  let k formatter =
    Format.fprintf formatter "\n%!"
  in
  let k formatter =
    Format.kfprintf k formatter fmt
  in
  let k formatter =
    Format.kfprintf k formatter "(%s:%d) " module_ line
  in
  let k formatter =
    Format.kfprintf k formatter "[%s] " (Severity.string_of severity)
  in
  kfprint_datetime k formatter

let log (severity_i, module_, line) fmt =
  default_printer (Severity.of_int severity_i, module_, line)
                  Format.std_formatter fmt
