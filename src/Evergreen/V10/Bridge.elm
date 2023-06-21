module Evergreen.V10.Bridge exposing (..)

import Evergreen.V10.Api.Site


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
    | RequestSiteStats Evergreen.V10.Api.Site.Url Evergreen.V10.Api.Site.Category Evergreen.V10.Api.Site.FrontendLang
    | AddCategory Evergreen.V10.Api.Site.Category
    | AddFrontendLang Evergreen.V10.Api.Site.FrontendLang
    | DeleteSite String
    | DeleteCategory Evergreen.V10.Api.Site.Category
    | DeleteFrontendLang Evergreen.V10.Api.Site.FrontendLang
    | NoOpToBackend
