module View.Home exposing (view)

import Model exposing (Model)
import Msg exposing (Msg(..))
import Html exposing (Html, text, div, span)
import Material.Grid exposing (grid, size, cell, Device(..))
import Material.Elevation as Elevation
import Material.Card as Card
import Material.Options as Options exposing (when)
import View.Charts
import Date exposing (Date)


view : Model -> Html Msg
view model =
    grid []
        [ cell [ size All 12 ]
            [ viewActivitySummary model
            ]
        , cell [ size All 6 ]
            [ viewWordCloud model ]
        , cell [ size All 6 ]
            [ viewNewMembers model ]
        ]


viewActivitySummary : Model -> Html a
viewActivitySummary model =
    [ Card.text []
        [ View.Charts.activity ( 800, 200 ) model.chartData
        ]
    ]
        |> viewGridCard


viewWordCloud : Model -> Html a
viewWordCloud model =
    [ Card.text []
        [ text "Imagine a word cloud here"
        ]
    ]
        |> viewGridCard


viewNewMembers : Model -> Html a
viewNewMembers model =
    [ Card.text []
        [ text "Imagine a list of new members here"
        ]
    ]
        |> viewGridCard


viewGridCard : List (Card.Block a) -> Html a
viewGridCard contents =
    Card.view
        [ Options.css "width" "100%"
        , Elevation.e2
        ]
        contents
