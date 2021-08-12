module E090 exposing (exerciseData)

import Exercises exposing (..)


exerciseData : ExerciseData
exerciseData =
    { id = 90
    , title = "The \"Eight queens puzzle\""
    , difficulty = difficulty.hard
    , categories = [ "Puzzles", "Recursion" ]
    , ellieId = "dFdF4NRQPVSa1"
    , reference = "https://johncrane.gitbooks.io/ninety-nine-elm-problems/content/p/p90.html"
    , problem = """The [Eight queens puzzle](https://en.wikipedia.org/wiki/Eight_queens_puzzle) is a classical puzzle in computer science. The objective is to place eight queens on a chessboard so that no two queens are attacking each other; that is no two queens are in the same row, the same column, or on the same diagonal. For example:

![8 Queens Puzzle](https://elm-exercises.netlify.app/images/8-queens-puzzle.png)        
        
Represent the positions of the queens as a list of numbers 1..N. Example: [4,2,7,3,6,8,5,1] means that the queen in the first column is in row 4, the queen in the second column is in row 2, etc.
"""
    , example = ""
    , tests =
        [ "List.length (queens 8) |> equal 92"
        , "List.length (queens 7) |> equal 40"
        , "List.length (queens 6) |> equal 4"
        , "List.length (queens 5) |> equal 10"
        , "List.length (queens 4) |> equal 2"
        , "List.length (queens 3) |> equal 0"
        , "List.length (queens 2) |> equal 0"
        , "List.length (queens 1) |> equal 1"
        , "List.length (queens 0) |> equal 1"
        ]
    , hints =
        -- Add this: https://stackoverflow.com/questions/19998153/algorithm-of-n-queens
        [ """How about this idea? (from [Stack Overflow](https://stackoverflow.com/questions/19998153/algorithm-of-n-queens))
            
```            
try to place first queen
success
   try to place second queen
   success
      try to place third queen
      fail
   try to place second queen in another position
   success
      try to place third queen
      success
         try to place fourth queen
```
""" ]
    , dummySolution = """queens : Int -> List (List Int)
queens n = 
    -- """ ++ yourImplementationGoesHere ++ """
    []"""
    , solutions = [ """Solution by [lucamug](https://twitter.com/luca_mug) "inspired by" [rosettacode.org/wiki/N-queens_problem](http://rosettacode.org/wiki/N-queens_problem#Haskell) and [davidpomerenke/elm-problem-solving](https://package.elm-lang.org/packages/davidpomerenke/elm-problem-solving/latest/Problem-Example#queens).

```
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
            |> List.filter (\\x -> not (isQueenUnderAttack y x state))
            |> List.map (\\x -> ( y, x ) :: state)
            |> List.map (oneMoreQueen boardSize solutions)
            |> List.unzip
            |> Tuple.mapBoth List.concat List.concat

    else
        ( [], state :: solutions )


isQueenUnderAttack : Int -> Int -> State -> Bool
isQueenUnderAttack y x state =
    List.any
        (\\( yy, xx ) ->
            xx == x || yy == y || abs (yy - y) == abs (xx - x)
        )
        state
```""" ]
    }
