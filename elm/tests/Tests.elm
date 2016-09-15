module Tests exposing (..)

import Test exposing (..)
import Expect
import String
import Json.Decode as JD
import Json.Decode.Extra as JDE
import Types exposing (User, DayActivity(..))
import Decoders exposing (usersDecoder, dayActivityDecoder)
import Date exposing (Month(..))
import Date.Extra as Date exposing (utc, noTime, calendarDate)


all : Test
all =
    describe "A Test Suite"
        [ test "decoding users" <|
            \() ->
                Expect.equal (JD.decodeString usersDecoder "[{\"id\": 1, \"name\": \"Josh\"}]") (Ok [ (User (Just 1) "Josh") ])
        , test "decoding DayActivity" <|
            \() ->
                Expect.equal (JD.decodeString dayActivityDecoder "{\"date\": \"2016-01-01\", \"count\": 12}") (Ok (DayActivity (Date.fromSpec utc noTime (calendarDate 2016 Jan 1)) 12))
        ]
