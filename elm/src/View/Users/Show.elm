module View.Users.Show exposing (view, header)

import Model exposing (Model)
import Types exposing (User)
import Msg exposing (Msg(..), UserMsg(..))
import Html exposing (Html, text, h2, div, a, span)
import Html.Attributes exposing (href, style, src)
import Route exposing (Location(..))
import View.Helpers as Helpers
import Material.Layout as Layout
import Material.Card as Card
import Material.Elevation as Elevation
import Material.Tabs as Tabs
import Material.Options as Options
import Material.Icon as Icon
import Material.Color as Color
import Material.Grid exposing (grid, size, cell, Device(..))


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


iconText : String -> String -> Html Msg
iconText icon content =
    div []
        [ Icon.view
            icon
            [ Options.css "vertical-align" "middle", Options.css "margin-right" "0.25em" ]
        , span
            [ style [ ( "vertical-align", "middle" ) ] ]
            [ text content ]
        ]


detailsCard : Model -> User -> Html Msg
detailsCard model user =
    let
        stats : List (Html Msg) -> Html Msg
        stats =
            div [ style [ ( "display", "flex" ), ( "flex-direction", "row" ), ( "justify-content", "space-around" ) ] ]

        avatarUrl : String
        avatarUrl =
            "https://api.adorable.io/avatars/100/" ++ user.name ++ ".png"
    in
        Card.view
            [ Elevation.e2
            , Options.css "width" "100%"
            , Options.css "overflow" "visible"
            , Options.css "margin-top" "66px"
            ]
            [ Card.title
                [ Options.css "background-color" "#202736"
                , Options.css "align-items" "center"
                ]
                [ Options.img
                    [ Elevation.e4
                    , Options.css "border-radius" "50%"
                    , Options.css "position" "relative"
                    , Options.css "top" "-66px"
                    , Options.css "margin-bottom" "-33px"
                    ]
                    [ src avatarUrl ]
                  -- We can't use the Card.head function here because we can't
                  -- successfully set the `align-self` property to center in this
                  -- release of elm-mdl, sadly - I'd expect not to need this hack
                  -- in the future.
                , Options.styled Html.h1
                    [ Options.cs "mdl-card__title-text"
                    , Options.css "align-self" "center"
                    , Options.css "color" "#ffffff"
                    ]
                    [ text user.name ]
                , Card.subhead [ Options.css "color" "#ffffff" ] [ text "IT Staff" ]
                ]
            , Card.text [ Options.css "width" "calc(100% - 32px)" ]
                [ stats
                    [ iconText "email" "user@example.com"
                    , iconText "history" "3h 28m"
                    , iconText "access_time" "57h 12m"
                    , iconText "assignment_turned_in" "Projects: 20"
                    , iconText "assessment" "Open Tasks: 8"
                    ]
                ]
            , Card.actions
                [ Options.css "padding" "0" ]
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


infoPanel : String -> String -> List (Html Msg) -> Html Msg
infoPanel icon title content =
    Card.view
        [ Elevation.e2
        , Options.css "width" "100%"
        , Options.css "margin-top" "2em"
        ]
        [ Card.title
            [ Color.background Color.primary
            , Color.text Color.white
            ]
            [ iconText icon title
            ]
        , Card.text [] content
        ]


info : String -> String -> List (Html Msg) -> Html Msg
info icon title content =
    div
        [ style [ ( "padding", "1em" ) ] ]
        [ span
            [ style [ ( "font-weight", "600" ) ] ]
            [ iconText icon title ]
        , div
            [ style [ ( "margin-left", "2em" ) ] ]
            content
        ]


twoColumns : List (Html Msg) -> List (Html Msg) -> Html Msg
twoColumns left right =
    grid []
        [ cell [ size All 6 ] left
        , cell [ size All 6 ] right
        ]


generalInfo : Model -> User -> Html Msg
generalInfo model user =
    infoPanel "info" "General Information" <|
        [ twoColumns
            [ info "date_range"
                "Date of Admission"
                [ text "March 24th, 2016" ]
            , info "person"
                "Full Name"
                [ text user.name ]
            , info "person_outline"
                "Username"
                [ text "Kyle_89" ]
            ]
            [ info "email"
                "Email"
                [ text "user@example.com" ]
            , info "schedule"
                "Time Zone"
                [ text "UTC-4" ]
            ]
        ]


paymentInfo : Model -> User -> Html Msg
paymentInfo model user =
    infoPanel "credit_card"
        "Payment Information"
        [ twoColumns
            [ info "date_range"
                "Salary"
                [ text "$2,000" ]
            , info "schedule"
                "Hourly Rate"
                [ text "*******" ]
            , info "credit_card"
                "Payment Method"
                [ text "*******" ]
            ]
            [ info "attach_money"
                "Earned so far in the month"
                [ text "*******" ]
            , info "check_circle"
                "Benefits"
                [ div [] [ text "*******" ]
                , div [] [ text "*******" ]
                , div [] [ text "*******" ]
                ]
            ]
        ]


jobInfo : Model -> User -> Html Msg
jobInfo model user =
    infoPanel "work"
        "Job Information"
        [ twoColumns
            [ info "date_range"
                "Position"
                [ text "IT Staff" ]
            , info "supervisor_account"
                "Supervisor"
                [ text "Ryan Wavers" ]
            , info "trending_up"
                "Productivity"
                [ text "75%" ]
            ]
            [ info "schedule"
                "Hours of Work per week"
                [ text "40" ]
            , info "work"
                "Job Description"
                [ text "Ut non cum consequat condimentum nam vel facilisis tempor blandit eu dis a tempor himenaeos vivamus vestibulum metus cursus ullamcorper. Sociis amet a pharetra at placerat gravida dictum ac egestas dignissim dis vestibulum at a a montes a vestibulum vestibulum aliquet."
                ]
            ]
        ]


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
