module Util exposing (cmdsForModelRoute, MaterialTableHeader)

import Route exposing (Location(..))
import API
import Model exposing (Model)
import Msg exposing (Msg(..), UserMsg(..), ProjectMsg(..), OrganizationMsg(..))
import Material.Table as Table
import Html exposing (Html)
import OurHttp exposing (Error(BadResponse))


cmdsForModelRoute : Model -> List (Cmd Msg)
cmdsForModelRoute model =
    case model.route of
        Just Users ->
            [ API.fetchUsers model <| UserMsg' << GotUsers
            ]

        Just (ShowUser id) ->
            [ API.fetchUser model id (always NoOp) <| UserMsg' << GotUser ]

        Just (EditUser id) ->
            [ API.fetchUser model id (always NoOp) <| UserMsg' << GotUser ]

        Just Projects ->
            [ API.fetchProjects model <| ProjectMsg' << GotProjects ]

        Just (ShowProject id) ->
            [ API.fetchProject model id (always NoOp) <| ProjectMsg' << GotProject ]

        Just (EditProject id) ->
            [ API.fetchProject model id (always NoOp) <| ProjectMsg' << GotProject ]

        Just Organizations ->
            [ API.fetchOrganizations model <| OrganizationMsg' << GotOrganizations ]

        Just (ShowOrganization id) ->
            [ API.fetchOrganization model id (always NoOp) <| OrganizationMsg' << GotOrganization ]

        Just (EditOrganization id) ->
            [ API.fetchOrganization model id (always NoOp) <| OrganizationMsg' << GotOrganization ]

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
