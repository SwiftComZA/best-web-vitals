module Evergreen.V1.Pages.Login exposing (..)

import Evergreen.V1.Api.Data
import Evergreen.V1.Api.User


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
    | GotUser (Evergreen.V1.Api.Data.Data Evergreen.V1.Api.User.User)
