module MainSimple exposing (main)

import Exercises exposing (..)


last : List a -> Maybe a
last xs =
    -- Your implementation goes here
    Nothing


main : Program Flags (Exercises.Model ()) (Exercises.Msg ())
main =
    exercise
        -- Your implementation should pass
        -- these tests
        -- [ last [ 1, 2, 3, 4 ] == Just 4
        -- , last [ 1 ] == Just 1
        -- , last [] == Nothing
        -- , last [ 'a', 'b', 'c' ] == Just 'c'
        -- ]
        testNEW


testNEW : List Expectation
testNEW =
    -- Your implementation should pass
    -- these tests
    [ last [ 1, 2, 3, 4 ] |> equal (Just 4)
    , last [ 1 ] |> equal (Just 1)
    , last [] |> equal Nothing
    , last [ 'a', 'b', 'c' ] |> equal (Just 'c')
    ]
