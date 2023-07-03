module Evergreen.V1.Pages.Register exposing (..)

import Evergreen.V1.Api.Data
import Evergreen.V1.Api.User


type alias Model =
    { username : String
    , email : String
    , password : String
    , message : Maybe ( String, Bool )
    }


type Field
    = Username
    | Email
    | Password


type Msg
    = Updated Field String
    | ClickedSubmit
    | GotUser (Evergreen.V1.Api.Data.Data Evergreen.V1.Api.User.User)
