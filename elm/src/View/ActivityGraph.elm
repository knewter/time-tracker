module View.ActivityGraph exposing (view)

import Msg exposing (Msg(..))
import Html exposing (Html, text, h2, div, a, span)
import Html.Attributes exposing (href, style)


-- a box per day
-- 7 boxes in a column
-- a column per week ^^
-- hues for the boxes (0..10)


type Hue
    = H0
    | H1
    | H2
    | H3
    | H4
    | H5


type Box
    = Box Hue


type Week
    = Week Box Box Box Box Box Box Box


mockWeek : Hue -> Hue -> Hue -> Hue -> Hue -> Hue -> Hue -> Week
mockWeek h1 h2 h3 h4 h5 h6 h7 =
    Week
        (Box h1)
        (Box h2)
        (Box h3)
        (Box h4)
        (Box h5)
        (Box h6)
        (Box h7)


mockWeeks : List Week
mockWeeks =
    [ mockWeek H1 H2 H4 H0 H1 H3 H2
    , mockWeek H3 H2 H3 H3 H2 H3 H1
    , mockWeek H2 H3 H3 H2 H0 H1 H2
    ]


view : Html Msg
view =
    div [] <| List.map viewWeek mockWeeks


viewWeek : Week -> Html Msg
viewWeek (Week b1 b2 b3 b4 b5 b6 b7) =
    div [ style [ ( "display", "inline-block" ) ] ]
        [ viewBox b1
        , viewBox b2
        , viewBox b3
        , viewBox b4
        , viewBox b5
        , viewBox b6
        , viewBox b7
        ]


boxBackgroundColor : Box -> ( String, String )
boxBackgroundColor box =
    let
        bg =
            case box of
                Box H0 ->
                    "rgba(255, 0, 0, 0)"

                Box H1 ->
                    "rgba(255, 0, 0, 0.1)"

                Box H2 ->
                    "rgba(255, 0, 0, 0.2)"

                Box H3 ->
                    "rgba(255, 0, 0, 0.3)"

                Box H4 ->
                    "rgba(255, 0, 0, 0.4)"

                Box H5 ->
                    "rgba(255, 0, 0, 0.5)"
    in
        ( "background-color", bg )


viewBox : Box -> Html Msg
viewBox box =
    div
        [ style <|
            (boxBackgroundColor box)
                :: [ ( "width", "1rem" )
                   , ( "height", "1rem" )
                   , ( "margin-right", "0.1rem" )
                   , ( "margin-bottom", "0.1rem" )
                   ]
        ]
        []
