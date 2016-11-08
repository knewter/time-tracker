module Types.ActivityStreams exposing (Activity)

import Date exposing (Date)


type alias Activity =
    { name : String
    , type_ : String
    , actor : String
    , object : String
    , published : Date
    }
