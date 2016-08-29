module View.Projects.Edit exposing (view, header)

import Model exposing (Model)
import Types exposing (Project)
import Msg exposing (Msg(..))
import Html exposing (Html, text, h2, div, a, span)
import Html.Attributes exposing (href)
import Material.Button as Button
import Material.Textfield as Textfield
import Material.Options as Options
import Material.Grid exposing (grid, size, cell, Device(..))
import Route exposing (Location(..))
import Material.Layout as Layout
import View.Helpers as Helpers


view : Model -> Int -> Html Msg
view model id =
    case model.shownProject of
        Nothing ->
            text "No project here, sorry bud."

        Just project ->
            grid []
                [ cell [ size All 12 ]
                    [ nameField model ]
                , cell [ size All 12 ]
                    [ submitButton model
                    , cancelButton model
                    ]
                ]


nameField : Model -> Html Msg
nameField model =
    Textfield.render Mdl
        [ 2, 0 ]
        model.mdl
        [ Textfield.label "Name"
        , Textfield.floatingLabel
        , Textfield.text'
        , Textfield.value <| Maybe.withDefault "" <| Maybe.map .name model.shownProject
        , Textfield.onInput SetShownProjectName
        ]


submitButton : Model -> Html Msg
submitButton model =
    Button.render Mdl
        [ 2, 1 ]
        model.mdl
        [ Button.raised
        , Button.ripple
        , Button.colored
        , Button.onClick UpdateShownProject
        ]
        [ text "Submit" ]


cancelButton : Model -> Html Msg
cancelButton model =
    Button.render Mdl
        [ 2, 2 ]
        model.mdl
        [ Button.ripple
        , Button.onClick <| NavigateTo <| Just Projects
        , Options.css "margin-left" "1rem"
        ]
        [ text "Cancel" ]


header : Model -> Int -> List (Html Msg)
header model id =
    case model.shownProject of
        Nothing ->
            Helpers.defaultHeader model "No such project"

        Just project ->
            let
                links =
                    [ { route = ShowProject id, linkText = "Show" }
                    , { route = Projects, linkText = "Projects" }
                    ]
            in
                Helpers.defaultHeaderWithNavigation model
                    ("Edit " ++ project.name)
                    (List.map
                        (\{ route, linkText } ->
                            Layout.link
                                [ Layout.href <| Route.urlFor route ]
                                [ span [] [ text linkText ] ]
                        )
                        links
                    )
