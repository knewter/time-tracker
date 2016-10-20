module View.Users exposing (view, header)

import Model exposing (Model)
import Types exposing (User, UserSortableField(..), Sorted(..), UsersListView(..), Paginated)
import Msg exposing (Msg(..), UserMsg(..))
import Route exposing (Location(..))
import Html exposing (Html, text, div, a, img, span, h3, ul, li)
import Html.Attributes exposing (href, src, style, colspan, class)
import Html.Events exposing (onClick)
import Material.List as List
import Material.Button as Button
import Material.Icon as Icon
import Material.Table as Table
import Material.Card as Card
import Material.Elevation as Elevation
import Material.Color as Color
import Material.Options as Options
import Material.Layout as Layout
import Material.Grid exposing (grid, size, cell, Device(..))
import View.Helpers as Helpers
import View.Pieces.PaginatedTable as PaginatedTable
import Util
import RemoteData exposing (RemoteData(..))


view : Model -> Html Msg
view model =
    let
        body =
            case model.usersModel.usersListView of
                UsersTable ->
                    usersTable model

                UsersCards ->
                    usersCards model
    in
        div [] [ body ]


usersCards : Model -> Html Msg
usersCards model =
    case model.usersModel.users of
        NotAsked ->
            text "Initialising..."

        Loading ->
            text "Loading..."

        Failure err ->
            text <| "There was a problem fetching the users: " ++ toString err

        Success paginatedUsers ->
            grid [] <|
                List.map
                    (\user -> cell [ size All 3 ] [ userCard user ])
                    paginatedUsers.items


userCard : User -> Html Msg
userCard user =
    let
        userPhotoUrl =
            "https://api.adorable.io/avatars/400/" ++ user.name ++ ".png"
    in
        Card.view
            [ Options.css "width" "100%"
            , Options.css "cursor" "pointer"
            , Options.attribute <| onClick <| NavigateTo <| Maybe.map ShowUser user.id
            , Elevation.e2
            ]
            [ Card.title
                [ Options.css "background" ("url('" ++ userPhotoUrl ++ "') center / cover")
                , Options.css "min-height" "250px"
                , Options.css "padding" "0"
                ]
                []
            , Card.text []
                [ h3 [] [ text user.name ]
                , text "Software Zealot"
                ]
            ]


usersTable : Model -> Html Msg
usersTable model =
    case model.usersModel.users of
        NotAsked ->
            text "Initialising..."

        Loading ->
            text "Loading..."

        Failure err ->
            text <| "There was a problem fetching the users: " ++ toString err

        Success paginatedUsers ->
            div []
                [ Table.table
                    [ Options.css "width" "100%"
                    , Elevation.e2
                    ]
                    [ Table.thead []
                        [ Table.th [] []
                        , Table.th
                            (thOptions UserName model)
                            [ text "Name" ]
                        , Table.th [] [ text "Position" ]
                        , Table.th [] [ text "Email" ]
                        , Table.th [] [ text "Today" ]
                        , Table.th [] [ text "Last 7 days" ]
                        , Table.th [] [ text "Projects" ]
                        , Table.th [] [ text "Open Tasks" ]
                        , Table.th [] [ text "Actions" ]
                        ]
                    , Table.tbody []
                        (List.indexedMap (viewUserRow model) paginatedUsers.items)
                    , Table.tfoot []
                        [ Html.td [ colspan 999, class "mdl-data-table__cell--non-numeric" ]
                            [ PaginatedTable.paginationData [ 0, 3 ] (UserMsg' << FetchUsers) model paginatedUsers ]
                        ]
                    ]
                ]


viewUserRow : Model -> Int -> User -> Html Msg
viewUserRow model index user =
    let
        attributes =
            case user.id of
                Nothing ->
                    []

                Just id ->
                    [ href (Route.urlFor (ShowUser id)) ]
    in
        Table.tr []
            [ Table.td []
                [ img
                    [ src ("https://api.adorable.io/avatars/30/" ++ user.name ++ ".png"), style [ ( "border-radius", "50%" ) ] ]
                    []
                ]
            , Table.td [] [ a attributes [ text user.name ] ]
            , Table.td [] [ text "Monkey" ]
            , Table.td [] [ text "monkey@example.com" ]
            , Table.td [] [ text "3h 28m" ]
            , Table.td [] [ text "57h 12m" ]
            , Table.td [] [ text "20" ]
            , Table.td [] [ text "8" ]
            , Table.td []
                [ editButton model index user
                , deleteButton model index user
                ]
            ]


addUserButton : Model -> Html Msg
addUserButton model =
    Button.render Mdl
        [ 0, 0 ]
        model.mdl
        [ Options.css "position" "fixed"
        , Options.css "display" "block"
        , Options.css "right" "0"
        , Options.css "top" "0"
        , Options.css "margin-right" "35px"
        , Options.css "margin-top" "35px"
        , Options.css "z-index" "900"
        , Button.fab
        , Button.colored
        , Button.ripple
        , Button.onClick <| NavigateTo <| Just NewUser
        ]
        [ Icon.i "add" ]


deleteButton : Model -> Int -> User -> Html Msg
deleteButton model index user =
    Button.render Mdl
        [ 0, 1, index ]
        model.mdl
        [ Button.minifab
        , Button.colored
        , Button.ripple
        , Button.onClick <| UserMsg' <| DeleteUser user
        ]
        [ Icon.i "delete" ]


editButton : Model -> Int -> User -> Html Msg
editButton model index user =
    case user.id of
        Nothing ->
            text ""

        Just id ->
            Button.render Mdl
                [ 0, 2, index ]
                model.mdl
                [ Button.minifab
                , Button.colored
                , Button.ripple
                , Button.onClick <| NavigateTo <| Just <| EditUser id
                ]
                [ Icon.i "edit" ]


thOptions : UserSortableField -> Model -> List (Options.Property (Util.MaterialTableHeader Msg) Msg)
thOptions sortableField model =
    [ Table.onClick <| UserMsg' <| ReorderUsers sortableField
    , Options.css "cursor" "pointer"
    ]
        ++ case model.usersModel.usersSort of
            Nothing ->
                []

            Just ( sorted, sortedField ) ->
                case sortedField == sortableField of
                    True ->
                        case sorted of
                            Ascending ->
                                [ Table.sorted Table.Ascending ]

                            Descending ->
                                [ Table.sorted Table.Descending ]

                    False ->
                        []


header : Model -> List (Html Msg)
header model =
    Helpers.defaultHeaderWithNavigation model
        "Users"
        [ switchViewButton model
        , addUserButton model
        ]


switchViewButton : Model -> Html Msg
switchViewButton model =
    let
        ( msg, icon ) =
            case model.usersModel.usersListView of
                UsersTable ->
                    ( SwitchUsersListView UsersCards, "insert_photo" )

                UsersCards ->
                    ( SwitchUsersListView UsersTable, "list" )
    in
        Button.render Mdl
            [ 0, 3 ]
            model.mdl
            [ Button.icon
            , Button.ripple
            , Button.onClick <| UserMsg' msg
            , Options.css "margin-right" "6rem"
            ]
            [ Icon.i icon ]
