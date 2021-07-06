module MainQueen exposing (..)

import Html
import List.Extra


type alias Bo a b c number =
    { actions : State -> List { result : State, stepCost : Int }
    , goalTest : List a -> Bool
    , heuristic : b -> number
    , initialState : List c
    , stateToString : State -> String
    }


incrementalEightQueens : Bo a b c number
incrementalEightQueens =
    incrementalNQueens 8


incrementalNQueens : Int -> Bo a b c number
incrementalNQueens n =
    { initialState = []
    , actions = actions n
    , heuristic = \_ -> 0
    , goalTest = \state -> List.length state == n
    , stateToString = List.map (\( a, b ) -> String.fromInt a ++ "," ++ String.fromInt b) >> String.concat
    }


visualize : State -> List (List Int)
visualize state =
    List.map
        (\( y, x ) ->
            List.Extra.setAt x 1 (List.repeat (List.length state) 0)
        )
        state


actions :
    Int
    -> State
    -> List { result : State, stepCost : Int }
actions n state =
    let
        y =
            List.length state
    in
    if y < n then
        List.range 0 (n - 1)
            |> List.filter (\x -> not (isAttacked y x state))
            |> List.map (\x -> { stepCost = 1, result = ( y, x ) :: state })

    else
        []



--
--
--
--
--


type alias State =
    List ( Int, Int )



-- xxx: [1,3,0,2]
-- xxx: [2,0,3,1]
--
-- __x_
-- x___
-- ___X
-- _X__
--
-- _x__
-- ___x
-- x___
-- __x_


type alias Solutions =
    List (List Int)


stateToSolution : List ( a, b ) -> List b
stateToSolution =
    List.map Tuple.second


actions2 : Int -> Solutions -> State -> ( List State, Solutions )
actions2 n solutions state =
    let
        _ =
            if y == n then
                Debug.log "Solution" (stateToSolution state)

            else
                stateToSolution state

        newSolutions =
            if y == n then
                stateToSolution state :: solutions

            else
                solutions

        y =
            List.length state
    in
    if y < n then
        ( List.range 0 (n - 1)
            |> List.filter (\x -> not (isAttacked y x state))
            |> List.map (\x -> ( y, x ) :: state)
            |> List.map
                (\state_ ->
                    let
                        _ =
                            Debug.log "xxx" solutions_

                        ( listState, solutions_ ) =
                            actions2 n newSolutions state_
                    in
                    listState
                )
            |> List.concat
        , solutions
        )

    else
        ( [], newSolutions )


main : Html.Html msg
main =
    Html.text <| Debug.toString <| actions2 4 [] []


isAttacked : Int -> Int -> State -> Bool
isAttacked y x state =
    List.any
        (\( yy, xx ) ->
            xx == x || yy == y || abs (yy - y) == abs (xx - x)
        )
        state
