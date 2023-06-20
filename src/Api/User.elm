module Api.User exposing (..)

import Regex


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


type alias Email =
    String


toUser : UserFull -> User
toUser u =
    { email = u.email
    , username = u.username
    , isAdmin = u.isAdmin
    }



-- TODO: Remove hardcoded admin users list


adminUsers =
    [ "abel@swiftcom.co.za"
    , "chris@swiftcom.co.za"
    ]



-- USER VALIDATION


validateUser :
    { username : String
    , email : String
    , password : String
    }
    -> ( Bool, Bool, Bool )
validateUser { username, email, password } =
    ( username |> (not << String.isEmpty)
    , validateEmail email
    , password |> (not << String.isEmpty)
    )


validateEmail : String -> Bool
validateEmail email =
    email |> Regex.contains emailRegex


emailRegex =
    Regex.fromString "[^@ \\t\\r\\n]+@[^@ \\t\\r\\n]+\\.[^@ \\t\\r\\n]+" |> Maybe.withDefault Regex.never
