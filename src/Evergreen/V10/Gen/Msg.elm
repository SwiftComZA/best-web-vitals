module Evergreen.V10.Gen.Msg exposing (..)

import Evergreen.V10.Pages.AddSite
import Evergreen.V10.Pages.Admin
import Evergreen.V10.Pages.Home_
import Evergreen.V10.Pages.Login
import Evergreen.V10.Pages.Register


type Msg
    = AddSite Evergreen.V10.Pages.AddSite.Msg
    | Admin Evergreen.V10.Pages.Admin.Msg
    | Home_ Evergreen.V10.Pages.Home_.Msg
    | Login Evergreen.V10.Pages.Login.Msg
    | Register Evergreen.V10.Pages.Register.Msg
