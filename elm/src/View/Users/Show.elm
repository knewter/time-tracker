module View.Users.Show exposing (view, header)

import Model exposing (Model, UsersModel)
import Types exposing (User, Project)
import Msg exposing (Msg(..), UserMsg(..))
import Html exposing (Html, text, h2, div, a, span, h3, p)
import Html.Attributes exposing (href, style, src)
import Html.Events exposing (onClick)
import Route exposing (Location(..))
import View.Helpers as Helpers
import Material.Layout as Layout
import Material.Button as Button
import Material.Card as Card
import Material.Elevation as Elevation
import Material.Tabs as Tabs
import Material.Options as Options
import Material.Icon as Icon
import Material.Color as Color exposing (Hue(..), Shade(..))
import Material.Grid exposing (grid, size, cell, Device(..))
import Material.Menu as Menu
import RemoteData exposing (RemoteData(..))
import Types.ActivityStreams exposing (Activity)
import Date


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
        , showTab model user
        ]


showTab : Model -> User -> Html Msg
showTab model user =
    case model.usersModel.userShowTab of
        0 ->
            timeline model user

        1 ->
            connections model user

        2 ->
            projects model user

        3 ->
            information model user

        _ ->
            text "This shouldn't ever happen :("


timeline : Model -> User -> Html Msg
timeline model user =
    div
        [ style
            [ ( "border-left", "3px solid rgba(0, 0, 0, 0.1)" )
            , ( "margin-left", "32px" )
            , ( "padding-left", "64px" )
            , ( "padding-top", "32px" )
            , ( "margin-top", "-32px" )
            ]
        ]
        (List.indexedMap (activityView model user) activities)


activityView : Model -> User -> Int -> Activity -> Html Msg
activityView model user index activity =
    let
        leftLine =
            Html.hr
                [ style
                    [ ( "position", "absolute" )
                    , ( "width", "64px" )
                    , ( "border-width", "3px" )
                    , ( "border-color", "rgba(0, 0, 0, 0.1)" )
                    , ( "top", "22px" )
                    , ( "left", "-64px" )
                    ]
                ]
                []

        typeBadgeColor =
            case activity.type_ of
                "Snippet" ->
                    "#9b769f"

                "Project" ->
                    "#fab03c"

                _ ->
                    "#999"

        typeBadgeIcon =
            case activity.type_ of
                "Snippet" ->
                    Icon.i "code"

                "Project" ->
                    Icon.i "assessment"

                _ ->
                    Icon.i "subject"

        typeBadge =
            div
                [ style
                    [ ( "border-radius", "50%" )
                    , ( "width", "42px" )
                    , ( "height", "42px" )
                    , ( "background-color", "white" )
                    , ( "position", "absolute" )
                    , ( "left", "-95px" )
                    , ( "top", "9px" )
                    , ( "padding", "5px" )
                    , ( "border-style", "solid" )
                    , ( "border-width", "3px" )
                    , ( "border-color", "rgba(0, 0, 0, 0.1)" )
                    ]
                ]
                [ div
                    [ style
                        [ ( "border-radius", "50%" )
                        , ( "width", "100%" )
                        , ( "height", "100%" )
                        , ( "position", "relative" )
                        , ( "background-color", typeBadgeColor )
                        ]
                    ]
                    [ span
                        [ style
                            [ ( "position", "absolute" )
                            , ( "top", "9px" )
                            , ( "left", "9px" )
                            , ( "color", "white" )
                            ]
                        ]
                        [ typeBadgeIcon ]
                    ]
                ]

        timeBadge =
            div
                [ style
                    [ ( "background-color", "#aaa" )
                    , ( "border-radius", "2px" )
                    , ( "color", "white" )
                    , ( "position", "absolute" )
                    , ( "left", "-104px" )
                    , ( "top", "80px" )
                    , ( "width", "80px" )
                    , ( "height", "20px" )
                    , ( "text-align", "center" )
                    ]
                ]
                [ text "8:00 pm" ]
    in
        div
            [ style
                [ ( "margin-bottom", "16px" )
                , ( "position", "relative" )
                ]
            ]
            [ leftLine
            , typeBadge
            , timeBadge
            , activityCard model user index activity
            ]


buttonStat : Model -> List Int -> String -> String -> Html Msg
buttonStat model mdlIndex icon content =
    div
        [ style
            [ ( "display", "inline-block" ) ]
        ]
        [ Button.render Mdl
            mdlIndex
            model.mdl
            [ Button.icon, Button.ripple ]
            [ Icon.i icon ]
        , text content
        ]


activityCard : Model -> User -> Int -> Activity -> Html Msg
activityCard model user index activity =
    Card.view
        [ Options.css "width" "100%"
        , Elevation.e2
        ]
        [ Card.title
            []
            [ div []
                [ Html.img
                    [ src <| avatarUrl 40 user.name
                    , style
                        [ ( "border-radius", "50%" )
                        , ( "display", "inline-block" )
                        , ( "margin-right", "16px" )
                        , ( "vertical-align", "middle" )
                        ]
                    ]
                    []
                , span
                    [ style
                        [ ( "vertical-align", "middle" ) ]
                    ]
                    [ text activity.name ]
                ]
            ]
        , Card.text
            [ Options.css "width" "calc(100% - 32px)"
            , Options.css "background-color" "#9b769f"
            , Options.css "min-height" "100px"
            , Options.css "padding" "16px"
            ]
            [ div []
                [ h3
                    [ style
                        [ ( "margin-top", "0" ) ]
                    ]
                    [ text activity.type_ ]
                ]
            ]
        , Card.actions
            [ Options.css "text-align" "right"
            , Color.text <| Color.color Grey S500
            ]
            [ buttonStat model [ 10, 2, 0, index ] "favorite_border" "4"
            , buttonStat model [ 10, 2, 1, index ] "share" "2"
            , buttonStat model [ 10, 2, 2, index ] "message" "3"
            ]
        , Card.menu []
            [ Menu.render Mdl
                [ 10, 2, 3, index ]
                model.mdl
                [ Menu.bottomRight
                , Menu.ripple
                ]
                [ Menu.item []
                    [ text "Action 1" ]
                , Menu.item []
                    [ text "Action 2" ]
                ]
            ]
        ]


connections : Model -> User -> Html Msg
connections model user =
    usersCards model


projects : Model -> User -> Html Msg
projects model user =
    projectsCards model


projectsCards : Model -> Html Msg
projectsCards model =
    case model.projectsModel.projects.current of
        NotAsked ->
            text "Initialising..."

        Loading ->
            text "Loading..."

        Failure err ->
            text <| "There was a problem fetching the projecs: " ++ toString err

        Success paginatedProjects ->
            grid [] <|
                List.indexedMap
                    (\index project ->
                        cell
                            [ size Desktop 3
                            , size Tablet 4
                            , size Desktop 3
                            ]
                            [ projectCard model project index ]
                    )
                    paginatedProjects.items


projectCard : Model -> Project -> Int -> Html Msg
projectCard model project index =
    Card.view
        [ Options.css "width" "100%"
        , Options.css "cursor" "pointer"
        , Options.attribute <| onClick <| NavigateTo <| Maybe.map ShowProject project.id
        , Elevation.e2
        ]
        [ Card.title
            []
            [ Html.img
                [ style
                    [ ( "border-radius", "50%" )
                    , ( "margin", "0 auto" )
                    ]
                , src <| avatarUrl 150 project.name
                ]
                []
            ]
        , Card.text []
            [ h3
                [ style [ ( "margin", "0" ) ] ]
                [ text project.name ]
            , div [] [ text "Start Date:" ]
            , div [] [ text "10/05/2018" ]
            , div [] [ text "Supervisor:" ]
            , div [] [ text "Matthew James" ]
            ]
        , Card.actions
            [ Options.css "text-align" "right"
            , Color.text Color.accent
            ]
            [ Button.render Mdl
                [ 10, 3, 0, index ]
                model.mdl
                [ Button.ripple
                , Color.text Color.accent
                ]
                [ text "Open" ]
            ]
        , Card.menu []
            [ Menu.render Mdl
                [ 10, 3, 1, index ]
                model.mdl
                [ Menu.bottomRight
                , Menu.ripple
                ]
                [ Menu.item []
                    [ text "Action 1" ]
                , Menu.item []
                    [ text "Action 2" ]
                ]
            ]
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


avatarUrl : Int -> String -> String
avatarUrl size key =
    "https://api.adorable.io/avatars/" ++ (toString size) ++ "/" ++ key ++ ".png"


detailsCard : Model -> User -> Html Msg
detailsCard model user =
    let
        stats : List (Html Msg) -> Html Msg
        stats =
            div [ style [ ( "display", "flex" ), ( "flex-direction", "row" ), ( "justify-content", "space-around" ) ] ]
    in
        Card.view
            [ Elevation.e2
            , Options.css "width" "100%"
            , Options.css "overflow" "visible"
            , Options.css "margin-top" "66px"
            , Options.css "margin-bottom" "2em"
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
                    [ src <| avatarUrl 100 user.name ]
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
                    , Tabs.activeTab model.usersModel.userShowTab
                    , Tabs.onSelectTab <| UserMsg' << SelectUserShowTab
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


usersCards : Model -> Html Msg
usersCards model =
    case model.usersModel.users.current of
        NotAsked ->
            text "Initialising..."

        Loading ->
            text "Loading..."

        Failure err ->
            text <| "There was a problem fetching the users: " ++ toString err

        Success paginatedUsers ->
            grid [] <|
                List.map
                    (\user ->
                        cell
                            [ size Desktop 3
                            , size Tablet 4
                            , size Desktop 3
                            ]
                            [ userCard model user ]
                    )
                    paginatedUsers.items


userCard : Model -> User -> Html Msg
userCard model user =
    Card.view
        [ Options.css "width" "100%"
        , Options.css "cursor" "pointer"
        , Options.attribute <| onClick <| NavigateTo <| Maybe.map ShowUser user.id
        , Elevation.e2
        ]
        [ Card.title
            [ Options.css "background" ("url('" ++ (avatarUrl 400 user.name) ++ "') center / cover")
            , Options.css "min-height" "250px"
            , Options.css "padding" "0"
            ]
            []
        , Card.text []
            [ h3
                [ style [ ( "margin", "0" ) ] ]
                [ text user.name ]
            , Options.styled p
                [ Color.text Color.accent ]
                [ text "Software Zealot" ]
            , iconText "email" "user@example.com"
            , iconText "history" "7h 34m"
            , iconText "access_time" "48h 20m"
            ]
        , Card.actions
            [ Options.css "text-align" "right"
            , Color.text Color.accent
            ]
            [ Button.render Mdl
                [ 10, 1, 0 ]
                model.mdl
                [ Button.icon, Button.ripple ]
                [ Icon.i "phone" ]
            , Button.render Mdl
                [ 10, 1, 1 ]
                model.mdl
                [ Button.icon, Button.ripple ]
                [ Icon.i "message" ]
            , Button.render Mdl
                [ 10, 1, 2 ]
                model.mdl
                [ Button.icon, Button.ripple ]
                [ Icon.i "star_border" ]
            ]
        ]


activities : List Activity
activities =
    [ { name = "Kyle Byrne posted a snippet"
      , type_ = "Snippet"
      , actor = "Kyle Byrne"
      , object = "http://localhost:3000/snippets/1"
      , published = Date.fromTime 1478579422
      }
    , { name = "Kyle Byrne shared a project"
      , type_ = "Project"
      , actor = "Kyle Byrne"
      , object = "http://localhost:3000/projects/1"
      , published = Date.fromTime 1478579421
      }
    , { name = "Kyle Byrne shared a project"
      , type_ = "Project"
      , actor = "Kyle Byrne"
      , object = "http://localhost:3000/projects/2"
      , published = Date.fromTime 1478579420
      }
    ]
