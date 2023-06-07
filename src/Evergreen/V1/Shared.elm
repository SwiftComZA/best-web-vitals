module Evergreen.V1.Shared exposing (..)

import Dict
import Evergreen.V1.Api.Site


type alias Model =
    { siteList : Dict.Dict String Evergreen.V1.Api.Site.Site
    , sort : ( Evergreen.V1.Api.Site.Sort, Evergreen.V1.Api.Site.Direction )
    }


type Msg
    = UpdateSiteList (Dict.Dict String Evergreen.V1.Api.Site.Site)
    | ChangeSort Evergreen.V1.Api.Site.Sort
