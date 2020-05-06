let%expect_test _ =
  [%Loga.info "loglog"];
  [%Loga.info "param = %s" "a"];

  let n = 42 in
  [%Loga.warning "N = %d" n];
  [%expect {| \(foo\|bar\) (regexp) |}]
  (* 2017-08-14T03:58:33+09:00 [INFO] (Log_example:2) loglog *)

  (*let n = 42 in*)
  (*[%plop "N = %d" n];*)
  (* 2017-08-14T04:00:41+09:00 [WARNING] (Log_example:6) N = 42 *)
