module View.Helpers exposing (defaultHeader, defaultHeaderWithNavigation, defaultHeaderWithGitHubLink, routeHeaderText)

import Html exposing (Html, text, span)
import Material.Layout as Layout
import Route exposing (Location(..))
import Msg exposing (Msg)


defaultHeader : String -> List (Html Msg)
defaultHeader headerText =
    [ Layout.row
        []
        [ Layout.title [] [ text headerText ]
        ]
    ]


defaultHeaderWithNavigation : String -> List (Html Msg) -> List (Html Msg)
defaultHeaderWithNavigation headerText navigation =
    [ Layout.row
        []
        [ Layout.title [] [ text headerText ]
        , Layout.spacer
        , Layout.navigation []
            navigation
        ]
    ]


defaultHeaderWithGitHubLink : String -> List (Html Msg)
defaultHeaderWithGitHubLink headerText =
    defaultHeaderWithNavigation
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
