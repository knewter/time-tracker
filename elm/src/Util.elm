module Util exposing (cmdsForModelRoute, MaterialTableHeader)

import Route exposing (Location(..))
import API
import Model exposing (Model)
import Msg exposing (Msg(..))
import Material.Table as Table
import Html exposing (Html)


cmdsForModelRoute : Model -> List (Cmd Msg)
cmdsForModelRoute model =
    case model.route of
        Just Users ->
            [ API.fetchUsers model (always NoOp) GotUsers ]

        Just (ShowUser id) ->
            [ API.fetchUser model id (always NoOp) GotUser ]

        Just (EditUser id) ->
            [ API.fetchUser model id (always NoOp) GotUser ]

        Just Projects ->
            [ API.fetchProjects model (always NoOp) GotProjects ]

        Just (ShowProject id) ->
            [ API.fetchProject model id (always NoOp) GotProject ]

        Just (EditProject id) ->
            [ API.fetchProject model id (always NoOp) GotProject ]

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
