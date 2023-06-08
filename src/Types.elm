module Types exposing (..)

import Api.Site exposing (Category, FrontendLang, ScoreDevice, Site)
import Bridge
import Browser
import Browser.Navigation exposing (Key)
import Dict exposing (Dict)
import Gen.Pages as Pages
import Json.Auto.SpeedrunResult
import Lamdera exposing (ClientId)
import Lamdera.Debug exposing (HttpError)
import Set exposing (Set)
import Shared
import Url exposing (Url)


type alias FrontendModel =
    { url : Url
    , key : Key
    , shared : Shared.Model
    , page : Pages.Model
    }


type alias BackendModel =
    { message : String
    , sites : Dict String Site
    , categories : Set Category
    , frontendLangs : Set FrontendLang
    }


type FrontendMsg
    = ChangedUrl Url
    | ClickedLink Browser.UrlRequest
    | Shared Shared.Msg
    | Page Pages.Msg
    | Noop


type BackendMsg
    = GotSiteStats ClientId String ScoreDevice (Result HttpError Json.Auto.SpeedrunResult.Root)
    | NoOpBackendMsg


type alias ToBackend =
    Bridge.ToBackend


type ToFrontend
    = PageMsg Pages.Msg
    | SendSites (Dict String Site)
    | SendCategories (List Category)
    | SendFrontendLangs (List FrontendLang)
    | NoOpToFrontend
