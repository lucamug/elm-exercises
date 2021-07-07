module MainWithView exposing (main)

import Element exposing (..)
import Exercises exposing (..)



--
-- queens : Int -> List (List Int)
-- queens n =
--     -- Your implementation goes here
--     []
--


queens : Int -> List (List Int)
queens n =
    oneMoreQueen n [] []
        |> Tuple.second
        |> List.map (List.map Tuple.second)


type alias State =
    List ( Int, Int )


oneMoreQueen : Int -> List State -> State -> ( List State, List State )
oneMoreQueen boardSize solutions state =
    let
        y : Int
        y =
            List.length state
    in
    if y < boardSize then
        List.range 0 (boardSize - 1)
            |> List.filter (\x -> not (isQueenAttacked y x state))
            |> List.map (\x -> ( y, x ) :: state)
            |> List.map (oneMoreQueen boardSize solutions)
            |> List.unzip
            |> Tuple.mapBoth List.concat List.concat

    else
        ( [], state :: solutions )


isQueenAttacked : Int -> Int -> State -> Bool
isQueenAttacked y x state =
    List.any
        (\( yy, xx ) ->
            xx == x || yy == y || abs (yy - y) == abs (xx - x)
        )
        state


tests : List Test
tests =
    -- Your implementation should pass
    -- these tests
    [ List.length (queens 8) |> equal 92
    , List.length (queens 7) |> equal 40
    , List.length (queens 6) |> equal 4
    , List.length (queens 5) |> equal 10
    , List.length (queens 4) |> equal 2
    , List.length (queens 3) |> equal 0
    , List.length (queens 2) |> equal 0
    , List.length (queens 1) |> equal 1
    , List.length (queens 0) |> equal 1
    ]


view : Element msg
view =
    text "Hi"


main : Program Flags (Model ()) (Msg ())
main =
    exerciseWithView
        { tests = tests
        , view = view
        }
