module Evergreen.V1.Pages.AddListing exposing (..)

import Evergreen.V1.Bridge


type alias Model =
    Evergreen.V1.Bridge.Site


type Msg
    = UpdateDomain String
    | UpdateCategory String
    | UpdateFrontendLang String
    | UpdateMobileScore String
    | UpdateDesktopScore String
    | Submit
