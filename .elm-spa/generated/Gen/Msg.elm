module Gen.Msg exposing (Msg(..))

import Gen.Params.AddListing
import Gen.Params.Admin
import Gen.Params.Home_
import Gen.Params.NotFound
import Pages.AddListing
import Pages.Admin
import Pages.Home_
import Pages.NotFound


type Msg
    = AddListing Pages.AddListing.Msg
    | Admin Pages.Admin.Msg
    | Home_ Pages.Home_.Msg

