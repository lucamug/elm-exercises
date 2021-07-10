port module MainSimple exposing (main)

import Exercises exposing (..)


last : List a -> Maybe a
last list =
    case list of
        [] ->
            Nothing

        [ a ] ->
            Just a

        x :: xs ->
            last xs



--
-- last : List a -> Maybe a
-- last list =
--     -- Your implementation goes here
--     Nothing
--


tests : List Test
tests =
    -- Your implementation should pass
    -- these tests
    [ last [ 1, 2, 3, 4 ] |> equal (Just 4)
    , last [ 1 ] |> equal (Just 1)
    , last [] |> equal Nothing
    , last [ 'a', 'b', 'c' ] |> equal (Just 'c')
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
