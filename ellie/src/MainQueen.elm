module MainQueen exposing (..)

import Html
import List.Extra


type alias State =
    List ( Int, Int )


type alias Solutions =
    List (List Int)


stateToSolution : List ( a, b ) -> List b
stateToSolution =
    List.map Tuple.second


isQueenAttacked : Int -> Int -> State -> Bool
isQueenAttacked y x state =
    List.any
        (\( yy, xx ) ->
            xx == x || yy == y || abs (yy - y) == abs (xx - x)
        )
        state


cycle : Int -> List State -> State -> ( List State, List State )
cycle boardSize solutions state =
    let
        y : Int
        y =
            List.length state
    in
    if y < boardSize then
        List.range 0 (boardSize - 1)
            |> List.filter (\x -> not (isQueenAttacked y x state))
            |> List.map (\x -> ( y, x ) :: state)
            |> List.map (cycle boardSize solutions)
            |> List.unzip
            |> Tuple.mapBoth List.concat List.concat

    else
        ( [], state :: solutions )


queen : Int -> List State
queen n =
    cycle n [] []
        |> Tuple.second


visualize : State -> List (List Char)
visualize state =
    List.map
        (\( y, x ) ->
            List.Extra.setAt x '♛' (List.repeat (List.length state) '•')
        )
        state


main : Html.Html msg
main =
    let
        queenSolutions : List State
        queenSolutions =
            queen 8
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
