module View.Helpers exposing (defaultHeader, defaultHeaderWithNavigation, defaultHeaderWithGitHubLink, routeHeaderText)

import Model exposing (Model)
import Html exposing (Html, text, span)
import Material.Layout as Layout
import Route exposing (Location(..))
import Msg exposing (Msg)


defaultHeader : Model -> String -> List (Html Msg)
defaultHeader model headerText =
    [ Layout.row
        []
        [ Layout.title [] [ text headerText ]
        ]
    ]


defaultHeaderWithNavigation : Model -> String -> List (Html Msg) -> List (Html Msg)
defaultHeaderWithNavigation model headerText navigation =
    [ Layout.row
        []
        [ Layout.title [] [ text headerText ]
        , Layout.spacer
        , Layout.navigation []
            navigation
        ]
    ]


defaultHeaderWithGitHubLink : Model -> String -> List (Html Msg)
defaultHeaderWithGitHubLink model headerText =
    defaultHeaderWithNavigation model
        headerText
        [ Layout.link
            [ Layout.href "https://github.com/knewter/time-tracker" ]
            [ span [] [ text "github" ] ]
        ]


routeHeaderText : Location -> String
routeHeaderText route =
    case route of
        Home ->
            "Dashboard"

        Users ->
            "Users"

        NewUser ->
            "New User"

        _ ->
            "Time Tracker"
