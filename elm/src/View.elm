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
import Route exposing (Location(..))
import View.Home
import View.Users


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
    , { text = "Users", iconName = "group", route = Just Users }
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
        , Color.text Color.accent `when` (model.route == menuItem.route)
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
            View.Home.view model

        Just (Route.Users) ->
            View.Users.view model

        Nothing ->
            text "404"
