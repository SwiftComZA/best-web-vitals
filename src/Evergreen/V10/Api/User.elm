module Evergreen.V10.Api.User exposing (..)


type alias Email =
    String


type alias User =
    { username : String
    , email : Email
    , isAdmin : Bool
    }


type alias UserFull =
    { username : String
    , email : Email
    , isAdmin : Bool
    , passwordHash : String
    , salt : String
    }
