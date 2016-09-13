module View.ActivityGraph exposing (view)

import Msg exposing (Msg(..))
import Html exposing (Html, text, h2, div, a, span, strong)
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


type alias ActivityBlock =
    List ActivityChunk


type ActivityChunk
    = ActivityChunk String (List WeekActivity)


toActivityBlock : List WeekActivity -> ActivityBlock
toActivityBlock weeks =
    let
        -- Turn the weeks into a 2-tuple with the month name first
        monthedWeeks : List ( String, WeekActivity )
        monthedWeeks =
            List.map (\(WeekActivity (DayActivity date count) d2 d3 d4 d5 d6 d7) -> ( (toString <| Date.month date), (WeekActivity (DayActivity date count) d2 d3 d4 d5 d6 d7) )) weeks

        foldChunks : ( String, WeekActivity ) -> List ActivityChunk -> List ActivityChunk
        foldChunks ( m, week ) acc =
            case List.head acc of
                Nothing ->
                    [ ActivityChunk m [ week ] ]

                Just (ActivityChunk key weeks) ->
                    case key == m of
                        True ->
                            (ActivityChunk key ([ week ] ++ weeks)) :: (List.drop 1 acc)

                        False ->
                            (ActivityChunk m [ week ]) :: acc

        toChunks : List ( String, WeekActivity ) -> List ActivityChunk
        toChunks mWeeks =
            List.foldr foldChunks [] mWeeks
    in
        toChunks monthedWeeks


view : Html Msg
view =
    viewActivityBlock (toActivityBlock mockWeeks)


viewActivityBlock : ActivityBlock -> Html Msg
viewActivityBlock activityBlock =
    div [] <| List.map viewActivityChunk activityBlock


viewActivityChunk : ActivityChunk -> Html Msg
viewActivityChunk (ActivityChunk title weeks) =
    div [ style [ ( "display", "inline-block" ) ] ] <|
        (strong [ style [ ( "display", "block" ) ] ] [ text title ])
            :: (List.map viewWeek weeks)


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
viewDay =
    dayActivityToBox >> viewBox


dayActivityToBox : DayActivity -> Box
dayActivityToBox (DayActivity date count) =
    let
        boxHue =
            hue count

        titleText =
            (toString count) ++ " drips consumed on " ++ (Date.toFormattedString "MMMM d" date)
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


mockDayActivity : Int -> Month -> Int -> Int -> DayActivity
mockDayActivity year month day count =
    DayActivity (Date.fromCalendarDate year month day) count


mockWeeks : List WeekActivity
mockWeeks =
    let
        makeDay ( y, m, d, c ) =
            mockDayActivity y m d c

        makeWeek da1 da2 da3 da4 da5 da6 da7 =
            WeekActivity
                (makeDay da1)
                (makeDay da2)
                (makeDay da3)
                (makeDay da4)
                (makeDay da5)
                (makeDay da6)
                (makeDay da7)

        week1 =
            makeWeek
                ( 2016, Jul, 1, 3 )
                ( 2016, Jul, 2, 4 )
                ( 2016, Jul, 3, 0 )
                ( 2016, Jul, 4, 2 )
                ( 2016, Jul, 5, 3 )
                ( 2016, Jul, 6, 8 )
                ( 2016, Jul, 7, 1 )

        week2 =
            makeWeek
                ( 2016, Jul, 8, 1 )
                ( 2016, Jul, 9, 2 )
                ( 2016, Jul, 10, 9 )
                ( 2016, Jul, 11, 4 )
                ( 2016, Jul, 12, 5 )
                ( 2016, Jul, 13, 0 )
                ( 2016, Jul, 14, 0 )

        week3 =
            makeWeek
                ( 2016, Jul, 15, 0 )
                ( 2016, Jul, 16, 0 )
                ( 2016, Jul, 17, 3 )
                ( 2016, Jul, 18, 2 )
                ( 2016, Jul, 19, 1 )
                ( 2016, Jul, 20, 2 )
                ( 2016, Jul, 21, 5 )

        week4 =
            makeWeek
                ( 2016, Jul, 22, 1 )
                ( 2016, Jul, 23, 3 )
                ( 2016, Jul, 24, 2 )
                ( 2016, Jul, 25, 2 )
                ( 2016, Jul, 26, 9 )
                ( 2016, Jul, 27, 3 )
                ( 2016, Jul, 28, 2 )

        week5 =
            makeWeek
                ( 2016, Jul, 29, 0 )
                ( 2016, Jul, 30, 0 )
                ( 2016, Jul, 31, 0 )
                ( 2016, Aug, 1, 2 )
                ( 2016, Aug, 2, 9 )
                ( 2016, Aug, 3, 8 )
                ( 2016, Aug, 4, 5 )

        week6 =
            makeWeek
                ( 2016, Aug, 5, 1 )
                ( 2016, Aug, 6, 1 )
                ( 2016, Aug, 7, 1 )
                ( 2016, Aug, 8, 2 )
                ( 2016, Aug, 9, 3 )
                ( 2016, Aug, 10, 1 )
                ( 2016, Aug, 11, 1 )

        week7 =
            makeWeek
                ( 2016, Aug, 12, 1 )
                ( 2016, Aug, 13, 1 )
                ( 2016, Aug, 14, 1 )
                ( 2016, Aug, 15, 2 )
                ( 2016, Aug, 16, 3 )
                ( 2016, Aug, 17, 1 )
                ( 2016, Aug, 18, 1 )

        week8 =
            makeWeek
                ( 2016, Aug, 19, 1 )
                ( 2016, Aug, 20, 1 )
                ( 2016, Aug, 21, 1 )
                ( 2016, Aug, 22, 2 )
                ( 2016, Aug, 23, 3 )
                ( 2016, Aug, 24, 1 )
                ( 2016, Aug, 25, 1 )

        week9 =
            makeWeek
                ( 2016, Aug, 26, 1 )
                ( 2016, Aug, 27, 1 )
                ( 2016, Aug, 28, 1 )
                ( 2016, Aug, 29, 2 )
                ( 2016, Aug, 30, 3 )
                ( 2016, Aug, 31, 1 )
                ( 2016, Sep, 1, 1 )

        week10 =
            makeWeek
                ( 2016, Sep, 2, 1 )
                ( 2016, Sep, 3, 1 )
                ( 2016, Sep, 4, 1 )
                ( 2016, Sep, 5, 2 )
                ( 2016, Sep, 6, 3 )
                ( 2016, Sep, 7, 1 )
                ( 2016, Sep, 8, 1 )

        week11 =
            makeWeek
                ( 2016, Sep, 9, 1 )
                ( 2016, Sep, 10, 1 )
                ( 2016, Sep, 11, 1 )
                ( 2016, Sep, 12, 2 )
                ( 2016, Sep, 13, 3 )
                ( 2016, Sep, 14, 1 )
                ( 2016, Sep, 15, 1 )
    in
        [ week1
        , week2
        , week3
        , week4
        , week5
        , week6
        , week7
        , week8
        , week9
        , week10
        , week11
        ]
