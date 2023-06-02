module Evergreen.V1.Types exposing (..)

import Browser
import Browser.Navigation
import Evergreen.V1.Bridge
import Evergreen.V1.Gen.Pages
import Evergreen.V1.Shared
import Url


type alias FrontendModel =
    { url : Url.Url
    , key : Browser.Navigation.Key
    , shared : Evergreen.V1.Shared.Model
    , page : Evergreen.V1.Gen.Pages.Model
    }


type alias BackendModel =
    { message : String
    , siteList : Evergreen.V1.Bridge.SiteList
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
    = NoOpBackendMsg


type ToFrontend
    = UpdateSiteList Evergreen.V1.Bridge.SiteList
    | NoOpToFrontend
