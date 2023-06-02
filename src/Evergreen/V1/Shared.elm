module Evergreen.V1.Shared exposing (..)

import Evergreen.V1.Bridge


type alias Model =
    { siteList : Evergreen.V1.Bridge.SiteList
    }


type Msg
    = UpdateSiteList Evergreen.V1.Bridge.SiteList
