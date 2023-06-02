module Bridge exposing (..)

import Dict exposing (Dict)



-- In an elm-spa app with Lamdera, the ToBackend type must be in this
-- Bridge file to avoid import cycle issues between generated pages and Types.elm


type ToBackend
    = FetchSites
    | SendSiteToBackend Site
    | ApproveSiteToBackend String Bool
    | QueueSiteForRetrieval String
    | NoOpToBackend



-- Data


type alias SiteList =
    Dict String Site


type alias Site =
    { domain : String
    , category : String
    , frontendLang : String
    , approved : Bool
    , mobileScore : Int
    , desktopScore : Int
    }


type alias Score =
    Int
