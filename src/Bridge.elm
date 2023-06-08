module Bridge exposing (..)

import Api.Site exposing (Category, FrontendLang, Url)
import Lamdera



-- In an elm-spa app with Lamdera, the ToBackend type must be in this
-- Bridge file to avoid import cycle issues between generated pages and Types.elm


sendToBackend =
    Lamdera.sendToBackend


type ToBackend
    = FetchSites
    | FetchCategories
    | FetchFrontendLangs
    | RequestSiteStats Url Category FrontendLang
    | AddCategory Category
    | AddFrontendLang FrontendLang
    | DeleteSite String
    | DeleteCategory Category
    | DeleteFrontendLang FrontendLang
    | NoOpToBackend
