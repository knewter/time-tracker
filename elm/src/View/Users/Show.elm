module View.Users.Show exposing (view, header)

import Model exposing (Model)
import Types exposing (User)
import Msg exposing (Msg(..), UserMsg(..))
import Html exposing (Html, text, h2, div, a, span)
import Html.Attributes exposing (href)
import Route exposing (Location(..))
import View.Helpers as Helpers
import Material.Layout as Layout


view : Model -> Int -> Html Msg
view model id =
    case model.shownUser of
        Nothing ->
            text "No user here, sorry bud."

        Just user ->
            text "so we will show non-name info here once it exists oops"


header : Model -> Int -> List (Html Msg)
header model id =
    case model.shownUser of
        Nothing ->
            Helpers.defaultHeader model "No such user"

        Just user ->
            let
                links =
                    [ { route = EditUser id, linkText = "Edit" }
                    , { route = Users, linkText = "Users" }
                    ]
            in
                Helpers.defaultHeaderWithNavigation model
                    user.name
                    (List.map
                        (\{ route, linkText } ->
                            Layout.link
                                [ Layout.href <| Route.urlFor route ]
                                [ span [] [ text linkText ] ]
                        )
                        links
                    )
