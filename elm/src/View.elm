module View exposing (view)

import Html exposing (Html, text, div, span)
import Html.Attributes exposing (style)
import Html.App as App
import Model exposing (Model)
import Msg exposing (Msg(..))
import Material.Scheme
import Material.Layout as Layout
import Material.Snackbar as Snackbar
import Material.Color as Color


view : Model -> Html Msg
view model =
    Material.Scheme.topWithScheme Color.BlueGrey Color.Cyan <|
        Layout.render Mdl
            model.mdl
            [ Layout.fixedHeader
            , Layout.fixedDrawer
            ]
            { header = [ viewHeader model ]
            , drawer = [ viewDrawer model ]
            , tabs = ( [], [] )
            , main =
                [ div
                    [ style [ ( "padding", "1rem" ) ] ]
                    [ viewBody model
                    , Snackbar.view model.snackbar |> App.map Snackbar
                    ]
                ]
            }


viewHeader : Model -> Html Msg
viewHeader model =
    Layout.row
        []
        [ Layout.title [] [ text "Time Tracker" ]
        , Layout.spacer
        , Layout.navigation []
            [ Layout.link
                [ Layout.href "https://github.com/knewter/time-tracker" ]
                [ span [] [ text "github" ] ]
            ]
        ]


viewDrawer : Model -> Html Msg
viewDrawer model =
    text "drawer contents here"


viewBody : Model -> Html Msg
viewBody model =
    text "body contents here"
