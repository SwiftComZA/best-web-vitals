module Types exposing (..)

import Api.Site exposing (Site, SiteScoreType)
import Bridge
import Browser
import Browser.Navigation exposing (Key)
import Dict exposing (Dict)
import Gen.Pages as Pages
import Json.Auto.SpeedrunResult
import Lamdera.Debug exposing (HttpError)
import Shared
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
    , sites : Dict String Site
    }


type alias ToBackend =
    Bridge.ToBackend


type BackendMsg
    = GotSiteStats String SiteScoreType (Result HttpError Json.Auto.SpeedrunResult.Root)
    | NoOpBackendMsg


type ToFrontend
    = UpdateSiteList (Dict String Site)
    | NoOpToFrontend
