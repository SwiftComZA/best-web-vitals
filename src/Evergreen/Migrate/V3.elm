module Evergreen.Migrate.V3 exposing (..)

import Evergreen.V1.Bridge as OldBridge
import Evergreen.V1.Types as Old
import Evergreen.V3.Bridge as NewBridge
import Evergreen.V3.Types as New
import Lamdera.Migrations exposing (..)


frontendModel : Old.FrontendModel -> ModelMigration New.FrontendModel New.FrontendMsg
frontendModel old =
    ModelUnchanged


backendModel : Old.BackendModel -> ModelMigration New.BackendModel New.BackendMsg
backendModel old =
    ModelUnchanged


frontendMsg : Old.FrontendMsg -> MsgMigration New.FrontendMsg New.FrontendMsg
frontendMsg old =
    case old of
        Old.ChangedUrl _ ->
            MsgUnchanged

        Old.ClickedLink _ ->
            MsgUnchanged

        Old.Shared _ ->
            MsgUnchanged

        Old.Page _ ->
            MsgUnchanged

        Old.Noop ->
            MsgUnchanged


toBackend : Old.ToBackend -> MsgMigration New.ToBackend New.BackendMsg
toBackend old =
    case old of
        OldBridge.FetchSites ->
            MsgUnchanged

        OldBridge.RequestSiteStats _ ->
            MsgUnchanged

        OldBridge.NoOpToBackend ->
            MsgUnchanged


backendMsg : Old.BackendMsg -> MsgMigration New.BackendMsg New.BackendMsg
backendMsg old =
    MsgUnchanged


toFrontend : Old.ToFrontend -> MsgMigration New.ToFrontend New.FrontendMsg
toFrontend old =
    MsgUnchanged
