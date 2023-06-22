module Evergreen.V10.Pages.Home_ exposing (..)

import Evergreen.V10.Api.Site


type alias Model =
    { searchTerm : String
    , platform : Evergreen.V10.Api.Site.Platform
    , expandedSite : Maybe String
    }


type Msg
    = ClickedChangeSort Evergreen.V10.Api.Site.Sort
    | UpdatedSearchTerm String
    | ClickedPlatform Evergreen.V10.Api.Site.Platform
    | ClickedExpandSite String
    | NoOp
