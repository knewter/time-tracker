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
import Material.Icon as Icon
import Material.Options as Options exposing (when)
import Route exposing (Location(..))
import View.Home
import View.Users
import View.Users.New
import View.Users.Show
import View.Users.Edit
import View.Helpers as Helpers


view : Model -> Html Msg
view model =
    Material.Scheme.topWithScheme Color.BlueGrey Color.LightBlue <|
        Layout.render Mdl
            model.mdl
            [ Layout.fixedHeader
            , Layout.fixedDrawer
            ]
            { header = header model
            , drawer = viewDrawer model
            , tabs = ( [], [] )
            , main =
                [ div
                    [ style [ ( "padding", "1rem" ) ] ]
                    [ viewBody model
                    , Snackbar.view model.snackbar |> App.map Snackbar
                    ]
                ]
            }


header : Model -> List (Html Msg)
header model =
    case model.route of
        Just (ShowUser id) ->
            View.Users.Show.header model id

        Just (EditUser id) ->
            View.Users.Edit.header model id

        Just Users ->
            View.Users.header model

        Just Home ->
            Helpers.defaultHeaderWithGitHubLink model "Dashboard"

        Just route ->
            Helpers.defaultHeader model <| Helpers.routeHeaderText route

        Nothing ->
            Helpers.defaultHeader model "Time Tracker"


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


viewDrawer : Model -> List (Html Msg)
viewDrawer model =
    [ Layout.title []
        [ text "Time Tracker" ]
    , Layout.navigation
        [ Options.css "flex-grow" "1" ]
        (List.map (viewDrawerMenuItem model) menuItems)
    ]


viewDrawerMenuItem : Model -> MenuItem -> Html Msg
viewDrawerMenuItem model menuItem =
    Layout.link
        [ Layout.onClick (NavigateTo menuItem.route)
        , (Color.text <| Color.accent) `when` (model.route == menuItem.route)
        , Options.css "font-weight" "500"
        , Options.css "cursor" "pointer"
          -- http://outlinenone.com/ TODO: tl;dr don't do this
          -- Should be using ":focus { outline: 0 }" for this but can't do that with inline styles so this is a hack til I get a proper stylesheet on here.
        , Options.css "outline" "none"
        ]
        [ Icon.view menuItem.iconName
            [ Options.css "margin-right" "32px"
            ]
        , text menuItem.text
        ]


viewBody : Model -> Html Msg
viewBody model =
    let
        _ =
            Debug.log "model: " model
    in
        case model.route of
            Just (Route.Home) ->
                View.Home.view model

            Just (Route.Users) ->
                View.Users.view model

            Just (Route.NewUser) ->
                View.Users.New.view model

            Just (Route.ShowUser id) ->
                View.Users.Show.view model id

            Just (Route.EditUser id) ->
                View.Users.Edit.view model id

            Nothing ->
                text "404"
