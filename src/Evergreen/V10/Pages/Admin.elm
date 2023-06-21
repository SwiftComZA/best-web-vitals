module Evergreen.V10.Pages.Admin exposing (..)

import Evergreen.V10.Api.Site


type alias Model =
    { category : Evergreen.V10.Api.Site.Category
    , frontendLang : Evergreen.V10.Api.Site.FrontendLang
    }


type Field
    = Category
    | FrontendLang


type Msg
    = ClickedDeleteSite String
    | ClickedDelete Field String
    | ClickedChangeSort Evergreen.V10.Api.Site.Sort
    | Updated Field String
    | ClickedSubmit Field
