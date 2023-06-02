module Types exposing (..)

import Bridge
import Browser exposing (UrlRequest)
import Browser.Navigation exposing (Key)
import Dict exposing (Dict)
import Gen.Pages as Pages
import Shared exposing (Flags)
import Url exposing (Url)


type alias FrontendModel =
    { url : Url
    , key : Key
    , shared : Shared.Model
    , page : Pages.Model
    }


type FrontendMsg
    = ChangedUrl Url
    | ClickedLink Browser.UrlRequest
    | Shared Shared.Msg
    | Page Pages.Msg
    | Noop


type alias BackendModel =
    { message : String
    , siteList : Bridge.SiteList
    , sitesQueuedForRetrieval : List String
    }


type alias ToBackend =
    Bridge.ToBackend


type BackendMsg
    = NoOpBackendMsg


type ToFrontend
    = UpdateSiteList Bridge.SiteList
    | NoOpToFrontend
