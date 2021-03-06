port module D100_exerciseSimple exposing (main)

import Exercises exposing (..)



-- g : (String -> a) -> a
-- g f =
--     f "g"
--
--
-- o : String -> (String -> a) -> a
-- o s f =
--     f (s ++ "o")
--
--
-- al : String -> String
-- al s =
--     s ++ "al"


g f =
    -- Your implementation goes here
    f ""


o s f =
    -- Your implementation goes here
    f ""


al s =
    -- Your implementation goes here
    ""


tests : List Test
tests =
    -- Your implementation should pass
    -- these tests
    [ g o o o o o o o al |> equal "goooooooal"
    , g o al |> equal "goal"
    , g al |> equal "gal"
    ]


main : Program Flags (Model ()) (Msg ())
main =
    exercise
        { tests = tests
        , portLocalStoragePop = portLocalStoragePop
        , portLocalStoragePush = portLocalStoragePush
        }


port portLocalStoragePop : (String -> msg) -> Sub msg


port portLocalStoragePush : String -> Cmd msg
