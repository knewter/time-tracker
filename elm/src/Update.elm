module Update exposing (update)

import Model exposing (Model)
import Msg exposing (Msg(..))
import Material


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Mdl msg' ->
            Material.update msg' model
