module Evergreen.V3.Types exposing (..)

import Browser
import Browser.Navigation
import Dict
import Evergreen.V3.Api.Site
import Evergreen.V3.Bridge
import Evergreen.V3.Gen.Pages
import Evergreen.V3.Json.Auto.SpeedrunResult
import Evergreen.V3.Shared
import Lamdera.Debug
import Url


type alias FrontendModel =
    { url : Url.Url
    , key : Browser.Navigation.Key
    , shared : Evergreen.V3.Shared.Model
    , page : Evergreen.V3.Gen.Pages.Model
    }


type alias BackendModel =
    { message : String
    , sites : Dict.Dict String Evergreen.V3.Api.Site.Site
    }


type FrontendMsg
    = ChangedUrl Url.Url
    | ClickedLink Browser.UrlRequest
    | Shared Evergreen.V3.Shared.Msg
    | Page Evergreen.V3.Gen.Pages.Msg
    | Noop


type alias ToBackend =
    Evergreen.V3.Bridge.ToBackend


type BackendMsg
    = GotSiteStats String Evergreen.V3.Api.Site.SiteScoreType (Result Lamdera.Debug.HttpError Evergreen.V3.Json.Auto.SpeedrunResult.Root)
    | NoOpBackendMsg


type ToFrontend
    = UpdateSiteList (Dict.Dict String Evergreen.V3.Api.Site.Site)
    | NoOpToFrontend
