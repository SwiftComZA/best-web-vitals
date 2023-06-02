module Gen.Model exposing (Model(..))

import Gen.Params.AddListing
import Gen.Params.AddSite
import Gen.Params.Admin
import Gen.Params.Home_
import Gen.Params.NotFound
import Pages.AddListing
import Pages.AddSite
import Pages.Admin
import Pages.Home_
import Pages.NotFound


type Model
    = Redirecting_
    | AddListing Gen.Params.AddListing.Params Pages.AddListing.Model
    | AddSite Gen.Params.AddSite.Params Pages.AddSite.Model
    | Admin Gen.Params.Admin.Params Pages.Admin.Model
    | Home_ Gen.Params.Home_.Params Pages.Home_.Model
    | NotFound Gen.Params.NotFound.Params

