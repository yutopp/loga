open Ocaml_common.Ast_mapper
open Ocaml_common.Ast_helper
open Parsetree
open Asttypes
open Location

let loga_mapper argv =
  let check_and_generate_apply fname loc exprs =
    let severity = match fname with
      | "Loga.emergency"    -> 0
      | "Loga.alert"        -> 1
      | "Loga.critical"     -> 2
      | "Loga.error"        -> 3
      | "Loga.warning"      -> 4
      | "Loga.notice"       -> 5
      | "Loga.info"         -> 6
      | "Loga.debug"        -> 7
      | _ -> failwith "[ICE] not supported"
    in
    let line = loc.loc_start.Lexing.pos_lnum in
    let checked_args =
      (* TODO: check head of exprs is string *)
      let ppx_expr =
        let tup = [
          {
            pexp_desc = Pexp_constant (Pconst_integer (string_of_int severity, None));
            pexp_loc = none;
            pexp_attributes = [];
          };
          {
            pexp_desc = Pexp_ident { txt = Longident.parse "__MODULE__"; loc };
            pexp_loc = none;
            pexp_attributes = [];
          };
          {
            pexp_desc = Pexp_constant (Pconst_integer (string_of_int line, None));
            pexp_loc = none;
            pexp_attributes = [];
          };
        ]
        in
        {
          pexp_desc = Pexp_tuple tup;
          pexp_loc = none;
          pexp_attributes = [];
        }
      in
      List.map (fun e -> (Nolabel, e)) (ppx_expr :: exprs)
    in
    let callee =
      {
        pexp_desc = Pexp_ident { txt = Longident.parse "Loga.log"; loc = none };
        pexp_loc = none;
        pexp_attributes = [];
      }
    in
    Pexp_apply (callee, checked_args)
  in
  let expr mapper expr =
    match expr with
    | { pexp_desc = Pexp_extension ({ txt = "Loga.emergency" as fname; loc }, pstr)}
    | { pexp_desc = Pexp_extension ({ txt = "Loga.alert" as fname; loc }, pstr)}
    | { pexp_desc = Pexp_extension ({ txt = "Loga.critical" as fname; loc }, pstr)}
    | { pexp_desc = Pexp_extension ({ txt = "Loga.error" as fname; loc }, pstr)}
    | { pexp_desc = Pexp_extension ({ txt = "Loga.warning" as fname; loc }, pstr)}
    | { pexp_desc = Pexp_extension ({ txt = "Loga.notice" as fname; loc }, pstr)}
    | { pexp_desc = Pexp_extension ({ txt = "Loga.info" as fname; loc }, pstr)}
    | { pexp_desc = Pexp_extension ({ txt = "Loga.debug" as fname; loc }, pstr)} ->
       begin
         match pstr with
         | PStr [{ pstr_desc = Pstr_eval (sexpr, attrs) }] ->
            begin
              match sexpr with
              | { pexp_desc = (Pexp_constant _) } ->
                 (* Loga.* "" *)
                 { expr with
                   pexp_desc = check_and_generate_apply fname loc [sexpr] }
              | { pexp_desc = Pexp_apply (recv, args_with_labels) } ->
                 (* Loga.* "" ... *)
                 let args =
                   List.map (function
                              | (Nolabel, expr) -> expr
                              | (_, expr) -> failwith "not supported (label)"
                            ) args_with_labels
                 in
                 { expr with
                   pexp_desc = check_and_generate_apply fname loc (recv :: args) }
              | _ ->
                 failwith "not supported form"
            end
         | _ ->
            failwith "not supported form"
       end
    | _ ->
       default_mapper.expr mapper expr
  in
  { default_mapper with expr }

let () =
  register "Loga" loga_mapper
