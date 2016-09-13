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


type DayActivity
    = DayActivity Date.Date Int


type Hue
    = H0
    | H1
    | H2
    | H3
    | H4
    | H5


type Box
    = Box Hue Metadata


type alias Metadata =
    { text : String
    }


type WeekActivity
    = WeekActivity DayActivity DayActivity DayActivity DayActivity DayActivity DayActivity DayActivity


view : Html Msg
view =
    div [] <| List.map viewWeek mockWeeks


viewWeek : WeekActivity -> Html Msg
viewWeek (WeekActivity d1 d2 d3 d4 d5 d6 d7) =
    div [ style [ ( "display", "inline-block" ) ] ]
        [ viewDay d1
        , viewDay d2
        , viewDay d3
        , viewDay d4
        , viewDay d5
        , viewDay d6
        , viewDay d7
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


viewDay : DayActivity -> Html Msg
viewDay dayActivity =
    viewBox (toBox dayActivity)


toBox : DayActivity -> Box
toBox (DayActivity date count) =
    let
        boxHue =
            hue count

        titleText =
            (toString count) ++ " drips consumed on " ++ (toString date)
    in
        Box boxHue { text = titleText }


viewBox : Box -> Html Msg
viewBox (Box boxHue { text }) =
    div
        [ title text
        , style <|
            (hueColor boxHue)
                :: [ ( "width", "14px" )
                   , ( "height", "14px" )
                   , ( "margin-right", "2px" )
                   , ( "margin-bottom", "2px" )
                   ]
        ]
        []


hue : Int -> Hue
hue count =
    let
        step =
            1
    in
        case count // step of
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



-- MOCK DATA


mockWeeks : List WeekActivity
mockWeeks =
    let
        w1d1 =
            DayActivity (Date.fromCalendarDate 2016 Jul 1) 3

        w1d2 =
            DayActivity (Date.fromCalendarDate 2016 Jul 2) 4

        w1d3 =
            DayActivity (Date.fromCalendarDate 2016 Jul 3) 0

        w1d4 =
            DayActivity (Date.fromCalendarDate 2016 Jul 4) 2

        w1d5 =
            DayActivity (Date.fromCalendarDate 2016 Jul 5) 3

        w1d6 =
            DayActivity (Date.fromCalendarDate 2016 Jul 6) 8

        w1d7 =
            DayActivity (Date.fromCalendarDate 2016 Jul 7) 1

        w2d1 =
            DayActivity (Date.fromCalendarDate 2016 Jul 8) 1

        w2d2 =
            DayActivity (Date.fromCalendarDate 2016 Jul 9) 2

        w2d3 =
            DayActivity (Date.fromCalendarDate 2016 Jul 10) 9

        w2d4 =
            DayActivity (Date.fromCalendarDate 2016 Jul 11) 4

        w2d5 =
            DayActivity (Date.fromCalendarDate 2016 Jul 12) 5

        w2d6 =
            DayActivity (Date.fromCalendarDate 2016 Jul 13) 0

        w2d7 =
            DayActivity (Date.fromCalendarDate 2016 Jul 14) 0

        w3d1 =
            DayActivity (Date.fromCalendarDate 2016 Jul 15) 0

        w3d2 =
            DayActivity (Date.fromCalendarDate 2016 Jul 16) 0

        w3d3 =
            DayActivity (Date.fromCalendarDate 2016 Jul 17) 3

        w3d4 =
            DayActivity (Date.fromCalendarDate 2016 Jul 18) 2

        w3d5 =
            DayActivity (Date.fromCalendarDate 2016 Jul 19) 1

        w3d6 =
            DayActivity (Date.fromCalendarDate 2016 Jul 20) 2

        w3d7 =
            DayActivity (Date.fromCalendarDate 2016 Jul 21) 5
    in
        [ WeekActivity w1d1 w1d2 w1d3 w1d4 w1d5 w1d6 w1d7
        , WeekActivity w2d1 w2d2 w2d3 w2d4 w2d5 w2d6 w2d7
        , WeekActivity w3d1 w3d2 w3d3 w3d4 w3d5 w3d6 w3d7
        ]
