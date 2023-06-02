module Evergreen.V1.Bridge exposing (..)

import Dict


type alias Site =
    { domain : String
    , category : String
    , frontendLang : String
    , approved : Bool
    , mobileScore : Int
    , desktopScore : Int
    }


type alias SiteList =
    Dict.Dict String Site


type ToBackend
    = FetchSites
    | SendSiteToBackend Site
    | ApproveSiteToBackend String Bool
    | NoOpToBackend
