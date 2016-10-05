module Types
    exposing
        ( User
        , UserSortableField(..)
        , Sorted(..)
        , Project
        , ProjectSortableField(..)
        , Organization
        , OrganizationSortableField(..)
        , APIFieldErrors
        , UsersListView(..)
        , DayActivity(..)
        , WeekActivity(..)
        , Paginated
        )

import Dict exposing (Dict)
import Date exposing (Date)
import RFC5988 exposing (Link)


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


type alias APIFieldErrors =
    Dict String (List String)


type UsersListView
    = UsersTable
    | UsersCards


type DayActivity
    = DayActivity Date Int


type WeekActivity
    = WeekActivity DayActivity DayActivity DayActivity DayActivity DayActivity DayActivity DayActivity


type alias PaginationLinks =
    { next : Maybe Link
    , last : Maybe Link
    , first : Maybe Link
    , previous : Maybe Link
    }


type alias Paginated a =
    { items : List a
    , total : Int
    , perPage : Int
    , totalPages : Int
    , pageNumber : Int
    , links : PaginationLinks
    }
