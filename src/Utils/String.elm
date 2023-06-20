module Utils.String exposing (..)


with : String -> String -> String
with rightList leftList =
    leftList ++ rightList


withIf : Bool -> String -> String -> String
withIf cond rightList leftList =
    if cond then
        leftList ++ rightList

    else
        leftList
