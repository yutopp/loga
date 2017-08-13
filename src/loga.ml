let log (_severity, module_, line) fmt =
  Printf.printf ("(%s:%d) " ^^ fmt ^^ "\n") module_ line;
