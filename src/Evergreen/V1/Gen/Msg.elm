module Evergreen.V1.Gen.Msg exposing (..)

import Evergreen.V1.Pages.AddSite
import Evergreen.V1.Pages.Admin
import Evergreen.V1.Pages.Home_


type Msg
    = AddSite Evergreen.V1.Pages.AddSite.Msg
    | Admin Evergreen.V1.Pages.Admin.Msg
    | Home_ Evergreen.V1.Pages.Home_.Msg
