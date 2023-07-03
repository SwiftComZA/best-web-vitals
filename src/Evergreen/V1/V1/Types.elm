module Evergreen.V1.Types exposing (..)

import Browser
import Browser.Navigation
import Dict
import Evergreen.V1.Api.Site
import Evergreen.V1.Api.User
import Evergreen.V1.Bridge
import Evergreen.V1.Gen.Pages
import Evergreen.V1.Json.Auto.SpeedrunResult
import Evergreen.V1.Shared
import Lamdera
import Lamdera.Debug
import Set
import Time
import Url


type alias FrontendModel =
    { url : Url.Url
    , key : Browser.Navigation.Key
    , shared : Evergreen.V1.Shared.Model
    , page : Evergreen.V1.Gen.Pages.Model
    }


type alias Session =
    { user : Evergreen.V1.Api.User.Email
    , expires : Time.Posix
    }


type alias BackendModel =
    { users : Dict.Dict Evergreen.V1.Api.User.Email Evergreen.V1.Api.User.UserFull
    , sessions : Dict.Dict Lamdera.SessionId Session
    , sites : Dict.Dict String Evergreen.V1.Api.Site.Site
    , categories : Set.Set Evergreen.V1.Api.Site.Category
    , frontendLangs : Set.Set Evergreen.V1.Api.Site.FrontendLang
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
    = OnConnect Lamdera.SessionId Lamdera.ClientId
    | AuthenticateSession Lamdera.SessionId Lamdera.ClientId Evergreen.V1.Api.User.User Time.Posix
    | VerifySession Lamdera.SessionId Lamdera.ClientId Time.Posix
    | GotSiteStats Lamdera.ClientId String Evergreen.V1.Api.Site.Platform (Result Lamdera.Debug.HttpError Evergreen.V1.Json.Auto.SpeedrunResult.Root)
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
    = PageMsg Evergreen.V1.Gen.Pages.Msg
    | SignInUser Evergreen.V1.Api.User.User
    | SignOutUser
    | SendSites (Dict.Dict String Evergreen.V1.Api.Site.Site)
    | SendCategories (List Evergreen.V1.Api.Site.Category)
    | SendFrontendLangs (List Evergreen.V1.Api.Site.FrontendLang)
    | NoOpToFrontend
