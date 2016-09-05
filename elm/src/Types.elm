module Types
    exposing
        ( User
        , UserSortableField(..)
        , Sorted(..)
        , Project
        , ProjectSortableField(..)
        , Organization
        , OrganizationSortableField(..)
        )


type alias User =
    { id : Maybe Int
    , name : String
    }


type alias Project =
    { id : Maybe Int
    , name : String
    }


type alias Organization =
    { id : Maybe Int
    , name : String
    }


type UserSortableField
    = UserName


type ProjectSortableField
    = ProjectName


type OrganizationSortableField
    = OrganizationName


type Sorted
    = Ascending
    | Descending
