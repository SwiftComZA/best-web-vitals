module Utils.List exposing (..)


with : List a -> List a -> List a
with rightList leftList =
    leftList ++ rightList


withIf : Bool -> List a -> List a -> List a
withIf cond rightList leftList =
    if cond then
        leftList ++ rightList

    else
        leftList
