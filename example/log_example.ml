let () =
  [%Loga.info "loglog"];
  [%Loga.warning "%d" 42];
  Printf.printf "LINE: %d\n" __LINE__;
  ()
