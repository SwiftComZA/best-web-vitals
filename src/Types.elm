module Types exposing (..)

import Api.Site exposing (Category, FrontendLang, Platform, Site)
import Api.User exposing (Email, User, UserFull)
import Bridge
import Browser
import Browser.Navigation exposing (Key)
import Dict exposing (Dict)
import Gen.Pages as Pages
import Json.Auto.SpeedrunResult
import Lamdera exposing (ClientId, SessionId)
import Lamdera.Debug exposing (HttpError)
import Set exposing (Set)
import Shared
import Time
import Url exposing (Url)


type alias FrontendModel =
    { url : Url
    , key : Key
    , shared : Shared.Model
    , page : Pages.Model
    }


type alias BackendModel =
    { users : Dict Email UserFull
    , sessions : Dict SessionId Session
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
    = OnConnect SessionId ClientId
    | AuthenticateSession SessionId ClientId User Time.Posix
    | VerifySession SessionId ClientId Time.Posix
    | GotSiteStats ClientId String Platform (Result HttpError Json.Auto.SpeedrunResult.Root)
    | RegisterUser SessionId ClientId { username : String, email : String, password : String } String
    | NoOpBackendMsg


type alias ToBackend =
    Bridge.ToBackend


type ToFrontend
    = PageMsg Pages.Msg
    | SignInUser Api.User.User
    | SignOutUser
    | SendSites (Dict String Site)
    | SendCategories (List Category)
    | SendFrontendLangs (List FrontendLang)
    | NoOpToFrontend


type alias Session =
    { user : Email
    , expires : Time.Posix
    }
