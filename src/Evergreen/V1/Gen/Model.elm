module Evergreen.V1.Gen.Model exposing (..)

import Evergreen.V1.Gen.Params.AddListing
import Evergreen.V1.Gen.Params.Admin
import Evergreen.V1.Gen.Params.Home_
import Evergreen.V1.Gen.Params.NotFound
import Evergreen.V1.Pages.AddListing
import Evergreen.V1.Pages.Admin
import Evergreen.V1.Pages.Home_


type Model
    = Redirecting_
    | AddListing Evergreen.V1.Gen.Params.AddListing.Params Evergreen.V1.Pages.AddListing.Model
    | Admin Evergreen.V1.Gen.Params.Admin.Params Evergreen.V1.Pages.Admin.Model
    | Home_ Evergreen.V1.Gen.Params.Home_.Params Evergreen.V1.Pages.Home_.Model
    | NotFound Evergreen.V1.Gen.Params.NotFound.Params
