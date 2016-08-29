module View.Projects.Show exposing (view, header)

import Model exposing (Model)
import Types exposing (Project)
import Msg exposing (Msg(..))
import Html exposing (Html, text, h2, div, a, span)
import Html.Attributes exposing (href)
import Route exposing (Location(..))
import View.Helpers as Helpers
import Material.Layout as Layout


view : Model -> Int -> Html Msg
view model id =
    case model.shownProject of
        Nothing ->
            text "No project here, sorry bud."

        Just project ->
            text "so we will show non-name info here once it exists oops"


header : Model -> Int -> List (Html Msg)
header model id =
    case model.shownProject of
        Nothing ->
            Helpers.defaultHeader model "No such project"

        Just project ->
            let
                links =
                    [ { route = EditProject id, linkText = "Edit" }
                    , { route = Projects, linkText = "Projects" }
                    ]
            in
                Helpers.defaultHeaderWithNavigation model
                    project.name
                    (List.map
                        (\{ route, linkText } ->
                            Layout.link
                                [ Layout.href <| Route.urlFor route ]
                                [ span [] [ text linkText ] ]
                        )
                        links
                    )
