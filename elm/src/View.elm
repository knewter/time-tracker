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
import View.Login
import View.Home
import View.Users
import View.Users.New
import View.Users.Show
import View.Users.Edit
import View.Projects
import View.Projects.New
import View.Projects.Show
import View.Projects.Edit
import View.Organizations
import View.Organizations.New
import View.Organizations.Show
import View.Organizations.Edit
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
            , drawer = drawer model
            , tabs = ( [], [] )
            , main =
                [ div
                    [ style [ ( "padding", "1rem" ) ] ]
                    [ body model
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

        Just (ShowProject id) ->
            View.Projects.Show.header model id

        Just (EditProject id) ->
            View.Projects.Edit.header model id

        Just Projects ->
            View.Projects.header model

        Just (ShowOrganization id) ->
            View.Organizations.Show.header model id

        Just (EditOrganization id) ->
            View.Organizations.Edit.header model id

        Just Organizations ->
            View.Organizations.header model

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
    , { text = "Organizations", iconName = "store", route = Just Organizations }
    , { text = "Projects", iconName = "view_list", route = Just Projects }
    ]


drawer : Model -> List (Html Msg)
drawer model =
    [ Layout.title []
        [ text "Time Tracker" ]
    , Layout.navigation
        [ Options.css "flex-grow" "1" ]
        (List.map (drawerMenuItem model) menuItems)
    ]


drawerMenuItem : Model -> MenuItem -> Html Msg
drawerMenuItem model menuItem =
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


body : Model -> Html Msg
body model =
    let
        _ =
            Debug.log "model: " model
    in
        case model.route of
            Just (Route.Login) ->
                View.Login.view model

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

            Just (Route.Projects) ->
                View.Projects.view model

            Just (Route.NewProject) ->
                View.Projects.New.view model

            Just (Route.ShowProject id) ->
                View.Projects.Show.view model id

            Just (Route.EditProject id) ->
                View.Projects.Edit.view model id

            Just (Route.Organizations) ->
                View.Organizations.view model

            Just (Route.NewOrganization) ->
                View.Organizations.New.view model

            Just (Route.ShowOrganization id) ->
                View.Organizations.Show.view model id

            Just (Route.EditOrganization id) ->
                View.Organizations.Edit.view model id

            Nothing ->
                text "404"
