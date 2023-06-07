module Evergreen.V1.Bridge exposing (..)


type ToBackend
    = FetchSites
    | RequestSiteStats String
    | DeleteSite String
    | NoOpToBackend
