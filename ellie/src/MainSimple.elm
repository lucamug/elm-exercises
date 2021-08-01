port module MainSimple exposing (main)

import Exercises exposing (..)



-- g o al
--
-- (\f1 -> f1 "g") (\s1 f2 -> f2 (s1 ++ "o")) (\s2 -> s2 ++ "al")


g : (String -> a) -> a
g f1 =
    f1 "g"


o : String -> (String -> a) -> a
o s1 f2 =
    f2 (s1 ++ "o")


al : String -> String
al s2 =
    s2 ++ "al"


last : List a -> Maybe a
last list =
    let
        _ =
            Debug.log "xxx" <| g al
    in
    case list of
        [] ->
            Nothing

        x :: xs ->
            Just (List.foldl (\y _ -> y) x xs)


last2 : List a -> Maybe a
last2 list =
    -- Your implementation goes here
    Nothing


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
