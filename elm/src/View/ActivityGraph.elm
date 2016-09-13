module View.ActivityGraph exposing (view)

import Msg exposing (Msg(..))
import Html exposing (Html, text, h2, div, a, span)
import Html.Attributes exposing (href, style, title)
import Date exposing (Month(..), Date)
import Date.Extra as Date


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
    = Box Metadata


type alias Metadata =
    { consumptions : Int
    }


hue : Metadata -> Hue
hue metadata =
    let
        step =
            1
    in
        case metadata.consumptions // step of
            0 ->
                H0

            1 ->
                H1

            2 ->
                H1

            3 ->
                H1

            4 ->
                H1

            _ ->
                H5


type Week
    = Week Box Box Box Box Box Box Box


mockWeek :
    Metadata
    -> Metadata
    -> Metadata
    -> Metadata
    -> Metadata
    -> Metadata
    -> Metadata
    -> Week
mockWeek m1 m2 m3 m4 m5 m6 m7 =
    Week
        (Box m1)
        (Box m2)
        (Box m3)
        (Box m4)
        (Box m5)
        (Box m6)
        (Box m7)


mockWeeks : List Week
mockWeeks =
    let
        w1m1 =
            { consumptions = 3 }

        w1m2 =
            { consumptions = 4 }

        w1m3 =
            { consumptions = 0 }

        w1m4 =
            { consumptions = 2 }

        w1m5 =
            { consumptions = 3 }

        w1m6 =
            { consumptions = 8 }

        w1m7 =
            { consumptions = 1 }

        w2m1 =
            { consumptions = 1 }

        w2m2 =
            { consumptions = 2 }

        w2m3 =
            { consumptions = 9 }

        w2m4 =
            { consumptions = 4 }

        w2m5 =
            { consumptions = 5 }

        w2m6 =
            { consumptions = 0 }

        w2m7 =
            { consumptions = 0 }
    in
        [ mockWeek w1m1 w1m2 w1m3 w1m4 w1m5 w1m6 w1m7
        , mockWeek w2m1 w2m2 w2m3 w2m4 w2m5 w2m6 w2m7
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


hueColor : Hue -> ( String, String )
hueColor boxHue =
    let
        bg =
            case boxHue of
                H0 ->
                    "rgba(0, 0, 0, 0.06)"

                H1 ->
                    "rgba(34, 74, 155, 0.2)"

                H2 ->
                    "rgba(34, 74, 155, 0.3)"

                H3 ->
                    "rgba(34, 74, 155, 0.4)"

                H4 ->
                    "rgba(34, 74, 155, 0.5)"

                H5 ->
                    "rgba(34, 74, 155, 0.6)"
    in
        ( "background-color", bg )


viewBox : Box -> Html Msg
viewBox (Box metadata) =
    let
        boxHue =
            hue metadata

        titleText =
            (toString metadata.consumptions) ++ " drips consumed"
    in
        div
            [ title titleText
            , style <|
                (hueColor boxHue)
                    :: [ ( "width", "14px" )
                       , ( "height", "14px" )
                       , ( "margin-right", "2px" )
                       , ( "margin-bottom", "2px" )
                       ]
            ]
            []
