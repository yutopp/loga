open Ppxlib

let gen_log_expr fname ~loc ~path:_ expr =
  let open Ast_builder.Default in
  let severity = match fname with
    | "Loga.emergency"    -> 0
    | "Loga.alert"        -> 1
    | "Loga.critical"     -> 2
    | "Loga.error"        -> 3
    | "Loga.warning"      -> 4
    | "Loga.notice"       -> 5
    | "Loga.info"         -> 6
    | "Loga.debug"        -> 7
    | _                   -> failwith "[ERR] not supported"
  in
  let line = loc.loc_start.Lexing.pos_lnum in
  let callee = [%expr Loga.log] in
  let head = [%expr
                 [%e pexp_tuple ~loc [
                       eint ~loc severity;
                       evar ~loc "__MODULE__";
                       eint ~loc line;
             ]]]
  in
  let apply args =
    { expr with pexp_desc = Pexp_apply (callee, (Nolabel, head) :: args)}
  in
  match expr with
  | { pexp_desc = (Pexp_constant _); _ } ->
     (* Loga.* "" *)
     let args = [(Nolabel, expr)] in
     apply args
  | { pexp_desc = Pexp_apply (recv, args_with_labels); _ } ->
     (* Loga.* "" ... *)
     let args = (Nolabel, recv) :: args_with_labels in
     apply args
  | _ ->
     let ppf = Format.std_formatter in
     Pprintast.expression ppf expr;
     failwith "Not supported form"

let extention name =
  Context_free.Rule.extension
    (Extension.declare name
       Expression
       Ast_pattern.(single_expr_payload __)
       (gen_log_expr name))

let () =
  Driver.register_transformation "loga"
    ~rules:[
    extention "Loga.emergency";
    extention "Loga.alert";
    extention "Loga.critical";
    extention "Loga.error";
    extention "Loga.warning";
    extention "Loga.notice";
    extention "Loga.info";
    extention "Loga.debug";
    ]
