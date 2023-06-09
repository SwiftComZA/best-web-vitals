module Gen.Msg exposing (Msg(..))

import Gen.Params.AddSite
import Gen.Params.Admin
import Gen.Params.Home_
import Gen.Params.Login
import Gen.Params.NotFound
import Gen.Params.Register
import Pages.AddSite
import Pages.Admin
import Pages.Home_
import Pages.Login
import Pages.NotFound
import Pages.Register


type Msg
    = AddSite Pages.AddSite.Msg
    | Admin Pages.Admin.Msg
    | Home_ Pages.Home_.Msg
    | Login Pages.Login.Msg
    | Register Pages.Register.Msg

