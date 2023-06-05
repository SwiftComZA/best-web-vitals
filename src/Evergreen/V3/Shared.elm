module Evergreen.V3.Shared exposing (..)

import Dict
import Evergreen.V3.Api.Site


type alias Model =
    { siteList : Dict.Dict String Evergreen.V3.Api.Site.Site
    }


type Msg
    = UpdateSiteList (Dict.Dict String Evergreen.V3.Api.Site.Site)
