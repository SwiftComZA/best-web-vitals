module Evergreen.V10.Shared exposing (..)

import Browser.Dom
import Dict
import Evergreen.V10.Api.Site
import Evergreen.V10.Api.User


type alias Model =
    { user : Maybe Evergreen.V10.Api.User.User
    , sites : Dict.Dict String Evergreen.V10.Api.Site.Site
    , sort : ( Evergreen.V10.Api.Site.Sort, Evergreen.V10.Api.Site.Direction )
    , categories : List Evergreen.V10.Api.Site.Category
    , frontendLangs : List Evergreen.V10.Api.Site.FrontendLang
    , viewportWidth : Float
    , menuOpen : Bool
    }


type Msg
    = SignedInUser Evergreen.V10.Api.User.User
    | SignedOutUser
    | ChangedSort Evergreen.V10.Api.Site.Sort
    | GotSites (Dict.Dict String Evergreen.V10.Api.Site.Site)
    | GotCategories (List Evergreen.V10.Api.Site.Category)
    | GotFrontendLangs (List Evergreen.V10.Api.Site.FrontendLang)
    | ClickedSignOut
    | GotViewport Browser.Dom.Viewport
    | ResizedViewport ()
    | ClickedMenu
    | CloseMenu
