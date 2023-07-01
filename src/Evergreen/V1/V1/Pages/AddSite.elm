module Evergreen.V1.Pages.AddSite exposing (..)

import Evergreen.V1.Api.Site


type alias Model =
    { site : String
    , category : Maybe Evergreen.V1.Api.Site.Category
    , frontendLang : Maybe Evergreen.V1.Api.Site.FrontendLang
    }


type Field
    = Site
    | Category
    | FrontendLang


type Msg
    = Updated Field String
    | SubmitSite
