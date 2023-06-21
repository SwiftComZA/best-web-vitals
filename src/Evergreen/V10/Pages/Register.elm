module Evergreen.V10.Pages.Register exposing (..)

import Evergreen.V10.Api.Data
import Evergreen.V10.Api.User


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
    | GotUser (Evergreen.V10.Api.Data.Data Evergreen.V10.Api.User.User)
