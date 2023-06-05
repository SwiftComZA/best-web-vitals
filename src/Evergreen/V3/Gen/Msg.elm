module Evergreen.V3.Gen.Msg exposing (..)

import Evergreen.V3.Pages.AddSite
import Evergreen.V3.Pages.Admin
import Evergreen.V3.Pages.Home_


type Msg
    = AddSite Evergreen.V3.Pages.AddSite.Msg
    | Admin Evergreen.V3.Pages.Admin.Msg
    | Home_ Evergreen.V3.Pages.Home_.Msg
