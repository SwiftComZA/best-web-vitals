module Evergreen.V1.Api.User exposing (..)


type alias User =
    { username : String
    , email : String
    , isAdmin : Bool
    }


type alias Email =
    String


type alias UserFull =
    { username : String
    , email : String
    , isAdmin : Bool
    , passwordHash : String
    , salt : String
    }
