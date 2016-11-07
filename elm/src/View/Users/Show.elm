module View.Users.Show exposing (view, header)

import Model exposing (Model)
import Types exposing (User)
import Msg exposing (Msg(..), UserMsg(..))
import Html exposing (Html, text, h2, div, a, span)
import Html.Attributes exposing (href, style)
import Route exposing (Location(..))
import View.Helpers as Helpers
import Material.Layout as Layout
import Material.Card as Card
import Material.Elevation as Elevation
import Material.Tabs as Tabs
import Material.Options as Options
import Material.Icon as Icon


view : Model -> Int -> Html Msg
view model id =
    case model.usersModel.shownUser of
        Nothing ->
            text "No user here, sorry bud."

        Just user ->
            showUser model user


showUser : Model -> User -> Html Msg
showUser model user =
    div [ style [ ( "width", "80%" ), ( "margin", "0 auto" ) ] ]
        [ detailsCard model user
        , information model user
        ]


detailsCard : Model -> User -> Html Msg
detailsCard model user =
    let
        stats : List (Html Msg) -> Html Msg
        stats =
            div [ style [ ( "display", "flex" ), ( "flex-direction", "row" ), ( "justify-content", "space-around" ) ] ]

        stat : String -> String -> Html Msg
        stat icon content =
            div []
                [ Icon.view
                    icon
                    [ Options.css "vertical-align" "middle", Options.css "margin-right" "0.25em" ]
                , span
                    [ style [ ( "vertical-align", "middle" ) ] ]
                    [ text content ]
                ]
    in
        Card.view
            [ Elevation.e2
            , Options.css "width" "100%"
            ]
            [ Card.title
                [ Options.css "background-color" "#202736"
                , Options.css "align-items" "center"
                ]
                -- We can't use the Card.head function here because we can't
                -- successfully set the `align-self` property to center in this
                -- release of elm-mdl, sadly - I'd expect not to need this hack
                -- in the future.
                [ Options.styled Html.h1
                    [ Options.cs "mdl-card__title-text"
                    , Options.css "align-self" "center"
                    , Options.css "color" "#ffffff"
                    , Options.css "margin-top" "3em"
                    ]
                    [ text user.name ]
                , Card.subhead [ Options.css "color" "#ffffff" ] [ text "IT Staff" ]
                ]
            , Card.text [ Options.css "width" "calc(100% - 32px)" ]
                [ stats
                    [ stat "email" "user@example.com"
                    , stat "history" "3h 28m"
                    , stat "access_time" "57h 12m"
                    , stat "assignment_turned_in" "Projects: 20"
                    , stat "assessment" "Open Tasks: 8"
                    ]
                ]
            , Card.actions []
                [ Tabs.render Mdl
                    [ 10, 0 ]
                    model.mdl
                    [ Tabs.ripple
                    , Tabs.activeTab 3
                    , Options.css "cursor" "pointer"
                    ]
                    [ Tabs.textLabel [] "TIMELINE"
                    , Tabs.textLabel [] "CONNECTIONS"
                    , Tabs.textLabel [] "PROJECTS"
                    , Tabs.textLabel [] "INFORMATION"
                    ]
                    []
                ]
            ]


information : Model -> User -> Html Msg
information model user =
    div []
        [ generalInfo model user
        , paymentInfo model user
        , jobInfo model user
        ]


generalInfo : Model -> User -> Html Msg
generalInfo model user =
    div [] [ text "general info" ]


paymentInfo : Model -> User -> Html Msg
paymentInfo model user =
    div [] [ text "payment info" ]


jobInfo : Model -> User -> Html Msg
jobInfo model user =
    div [] [ text "job info" ]


header : Model -> Int -> List (Html Msg)
header model id =
    case model.usersModel.shownUser of
        Nothing ->
            Helpers.defaultHeader "No such user"

        Just user ->
            let
                links =
                    [ { route = EditUser id, linkText = "Edit" }
                    , { route = Users, linkText = "Users" }
                    ]
            in
                Helpers.defaultHeaderWithNavigation
                    user.name
                    (List.map
                        (\{ route, linkText } ->
                            Layout.link
                                [ Layout.href <| Route.urlFor route ]
                                [ span [] [ text linkText ] ]
                        )
                        links
                    )
