module Evergreen.V1.Gen.Msg exposing (..)

import Evergreen.V1.Pages.AddListing
import Evergreen.V1.Pages.Admin
import Evergreen.V1.Pages.Home_


type Msg
    = AddListing Evergreen.V1.Pages.AddListing.Msg
    | Admin Evergreen.V1.Pages.Admin.Msg
    | Home_ Evergreen.V1.Pages.Home_.Msg
