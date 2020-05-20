let mock_logger () =
  let logger = Loga.Logger.create_default () in
  Loga.Logger.set_timer logger Loga.Timer.zero_gen;
  logger

let%expect_test _ =
  let logger = mock_logger () in
  let (module Loga) = Loga.with_logger logger in

  [%loga.info "loglog"];
  [%expect
    {| 1900-01-01T00:00:00+00:00 [     INFO] (example/log_example.ml:10) loglog |}];

  [%loga.info "param = %s" "a"];
  [%expect
    {| 1900-01-01T00:00:00+00:00 [     INFO] (example/log_example.ml:14) param = a |}];

  let n = 42 in
  [%loga.warning "N = %d" n];
  [%expect
    {| 1900-01-01T00:00:00+00:00 [  WARNING] (example/log_example.ml:19) N = 42 |}]

let%expect_test _ =
  let logger = mock_logger () in
  let (module Loga) = Loga.with_logger logger in

  Loga.Logger.set_severity logger Loga.Severity.Alert;

  [%loga.info "loglog"];
  [%expect {|  |}];

  [%loga.alert "loglog"];
  [%expect
    {| 1900-01-01T00:00:00+00:00 [    ALERT] (example/log_example.ml:32) loglog |}]
