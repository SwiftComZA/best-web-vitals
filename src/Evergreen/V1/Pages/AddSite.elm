module Evergreen.V1.Pages.AddSite exposing (..)


type alias Model =
    { site : String
    , queuedSites : List String
    }


type Msg
    = UpdateSite String
    | SubmitSite
