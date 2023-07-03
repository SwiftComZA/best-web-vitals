module Evergreen.V1.Pages.Home_ exposing (..)

import Evergreen.V1.Api.Site


type alias Model =
    { searchTerm : String
    }


type Msg
    = ClickedChangeSort Evergreen.V1.Api.Site.Sort
    | UpdatedSearchTerm String
    | NoOp
