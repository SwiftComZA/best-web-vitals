module Evergreen.V3.Bridge exposing (..)


type ToBackend
    = FetchSites
    | RequestSiteStats String
    | DeleteSite String
    | NoOpToBackend
