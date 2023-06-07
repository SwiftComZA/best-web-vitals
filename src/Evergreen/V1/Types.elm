module Evergreen.V1.Types exposing (..)

import Browser
import Browser.Navigation
import Dict
import Evergreen.V1.Api.Site
import Evergreen.V1.Bridge
import Evergreen.V1.Gen.Pages
import Evergreen.V1.Json.Auto.SpeedrunResult
import Evergreen.V1.Shared
import Lamdera
import Lamdera.Debug
import Url


type alias FrontendModel =
    { url : Url.Url
    , key : Browser.Navigation.Key
    , shared : Evergreen.V1.Shared.Model
    , page : Evergreen.V1.Gen.Pages.Model
    }


type alias BackendModel =
    { message : String
    , sites : Dict.Dict String Evergreen.V1.Api.Site.Site
    }


type FrontendMsg
    = ChangedUrl Url.Url
    | ClickedLink Browser.UrlRequest
    | Shared Evergreen.V1.Shared.Msg
    | Page Evergreen.V1.Gen.Pages.Msg
    | Noop


type alias ToBackend =
    Evergreen.V1.Bridge.ToBackend


type BackendMsg
    = GotSiteStats Lamdera.ClientId String Evergreen.V1.Api.Site.ScoreDevice (Result Lamdera.Debug.HttpError Evergreen.V1.Json.Auto.SpeedrunResult.Root)
    | NoOpBackendMsg


type ToFrontend
    = UpdateSiteList (Dict.Dict String Evergreen.V1.Api.Site.Site)
    | NoOpToFrontend
