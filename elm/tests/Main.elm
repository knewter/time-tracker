port module Main exposing (..)

import Tests
import Test.Runner.Node exposing (run)
import Json.Encode exposing (Value)


main : Program Never
main =
    run emit Tests.all


port emit : ( String, Value ) -> Cmd msg
