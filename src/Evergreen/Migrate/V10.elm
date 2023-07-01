module Evergreen.Migrate.V10 exposing (..)

{-| This migration file was automatically generated by the lamdera compiler.

It includes:

  - A migration for each of the 6 Lamdera core types that has changed
  - A function named `migrate_ModuleName_TypeName` for each changed/custom type

Expect to see:

  - `Unimplementеd` values as placeholders wherever I was unable to figure out a clear migration path for you
  - `@NOTICE` comments for things you should know about, i.e. new custom type constructors that won't get any
    value mappings from the old type by default

You can edit this file however you wish! It won't be generated again.

See <https://dashboard.lamdera.app/docs/evergreen> for more info.

-}

import Dict
import Evergreen.V1.Api.Data
import Evergreen.V1.Api.Site
import Evergreen.V1.Api.User
import Evergreen.V1.Gen.Model
import Evergreen.V1.Gen.Msg
import Evergreen.V1.Gen.Pages
import Evergreen.V1.Pages.AddSite
import Evergreen.V1.Pages.Admin
import Evergreen.V1.Pages.Home_
import Evergreen.V1.Pages.Login
import Evergreen.V1.Pages.Register
import Evergreen.V1.Shared
import Evergreen.V1.Types
import Evergreen.V10.Api.Data
import Evergreen.V10.Api.Site
import Evergreen.V10.Api.User
import Evergreen.V10.Gen.Model
import Evergreen.V10.Gen.Msg
import Evergreen.V10.Gen.Pages
import Evergreen.V10.Pages.AddSite
import Evergreen.V10.Pages.Admin
import Evergreen.V10.Pages.Home_
import Evergreen.V10.Pages.Login
import Evergreen.V10.Pages.Register
import Evergreen.V10.Shared
import Evergreen.V10.Types
import Lamdera.Migrations exposing (..)
import Maybe


frontendModel : Evergreen.V1.Types.FrontendModel -> ModelMigration Evergreen.V10.Types.FrontendModel Evergreen.V10.Types.FrontendMsg
frontendModel old =
    ModelMigrated ( migrate_Types_FrontendModel old, Cmd.none )


backendModel : Evergreen.V1.Types.BackendModel -> ModelMigration Evergreen.V10.Types.BackendModel Evergreen.V10.Types.BackendMsg
backendModel old =
    ModelMigrated ( migrate_Types_BackendModel old, Cmd.none )


frontendMsg : Evergreen.V1.Types.FrontendMsg -> MsgMigration Evergreen.V10.Types.FrontendMsg Evergreen.V10.Types.FrontendMsg
frontendMsg old =
    MsgMigrated ( migrate_Types_FrontendMsg old, Cmd.none )


toBackend : Evergreen.V1.Types.ToBackend -> MsgMigration Evergreen.V10.Types.ToBackend Evergreen.V10.Types.BackendMsg
toBackend old =
    MsgUnchanged


backendMsg : Evergreen.V1.Types.BackendMsg -> MsgMigration Evergreen.V10.Types.BackendMsg Evergreen.V10.Types.BackendMsg
backendMsg old =
    MsgUnchanged


toFrontend : Evergreen.V1.Types.ToFrontend -> MsgMigration Evergreen.V10.Types.ToFrontend Evergreen.V10.Types.FrontendMsg
toFrontend old =
    MsgMigrated ( migrate_Types_ToFrontend old, Cmd.none )


migrate_Types_BackendModel : Evergreen.V1.Types.BackendModel -> Evergreen.V10.Types.BackendModel
migrate_Types_BackendModel old =
    { users = old.users |> Dict.map (\k -> migrate_Api_User_UserFull)
    , authenticatedSessions = old.sessions
    , sites = old.sites |> Dict.toList |> List.map (Tuple.mapBoth identity migrate_Api_Site_Site) |> Dict.fromList
    , categories = old.categories
    , frontendLangs = old.frontendLangs
    }


migrate_Types_FrontendModel : Evergreen.V1.Types.FrontendModel -> Evergreen.V10.Types.FrontendModel
migrate_Types_FrontendModel old =
    { url = old.url
    , key = old.key
    , shared = old.shared |> migrate_Shared_Model
    , page = old.page |> migrate_Gen_Pages_Model
    }


migrate_Api_Data_Data : (value_old -> value_new) -> Evergreen.V1.Api.Data.Data value_old -> Evergreen.V10.Api.Data.Data value_new
migrate_Api_Data_Data migrate_value old =
    case old of
        Evergreen.V1.Api.Data.NotAsked ->
            Evergreen.V10.Api.Data.NotAsked

        Evergreen.V1.Api.Data.Loading ->
            Evergreen.V10.Api.Data.Loading

        Evergreen.V1.Api.Data.Failure p0 ->
            Evergreen.V10.Api.Data.Failure p0

        Evergreen.V1.Api.Data.Success p0 ->
            Evergreen.V10.Api.Data.Success (p0 |> migrate_value)


migrate_Api_Site_Direction : Evergreen.V1.Api.Site.Direction -> Evergreen.V10.Api.Site.Direction
migrate_Api_Site_Direction old =
    case old of
        Evergreen.V1.Api.Site.Asc ->
            Evergreen.V10.Api.Site.Asc

        Evergreen.V1.Api.Site.Desc ->
            Evergreen.V10.Api.Site.Desc


migrate_Api_Site_Score : Evergreen.V1.Api.Site.Score -> Evergreen.V10.Api.Site.Score
migrate_Api_Site_Score old =
    case old of
        Evergreen.V1.Api.Site.Failed ->
            Evergreen.V10.Api.Site.Failed

        Evergreen.V1.Api.Site.Pending ->
            Evergreen.V10.Api.Site.Pending

        Evergreen.V1.Api.Site.Success p0 ->
            Evergreen.V10.Api.Site.Success (p0 |> migrate_Api_Site_ScoreValue)


migrate_Api_Site_ScoreType : Evergreen.V1.Api.Site.ScoreType -> Evergreen.V10.Api.Site.ScoreType
migrate_Api_Site_ScoreType old =
    case old of
        Evergreen.V1.Api.Site.Perf ->
            Evergreen.V10.Api.Site.Perf

        Evergreen.V1.Api.Site.A11y ->
            Evergreen.V10.Api.Site.A11y

        Evergreen.V1.Api.Site.BP ->
            Evergreen.V10.Api.Site.BP

        Evergreen.V1.Api.Site.SEO ->
            Evergreen.V10.Api.Site.SEO


migrate_Api_Site_ScoreValue : Evergreen.V1.Api.Site.ScoreValue -> Evergreen.V10.Api.Site.ScoreValue
migrate_Api_Site_ScoreValue old =
    old


migrate_Api_Site_Site : Evergreen.V1.Api.Site.Site -> Evergreen.V10.Api.Site.Site
migrate_Api_Site_Site old =
    { url = old.url
    , mobileScore = old.mobileScore |> migrate_Api_Site_Score
    , desktopScore = old.desktopScore |> migrate_Api_Site_Score
    , category = old.category
    , frontendLang = old.frontendLang
    }


migrate_Api_Site_Sort : Evergreen.V1.Api.Site.Sort -> Evergreen.V10.Api.Site.Sort
migrate_Api_Site_Sort old =
    case old of
        Evergreen.V1.Api.Site.Domain ->
            Evergreen.V10.Api.Site.Domain

        Evergreen.V1.Api.Site.Category ->
            Evergreen.V10.Api.Site.Category

        Evergreen.V1.Api.Site.FrontendLang ->
            Evergreen.V10.Api.Site.FrontendLang

        Evergreen.V1.Api.Site.MobileScore p0 ->
            Evergreen.V10.Api.Site.MobileScore (p0 |> migrate_Api_Site_ScoreType)

        Evergreen.V1.Api.Site.DesktopScore p0 ->
            Evergreen.V10.Api.Site.DesktopScore (p0 |> migrate_Api_Site_ScoreType)


migrate_Api_User_User : Evergreen.V1.Api.User.User -> Evergreen.V10.Api.User.User
migrate_Api_User_User old =
    { username = old.username
    , email = old.email
    , isAdmin = old.isAdmin
    }


migrate_Api_User_UserFull : Evergreen.V1.Api.User.UserFull -> Evergreen.V10.Api.User.UserFull
migrate_Api_User_UserFull old =
    { username = old.username
    , email = old.email
    , isAdmin = old.isAdmin
    , passwordHash = old.passwordHash
    , salt = old.salt
    }


migrate_Gen_Model_Model : Evergreen.V1.Gen.Model.Model -> Evergreen.V10.Gen.Model.Model
migrate_Gen_Model_Model old =
    case old of
        Evergreen.V1.Gen.Model.Redirecting_ ->
            Evergreen.V10.Gen.Model.Redirecting_

        Evergreen.V1.Gen.Model.AddSite p0 p1 ->
            Evergreen.V10.Gen.Model.AddSite p0 (p1 |> migrate_Pages_AddSite_Model)

        Evergreen.V1.Gen.Model.Admin p0 p1 ->
            Evergreen.V10.Gen.Model.Admin p0 (p1 |> migrate_Pages_Admin_Model)

        Evergreen.V1.Gen.Model.Home_ p0 p1 ->
            Evergreen.V10.Gen.Model.Home_ p0 (p1 |> migrate_Pages_Home__Model)

        Evergreen.V1.Gen.Model.Login p0 p1 ->
            Evergreen.V10.Gen.Model.Login p0 (p1 |> migrate_Pages_Login_Model)

        Evergreen.V1.Gen.Model.NotFound p0 ->
            Evergreen.V10.Gen.Model.NotFound p0

        Evergreen.V1.Gen.Model.Register p0 p1 ->
            Evergreen.V10.Gen.Model.Register p0 (p1 |> migrate_Pages_Register_Model)


migrate_Gen_Msg_Msg : Evergreen.V1.Gen.Msg.Msg -> Evergreen.V10.Gen.Msg.Msg
migrate_Gen_Msg_Msg old =
    case old of
        Evergreen.V1.Gen.Msg.AddSite p0 ->
            Evergreen.V10.Gen.Msg.AddSite (p0 |> migrate_Pages_AddSite_Msg)

        Evergreen.V1.Gen.Msg.Admin p0 ->
            Evergreen.V10.Gen.Msg.Admin (p0 |> migrate_Pages_Admin_Msg)

        Evergreen.V1.Gen.Msg.Home_ p0 ->
            Evergreen.V10.Gen.Msg.Home_ (p0 |> migrate_Pages_Home__Msg)

        Evergreen.V1.Gen.Msg.Login p0 ->
            Evergreen.V10.Gen.Msg.Login (p0 |> migrate_Pages_Login_Msg)

        Evergreen.V1.Gen.Msg.Register p0 ->
            Evergreen.V10.Gen.Msg.Register (p0 |> migrate_Pages_Register_Msg)


migrate_Gen_Pages_Model : Evergreen.V1.Gen.Pages.Model -> Evergreen.V10.Gen.Pages.Model
migrate_Gen_Pages_Model old =
    old |> migrate_Gen_Model_Model


migrate_Gen_Pages_Msg : Evergreen.V1.Gen.Pages.Msg -> Evergreen.V10.Gen.Pages.Msg
migrate_Gen_Pages_Msg old =
    old |> migrate_Gen_Msg_Msg


migrate_Pages_AddSite_Field : Evergreen.V1.Pages.AddSite.Field -> Evergreen.V10.Pages.AddSite.Field
migrate_Pages_AddSite_Field old =
    case old of
        Evergreen.V1.Pages.AddSite.Site ->
            Evergreen.V10.Pages.AddSite.Site

        Evergreen.V1.Pages.AddSite.Category ->
            Evergreen.V10.Pages.AddSite.Category

        Evergreen.V1.Pages.AddSite.FrontendLang ->
            Evergreen.V10.Pages.AddSite.FrontendLang


migrate_Pages_AddSite_Model : Evergreen.V1.Pages.AddSite.Model -> Evergreen.V10.Pages.AddSite.Model
migrate_Pages_AddSite_Model old =
    { site = old.site
    , category = old.category
    , frontendLang = old.frontendLang
    , message = Nothing
    }


migrate_Pages_AddSite_Msg : Evergreen.V1.Pages.AddSite.Msg -> Evergreen.V10.Pages.AddSite.Msg
migrate_Pages_AddSite_Msg old =
    case old of
        Evergreen.V1.Pages.AddSite.Updated p0 p1 ->
            Evergreen.V10.Pages.AddSite.Updated (p0 |> migrate_Pages_AddSite_Field) p1

        Evergreen.V1.Pages.AddSite.SubmitSite ->
            Evergreen.V10.Pages.AddSite.SubmitSite


migrate_Pages_Admin_Field : Evergreen.V1.Pages.Admin.Field -> Evergreen.V10.Pages.Admin.Field
migrate_Pages_Admin_Field old =
    case old of
        Evergreen.V1.Pages.Admin.Category ->
            Evergreen.V10.Pages.Admin.Category

        Evergreen.V1.Pages.Admin.FrontendLang ->
            Evergreen.V10.Pages.Admin.FrontendLang


migrate_Pages_Admin_Model : Evergreen.V1.Pages.Admin.Model -> Evergreen.V10.Pages.Admin.Model
migrate_Pages_Admin_Model old =
    old


migrate_Pages_Admin_Msg : Evergreen.V1.Pages.Admin.Msg -> Evergreen.V10.Pages.Admin.Msg
migrate_Pages_Admin_Msg old =
    case old of
        Evergreen.V1.Pages.Admin.ClickedDeleteSite p0 ->
            Evergreen.V10.Pages.Admin.ClickedDeleteSite p0

        Evergreen.V1.Pages.Admin.ClickedDelete p0 p1 ->
            Evergreen.V10.Pages.Admin.ClickedDelete (p0 |> migrate_Pages_Admin_Field) p1

        Evergreen.V1.Pages.Admin.ClickedChangeSort p0 ->
            Evergreen.V10.Pages.Admin.ClickedChangeSort (p0 |> migrate_Api_Site_Sort)

        Evergreen.V1.Pages.Admin.Updated p0 p1 ->
            Evergreen.V10.Pages.Admin.Updated (p0 |> migrate_Pages_Admin_Field) p1

        Evergreen.V1.Pages.Admin.ClickedSubmit p0 ->
            Evergreen.V10.Pages.Admin.ClickedSubmit (p0 |> migrate_Pages_Admin_Field)


migrate_Pages_Home__Model : Evergreen.V1.Pages.Home_.Model -> Evergreen.V10.Pages.Home_.Model
migrate_Pages_Home__Model old =
    { searchTerm = old.searchTerm
    , platform = Evergreen.V10.Api.Site.Mobile
    , expandedSite = Nothing
    }


migrate_Pages_Home__Msg : Evergreen.V1.Pages.Home_.Msg -> Evergreen.V10.Pages.Home_.Msg
migrate_Pages_Home__Msg old =
    case old of
        Evergreen.V1.Pages.Home_.ClickedChangeSort p0 ->
            Evergreen.V10.Pages.Home_.ClickedChangeSort (p0 |> migrate_Api_Site_Sort)

        Evergreen.V1.Pages.Home_.UpdatedSearchTerm p0 ->
            Evergreen.V10.Pages.Home_.UpdatedSearchTerm p0

        Evergreen.V1.Pages.Home_.NoOp ->
            Evergreen.V10.Pages.Home_.NoOp


migrate_Pages_Login_Field : Evergreen.V1.Pages.Login.Field -> Evergreen.V10.Pages.Login.Field
migrate_Pages_Login_Field old =
    case old of
        Evergreen.V1.Pages.Login.Email ->
            Evergreen.V10.Pages.Login.Email

        Evergreen.V1.Pages.Login.Password ->
            Evergreen.V10.Pages.Login.Password


migrate_Pages_Login_Model : Evergreen.V1.Pages.Login.Model -> Evergreen.V10.Pages.Login.Model
migrate_Pages_Login_Model old =
    old


migrate_Pages_Login_Msg : Evergreen.V1.Pages.Login.Msg -> Evergreen.V10.Pages.Login.Msg
migrate_Pages_Login_Msg old =
    case old of
        Evergreen.V1.Pages.Login.Updated p0 p1 ->
            Evergreen.V10.Pages.Login.Updated (p0 |> migrate_Pages_Login_Field) p1

        Evergreen.V1.Pages.Login.ClickedSubmit ->
            Evergreen.V10.Pages.Login.ClickedSubmit

        Evergreen.V1.Pages.Login.GotUser p0 ->
            Evergreen.V10.Pages.Login.GotUser (p0 |> migrate_Api_Data_Data migrate_Api_User_User)


migrate_Pages_Register_Field : Evergreen.V1.Pages.Register.Field -> Evergreen.V10.Pages.Register.Field
migrate_Pages_Register_Field old =
    case old of
        Evergreen.V1.Pages.Register.Username ->
            Evergreen.V10.Pages.Register.Username

        Evergreen.V1.Pages.Register.Email ->
            Evergreen.V10.Pages.Register.Email

        Evergreen.V1.Pages.Register.Password ->
            Evergreen.V10.Pages.Register.Password


migrate_Pages_Register_Model : Evergreen.V1.Pages.Register.Model -> Evergreen.V10.Pages.Register.Model
migrate_Pages_Register_Model old =
    old


migrate_Pages_Register_Msg : Evergreen.V1.Pages.Register.Msg -> Evergreen.V10.Pages.Register.Msg
migrate_Pages_Register_Msg old =
    case old of
        Evergreen.V1.Pages.Register.Updated p0 p1 ->
            Evergreen.V10.Pages.Register.Updated (p0 |> migrate_Pages_Register_Field) p1

        Evergreen.V1.Pages.Register.ClickedSubmit ->
            Evergreen.V10.Pages.Register.ClickedSubmit

        Evergreen.V1.Pages.Register.GotUser p0 ->
            Evergreen.V10.Pages.Register.GotUser (p0 |> migrate_Api_Data_Data migrate_Api_User_User)


migrate_Shared_Model : Evergreen.V1.Shared.Model -> Evergreen.V10.Shared.Model
migrate_Shared_Model old =
    { user = old.user |> Maybe.map migrate_Api_User_User
    , sites = old.sites |> Dict.map (\k -> migrate_Api_Site_Site)
    , sort = old.sort |> Tuple.mapBoth migrate_Api_Site_Sort migrate_Api_Site_Direction
    , categories = old.categories
    , frontendLangs = old.frontendLangs
    , viewportWidth = 0
    , menuOpen = False
    }


migrate_Shared_Msg : Evergreen.V1.Shared.Msg -> Evergreen.V10.Shared.Msg
migrate_Shared_Msg old =
    case old of
        Evergreen.V1.Shared.SignedInUser p0 ->
            Evergreen.V10.Shared.SignedInUser (p0 |> migrate_Api_User_User)

        Evergreen.V1.Shared.SignedOutUser ->
            Evergreen.V10.Shared.SignedOutUser

        Evergreen.V1.Shared.ChangedSort p0 ->
            Evergreen.V10.Shared.ChangedSort (p0 |> migrate_Api_Site_Sort)

        Evergreen.V1.Shared.GotSites p0 ->
            Evergreen.V10.Shared.GotSites (p0 |> Dict.map (\k -> migrate_Api_Site_Site))

        Evergreen.V1.Shared.GotCategories p0 ->
            Evergreen.V10.Shared.GotCategories p0

        Evergreen.V1.Shared.GotFrontendLangs p0 ->
            Evergreen.V10.Shared.GotFrontendLangs p0

        Evergreen.V1.Shared.ClickedSignOut ->
            Evergreen.V10.Shared.ClickedSignOut


migrate_Types_FrontendMsg : Evergreen.V1.Types.FrontendMsg -> Evergreen.V10.Types.FrontendMsg
migrate_Types_FrontendMsg old =
    case old of
        Evergreen.V1.Types.ChangedUrl p0 ->
            Evergreen.V10.Types.ChangedUrl p0

        Evergreen.V1.Types.ClickedLink p0 ->
            Evergreen.V10.Types.ClickedLink p0

        Evergreen.V1.Types.Shared p0 ->
            Evergreen.V10.Types.Shared (p0 |> migrate_Shared_Msg)

        Evergreen.V1.Types.Page p0 ->
            Evergreen.V10.Types.Page (p0 |> migrate_Gen_Pages_Msg)

        Evergreen.V1.Types.Noop ->
            Evergreen.V10.Types.Noop


migrate_Types_ToFrontend : Evergreen.V1.Types.ToFrontend -> Evergreen.V10.Types.ToFrontend
migrate_Types_ToFrontend old =
    case old of
        Evergreen.V1.Types.PageMsg p0 ->
            Evergreen.V10.Types.PageMsg (p0 |> migrate_Gen_Pages_Msg)

        Evergreen.V1.Types.SignInUser p0 ->
            Evergreen.V10.Types.SignInUser (p0 |> migrate_Api_User_User)

        Evergreen.V1.Types.SignOutUser ->
            Evergreen.V10.Types.SignOutUser

        Evergreen.V1.Types.SendSites p0 ->
            Evergreen.V10.Types.SendSites (p0 |> Dict.map (\k -> migrate_Api_Site_Site))

        Evergreen.V1.Types.SendCategories p0 ->
            Evergreen.V10.Types.SendCategories p0

        Evergreen.V1.Types.SendFrontendLangs p0 ->
            Evergreen.V10.Types.SendFrontendLangs p0

        Evergreen.V1.Types.NoOpToFrontend ->
            Evergreen.V10.Types.NoOpToFrontend
