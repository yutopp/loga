open Ppxlib

let gen_log_expr severity ~loc ~path:_ expr =
  let open Ast_builder.Default in
  let line = loc.loc_start.Lexing.pos_lnum in
  let callee = match severity with
    | Loga.Severity.Emergency-> [%expr Loga.Logger.emergency]
    | Loga.Severity.Alert-> [%expr Loga.Logger.alert]
    | Loga.Severity.Critical-> [%expr Loga.Logger.critical]
    | Loga.Severity.Error-> [%expr Loga.Logger.error]
    | Loga.Severity.Warning-> [%expr Loga.Logger.warning]
    | Loga.Severity.Notice-> [%expr Loga.Logger.notice]
    | Loga.Severity.Info-> [%expr Loga.Logger.info]
    | Loga.Severity.Debug -> [%expr Loga.Logger.debug]
  in
  let logger = [%expr Loga.default_logger] in
  let location = [%expr
                 [%e pexp_tuple ~loc [
                       evar ~loc "__MODULE__";
                       eint ~loc line;
             ]]]
  in
  let apply args =
    { expr with pexp_desc = Pexp_apply (callee, (Nolabel, logger) :: (Nolabel, location) :: args)}
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

let extention severity name =
  Context_free.Rule.extension
    (Extension.declare name
       Expression
       Ast_pattern.(single_expr_payload __)
       (gen_log_expr severity))

let () =
  Driver.register_transformation "loga"
    ~rules:[
    extention Loga.Severity.Emergency "Loga.emergency";
    extention Loga.Severity.Alert "Loga.alert";
    extention Loga.Severity.Critical "Loga.critical";
    extention Loga.Severity.Error "Loga.error";
    extention Loga.Severity.Warning "Loga.warning";
    extention Loga.Severity.Notice "Loga.notice";
    extention Loga.Severity.Info "Loga.info";
    extention Loga.Severity.Debug "Loga.debug";
    ]
