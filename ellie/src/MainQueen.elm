module MainQueen exposing (..)

import Html
import List.Extra



-- inspired by
--
-- http://rosettacode.org/wiki/N-queens_problem#Haskell


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



--
--
--
--
--


visualize : List Int -> List (List Char)
visualize solution =
    List.indexedMap
        (\index x ->
            List.Extra.setAt x '♛' (List.repeat (List.length solution) '•')
        )
        solution


main : Html.Html msg
main =
    let
        queenSolutions : List (List Int)
        queenSolutions =
            queens 8
    in
    Html.div [] <|
        List.indexedMap
            (\index state ->
                Html.div []
                    [ Html.p [] [ Html.text <| "Solution " ++ String.fromInt (index + 1) ]
                    , Html.div [] <|
                        List.map
                            (\row ->
                                Html.pre []
                                    [ Html.text <| String.fromList row
                                    ]
                            )
                            (visualize state)
                    ]
            )
            queenSolutions
