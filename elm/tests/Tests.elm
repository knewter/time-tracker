module Tests exposing (..)

import Test exposing (..)
import Expect
import String
import Json.Decode as JD
import Types exposing (User)
import Decoders exposing (usersDecoder)


all : Test
all =
    describe "A Test Suite"
        [ test "decoding slots" <|
            \() ->
                Expect.equal (JD.decodeString usersDecoder "[{\"name\": \"Josh\"}]") (Ok [ (User "Josh") ])
        ]
