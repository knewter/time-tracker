module Decoders exposing (usersDecoder, userDecoder)

import Json.Decode as JD exposing ((:=))
import Types exposing (User)


usersDecoder : JD.Decoder (List User)
usersDecoder =
    "data" := (JD.list userDecoder)


userDecoder : JD.Decoder User
userDecoder =
    JD.object1 User
        ("name" := JD.string)
