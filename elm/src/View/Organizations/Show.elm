module View.Organizations.Show exposing (view, header)

import Model exposing (Model)
import Types exposing (Organization)
import Msg exposing (Msg(..))
import Html exposing (Html, text, h2, div, a, span)
import Html.Attributes exposing (href)
import Route exposing (Location(..))
import View.Helpers as Helpers
import Material.Layout as Layout


view : Model -> Int -> Html Msg
view model id =
    case model.shownOrganization of
        Nothing ->
            text "No organization here, sorry bud."

        Just organization ->
            text "so we will show non-name info here once it exists oops"


header : Model -> Int -> List (Html Msg)
header model id =
    case model.shownOrganization of
        Nothing ->
            Helpers.defaultHeader model "No such organization"

        Just organization ->
            let
                links =
                    [ { route = EditOrganization id, linkText = "Edit" }
                    , { route = Organizations, linkText = "Organizations" }
                    ]
            in
                Helpers.defaultHeaderWithNavigation model
                    organization.name
                    (List.map
                        (\{ route, linkText } ->
                            Layout.link
                                [ Layout.href <| Route.urlFor route ]
                                [ span [] [ text linkText ] ]
                        )
                        links
                    )
