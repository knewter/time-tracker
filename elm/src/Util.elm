module Util exposing (cmdsForModelRoute)

import Route exposing (Location(..))
import API
import Model exposing (Model)
import Msg exposing (Msg)


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
