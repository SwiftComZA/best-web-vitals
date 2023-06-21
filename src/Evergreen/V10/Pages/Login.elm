module Evergreen.V10.Pages.Login exposing (..)

import Evergreen.V10.Api.Data
import Evergreen.V10.Api.User


type alias Model =
    { email : String
    , password : String
    , message : Maybe ( String, Bool )
    }


type Field
    = Email
    | Password


type Msg
    = Updated Field String
    | ClickedSubmit
    | GotUser (Evergreen.V10.Api.Data.Data Evergreen.V10.Api.User.User)
