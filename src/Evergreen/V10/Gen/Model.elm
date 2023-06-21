module Evergreen.V10.Gen.Model exposing (..)

import Evergreen.V10.Gen.Params.AddSite
import Evergreen.V10.Gen.Params.Admin
import Evergreen.V10.Gen.Params.Home_
import Evergreen.V10.Gen.Params.Login
import Evergreen.V10.Gen.Params.NotFound
import Evergreen.V10.Gen.Params.Register
import Evergreen.V10.Pages.AddSite
import Evergreen.V10.Pages.Admin
import Evergreen.V10.Pages.Home_
import Evergreen.V10.Pages.Login
import Evergreen.V10.Pages.Register


type Model
    = Redirecting_
    | AddSite Evergreen.V10.Gen.Params.AddSite.Params Evergreen.V10.Pages.AddSite.Model
    | Admin Evergreen.V10.Gen.Params.Admin.Params Evergreen.V10.Pages.Admin.Model
    | Home_ Evergreen.V10.Gen.Params.Home_.Params Evergreen.V10.Pages.Home_.Model
    | Login Evergreen.V10.Gen.Params.Login.Params Evergreen.V10.Pages.Login.Model
    | NotFound Evergreen.V10.Gen.Params.NotFound.Params
    | Register Evergreen.V10.Gen.Params.Register.Params Evergreen.V10.Pages.Register.Model
