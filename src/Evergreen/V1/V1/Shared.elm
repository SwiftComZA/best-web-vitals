module Evergreen.V1.Shared exposing (..)

import Dict
import Evergreen.V1.Api.Site
import Evergreen.V1.Api.User


type alias Model =
    { user : Maybe Evergreen.V1.Api.User.User
    , sites : Dict.Dict String Evergreen.V1.Api.Site.Site
    , sort : ( Evergreen.V1.Api.Site.Sort, Evergreen.V1.Api.Site.Direction )
    , categories : List Evergreen.V1.Api.Site.Category
    , frontendLangs : List Evergreen.V1.Api.Site.FrontendLang
    }


type Msg
    = SignedInUser Evergreen.V1.Api.User.User
    | SignedOutUser
    | ChangedSort Evergreen.V1.Api.Site.Sort
    | GotSites (Dict.Dict String Evergreen.V1.Api.Site.Site)
    | GotCategories (List Evergreen.V1.Api.Site.Category)
    | GotFrontendLangs (List Evergreen.V1.Api.Site.FrontendLang)
    | ClickedSignOut
