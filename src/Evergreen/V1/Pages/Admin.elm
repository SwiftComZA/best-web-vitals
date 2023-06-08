module Evergreen.V1.Pages.Admin exposing (..)

import Evergreen.V1.Api.Site


type alias Model =
    { category : Evergreen.V1.Api.Site.Category
    , frontendLang : Evergreen.V1.Api.Site.FrontendLang
    }


type Field
    = Category
    | FrontendLang


type Msg
    = ClickedDeleteSite String
    | ClickedDelete Field String
    | ClickedChangeSort Evergreen.V1.Api.Site.Sort
    | Updated Field String
    | CLickedSubmit Field
