(*
 * Copyright yutopp 2017 - .
 *
 * Distributed under the Boost Software License, Version 1.0.
 * (See accompanying file LICENSE_1_0.txt or copy at
 * http://www.boost.org/LICENSE_1_0.txt)
 *)

module Logger = Logger
module Severity = Severity
module Timer = Timer

let logger = Logger.create_default ()

module type HAS_LOGGER = sig
  module Logger = Logger
  module Severity = Severity
  module Timer = Timer

  val logger : Logger.t
end

let with_logger logger =
  ( module struct
    module Logger = Logger
    module Severity = Severity
    module Timer = Timer

    let logger = logger
  end : HAS_LOGGER )
