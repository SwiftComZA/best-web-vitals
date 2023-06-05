module Evergreen.V3.Gen.Model exposing (..)

import Evergreen.V3.Gen.Params.AddSite
import Evergreen.V3.Gen.Params.Admin
import Evergreen.V3.Gen.Params.Home_
import Evergreen.V3.Gen.Params.NotFound
import Evergreen.V3.Pages.AddSite
import Evergreen.V3.Pages.Admin
import Evergreen.V3.Pages.Home_


type Model
    = Redirecting_
    | AddSite Evergreen.V3.Gen.Params.AddSite.Params Evergreen.V3.Pages.AddSite.Model
    | Admin Evergreen.V3.Gen.Params.Admin.Params Evergreen.V3.Pages.Admin.Model
    | Home_ Evergreen.V3.Gen.Params.Home_.Params Evergreen.V3.Pages.Home_.Model
    | NotFound Evergreen.V3.Gen.Params.NotFound.Params
