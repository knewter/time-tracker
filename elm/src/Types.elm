module Types exposing (User, UserSortableField(..), Sorted(..), Project, ProjectSortableField(..))


type alias User =
    { id : Maybe Int
    , name : String
    }


type alias Project =
    { id : Maybe Int
    , name : String
    }


type UserSortableField
    = UserName


type ProjectSortableField
    = ProjectName


type Sorted
    = Ascending
    | Descending
