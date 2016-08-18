module Msg exposing (Msg(..))

import Material


type Msg
    = Mdl (Material.Msg Msg)
