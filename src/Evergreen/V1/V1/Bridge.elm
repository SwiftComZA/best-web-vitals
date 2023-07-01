module Evergreen.V1.Bridge exposing (..)

import Evergreen.V1.Api.Site


type ToBackend
    = AttemptRegistration
        { username : String
        , email : String
        , password : String
        }
    | AttemptSignIn
        { email : String
        , password : String
        }
    | AttemptSignOut
    | FetchSites
    | FetchCategories
    | FetchFrontendLangs
    | RequestSiteStats Evergreen.V1.Api.Site.Url Evergreen.V1.Api.Site.Category Evergreen.V1.Api.Site.FrontendLang
    | AddCategory Evergreen.V1.Api.Site.Category
    | AddFrontendLang Evergreen.V1.Api.Site.FrontendLang
    | DeleteSite String
    | DeleteCategory Evergreen.V1.Api.Site.Category
    | DeleteFrontendLang Evergreen.V1.Api.Site.FrontendLang
    | NoOpToBackend
