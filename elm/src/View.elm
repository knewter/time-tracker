module View exposing (view)

import Html exposing (Html, text, div, span)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Html.App as App
import Model exposing (Model)
import Msg exposing (Msg(..))
import Material.Scheme
import Material.Layout as Layout
import Material.Snackbar as Snackbar
import Material.Color as Color
import Material.List as List
import Material.Options as Options exposing (when)
import Material.Grid exposing (grid, size, cell, Device(..))
import Material.Card as Card
import Material.Elevation as Elevation
import Route exposing (Location(..))


view : Model -> Html Msg
view model =
    Material.Scheme.topWithScheme Color.BlueGrey Color.LightBlue <|
        Layout.render Mdl
            model.mdl
            [ Layout.fixedHeader
            , Layout.fixedDrawer
            ]
            { header = [ viewHeader model ]
            , drawer = [ viewDrawer model ]
            , tabs = ( [], [] )
            , main =
                [ div
                    [ style [ ( "padding", "1rem" ) ] ]
                    [ viewBody model
                    , Snackbar.view model.snackbar |> App.map Snackbar
                    ]
                ]
            }


viewHeader : Model -> Html Msg
viewHeader model =
    Layout.row
        []
        [ Layout.title [] [ text "Time Tracker" ]
        , Layout.spacer
        , Layout.navigation []
            [ Layout.link
                [ Layout.href "https://github.com/knewter/time-tracker" ]
                [ span [] [ text "github" ] ]
            ]
        ]


type alias MenuItem =
    { text : String
    , iconName : String
    , route : Maybe Route.Location
    }


menuItems : List MenuItem
menuItems =
    [ { text = "Dashboard", iconName = "dashboard", route = Just Home }
    , { text = "Users", iconName = "group", route = Nothing }
    , { text = "Last Activity", iconName = "alarm", route = Nothing }
    , { text = "Timesheets", iconName = "event", route = Nothing }
    , { text = "Reports", iconName = "list", route = Nothing }
    , { text = "Organizations", iconName = "store", route = Nothing }
    , { text = "Project", iconName = "view_list", route = Nothing }
    ]


viewDrawerMenuItem : Model -> MenuItem -> Html Msg
viewDrawerMenuItem model menuItem =
    List.li
        [ Options.css "cursor" "pointer"
        , Options.attribute <| onClick (NavigateTo menuItem.route)
        ]
        [ List.content
            []
            [ List.icon menuItem.iconName []
            , text menuItem.text
            ]
        ]


viewDrawer : Model -> Html Msg
viewDrawer model =
    List.ul
        []
        (List.map (viewDrawerMenuItem model) menuItems)


viewBody : Model -> Html Msg
viewBody model =
    case model.route of
        Just (Route.Home) ->
            viewDashboard model

        Nothing ->
            text "404"


viewDashboard : Model -> Html Msg
viewDashboard model =
    grid []
        [ cell [ size All 12 ]
            [ viewActivitySummary model
            ]
        , cell [ size All 6 ]
            [ viewWordCloud model ]
        , cell [ size All 6 ]
            [ viewNewMembers model ]
        ]


viewGridCard contents =
    Card.view
        [ Options.css "width" "100%"
        , Elevation.e2
        ]
        contents


viewActivitySummary model =
    [ Card.text
        []
        [ text "Imagine an activity summary here"
        ]
    ]
        |> viewGridCard


viewWordCloud model =
    [ Card.text
        []
        [ text "Imagine a word cloud here"
        ]
    ]
        |> viewGridCard


viewNewMembers model =
    [ Card.text
        []
        [ text "Imagine a list of new members here"
        ]
    ]
        |> viewGridCard
