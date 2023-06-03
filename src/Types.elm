module Types exposing (..)

import Bridge
import Browser exposing (UrlRequest)
import Browser.Navigation exposing (Key)
import Dict exposing (Dict)
import Fifo exposing (Fifo)
import Gen.Pages as Pages
import Json.Auto.SpeedrunResult
import Lamdera.Debug exposing (HttpError)
import Shared exposing (Flags)
import Url exposing (Url)


type alias FrontendModel =
    { url : Url
    , key : Key
    , shared : Shared.Model
    , page : Pages.Model
    }


type alias SiteRequest =
    { url : String
    , mobileResult :
        Maybe
            (Result
                HttpError
                { performance : Float
                , accessibility : Float
                , bestPractices : Float
                , seo : Float
                }
            )
    , desktopResult :
        Maybe
            (Result
                HttpError
                { performance : Float
                , accessibility : Float
                , bestPractices : Float
                , seo : Float
                }
            )
    , attempts : Int
    }

type SiteRequestType 
    = Mobile
    | Desktop


type FrontendMsg
    = ChangedUrl Url
    | ClickedLink Browser.UrlRequest
    | Shared Shared.Msg
    | Page Pages.Msg
    | Noop


type alias BackendModel =
    { message : String
    , siteList : Bridge.SiteList
    , sitesQueuedForRetrieval : Fifo SiteRequest
    , sitesRetrieved : Dict String SiteRequest
    }


type alias ToBackend =
    Bridge.ToBackend


type BackendMsg
    = GotSiteStats SiteRequest SiteRequestType (Result HttpError Json.Auto.SpeedrunResult.Root)
    | RequestSiteStats
    | NoOpBackendMsg


type ToFrontend
    = UpdateSiteList Bridge.SiteList
    | NoOpToFrontend
