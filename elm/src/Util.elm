module Util exposing (cmdsForModelRoute, MaterialTableHeader)

import Route exposing (Location(..))
import API
import Model exposing (Model)
import Msg exposing (Msg)
import Material.Table as Table
import Html exposing (Html)


cmdsForModelRoute : Model -> List (Cmd Msg)
cmdsForModelRoute model =
    case model.route of
        Just Users ->
            [ API.fetchUsers model ]

        Just (ShowUser id) ->
            [ API.fetchUser id model ]

        Just (EditUser id) ->
            [ API.fetchUser id model ]

        _ ->
            []



{- This is just so that we can annotate our thOptions function - I wish it
   were exposed from Material.Table.  https://github.com/debois/elm-mdl/blob/7.5.0/src/Material/Table.elm#L178
-}


type alias MaterialTableHeader m =
    { numeric : Bool
    , sorted : Maybe Table.Order
    , onClick : Maybe (Html.Attribute m)
    }
