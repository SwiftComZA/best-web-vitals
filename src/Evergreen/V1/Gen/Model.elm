module Evergreen.V1.Gen.Model exposing (..)

import Evergreen.V1.Gen.Params.AddSite
import Evergreen.V1.Gen.Params.Admin
import Evergreen.V1.Gen.Params.Home_
import Evergreen.V1.Gen.Params.NotFound
import Evergreen.V1.Pages.AddSite
import Evergreen.V1.Pages.Admin
import Evergreen.V1.Pages.Home_


type Model
    = Redirecting_
    | AddSite Evergreen.V1.Gen.Params.AddSite.Params Evergreen.V1.Pages.AddSite.Model
    | Admin Evergreen.V1.Gen.Params.Admin.Params Evergreen.V1.Pages.Admin.Model
    | Home_ Evergreen.V1.Gen.Params.Home_.Params Evergreen.V1.Pages.Home_.Model
    | NotFound Evergreen.V1.Gen.Params.NotFound.Params
