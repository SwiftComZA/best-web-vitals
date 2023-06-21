module Evergreen.V10.Types exposing (..)

import Browser
import Browser.Navigation
import Dict
import Evergreen.V10.Api.Site
import Evergreen.V10.Api.User
import Evergreen.V10.Bridge
import Evergreen.V10.Gen.Pages
import Evergreen.V10.Json.Auto.SpeedrunResult
import Evergreen.V10.Shared
import Lamdera
import Lamdera.Debug
import Set
import Time
import Url


type alias FrontendModel =
    { url : Url.Url
    , key : Browser.Navigation.Key
    , shared : Evergreen.V10.Shared.Model
    , page : Evergreen.V10.Gen.Pages.Model
    }


type alias Session =
    { user : Evergreen.V10.Api.User.Email
    , expires : Time.Posix
    }


type alias BackendModel =
    { users : Dict.Dict Evergreen.V10.Api.User.Email Evergreen.V10.Api.User.UserFull
    , authenticatedSessions : Dict.Dict Lamdera.SessionId Session
    , sites : Dict.Dict Evergreen.V10.Api.Site.Url Evergreen.V10.Api.Site.Site
    , categories : Set.Set Evergreen.V10.Api.Site.Category
    , frontendLangs : Set.Set Evergreen.V10.Api.Site.FrontendLang
    }


type FrontendMsg
    = ChangedUrl Url.Url
    | ClickedLink Browser.UrlRequest
    | Shared Evergreen.V10.Shared.Msg
    | Page Evergreen.V10.Gen.Pages.Msg
    | Noop


type alias ToBackend =
    Evergreen.V10.Bridge.ToBackend


type BackendMsg
    = OnConnect Lamdera.SessionId Lamdera.ClientId
    | AuthenticateSession Lamdera.SessionId Lamdera.ClientId Evergreen.V10.Api.User.User Time.Posix
    | VerifySession Lamdera.SessionId Lamdera.ClientId Time.Posix
    | GotSiteStats Lamdera.ClientId String Evergreen.V10.Api.Site.Platform (Result Lamdera.Debug.HttpError Evergreen.V10.Json.Auto.SpeedrunResult.Root)
    | RegisterUser
        Lamdera.SessionId
        Lamdera.ClientId
        { username : String
        , email : String
        , password : String
        }
        String
    | NoOpBackendMsg


type ToFrontend
    = PageMsg Evergreen.V10.Gen.Pages.Msg
    | SignInUser Evergreen.V10.Api.User.User
    | SignOutUser
    | SendSites (Dict.Dict String Evergreen.V10.Api.Site.Site)
    | SendCategories (List Evergreen.V10.Api.Site.Category)
    | SendFrontendLangs (List Evergreen.V10.Api.Site.FrontendLang)
    | NoOpToFrontend
