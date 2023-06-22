module Evergreen.V10.Pages.AddSite exposing (..)

import Evergreen.V10.Api.Site


type alias Model =
    { site : String
    , category : Maybe Evergreen.V10.Api.Site.Category
    , frontendLang : Maybe Evergreen.V10.Api.Site.FrontendLang
    , message : Maybe ( String, Bool )
    }


type Field
    = Site
    | Category
    | FrontendLang


type Msg
    = Updated Field String
    | SubmitSite
