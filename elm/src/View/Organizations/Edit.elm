module View.Organizations.Edit exposing (view, header)

import Model exposing (Model)
import Types exposing (Organization)
import Msg exposing (Msg(..), OrganizationMsg(..))
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
    case model.shownOrganization of
        Nothing ->
            text "No organization here, sorry bud."

        Just organization ->
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
        [ 5, 0 ]
        model.mdl
        [ Textfield.label "Name"
        , Textfield.floatingLabel
        , Textfield.text'
        , Textfield.value <| Maybe.withDefault "" <| Maybe.map .name model.shownOrganization
        , Textfield.onInput <| OrganizationMsg' << SetShownOrganizationName
        ]


submitButton : Model -> Html Msg
submitButton model =
    Button.render Mdl
        [ 5, 1 ]
        model.mdl
        [ Button.raised
        , Button.ripple
        , Button.colored
        , Button.onClick <| OrganizationMsg' UpdateOrganization
        ]
        [ text "Submit" ]


cancelButton : Model -> Html Msg
cancelButton model =
    Button.render Mdl
        [ 5, 2 ]
        model.mdl
        [ Button.ripple
        , Button.onClick <| NavigateTo <| Just Organizations
        , Options.css "margin-left" "1rem"
        ]
        [ text "Cancel" ]


header : Model -> Int -> List (Html Msg)
header model id =
    case model.shownOrganization of
        Nothing ->
            Helpers.defaultHeader model "No such organization"

        Just organization ->
            let
                links =
                    [ { route = ShowOrganization id, linkText = "Show" }
                    , { route = Organizations, linkText = "Organizations" }
                    ]
            in
                Helpers.defaultHeaderWithNavigation model
                    ("Edit " ++ organization.name)
                    (List.map
                        (\{ route, linkText } ->
                            Layout.link
                                [ Layout.href <| Route.urlFor route ]
                                [ span [] [ text linkText ] ]
                        )
                        links
                    )
