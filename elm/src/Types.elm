module Types exposing (User, UserSortableField(..), Sorted(..))


type alias User =
    { id : Maybe Int
    , name : String
    }


type UserSortableField
    = Name


type Sorted
    = Ascending
    | Descending
