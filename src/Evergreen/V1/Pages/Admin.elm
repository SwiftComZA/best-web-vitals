module Evergreen.V1.Pages.Admin exposing (..)

import Evergreen.V1.Api.Site


type alias Model =
    ()


type Msg
    = DeleteSite String
    | ChangeSort Evergreen.V1.Api.Site.Sort
