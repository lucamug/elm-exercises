module MainQueen exposing (..)

import Html
import List.Extra


visualize : State -> List (List Int)
visualize state =
    List.map
        (\( y, x ) ->
            List.Extra.setAt x 1 (List.repeat (List.length state) 0)
        )
        state


type alias State =
    List ( Int, Int )


type alias Solutions =
    List (List Int)


stateToSolution : List ( a, b ) -> List b
stateToSolution =
    List.map Tuple.second


actions2 : Int -> Solutions -> State -> ( List State, Solutions )
actions2 n solutions state =
    let
        y =
            List.length state
    in
    if y < n then
        List.range 0 (n - 1)
            |> List.filter (\x -> not (isAttacked y x state))
            |> List.map (\x -> ( y, x ) :: state)
            |> List.map (actions2 n solutions)
            |> List.unzip
            |> (\( a, b ) -> ( List.concat a, List.concat b ))

    else
        ( [], stateToSolution state :: solutions )


main : Html.Html msg
main =
    Html.text <| Debug.toString <| Tuple.second <| actions2 8 [] []


isAttacked : Int -> Int -> State -> Bool
isAttacked y x state =
    List.any
        (\( yy, xx ) ->
            xx == x || yy == y || abs (yy - y) == abs (xx - x)
        )
        state
