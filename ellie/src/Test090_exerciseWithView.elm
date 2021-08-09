port module Test090_exerciseWithView exposing (main)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Exercises exposing (..)
import List.Extra


queens2 : Int -> List (List Int)
queens2 n =
    -- Your implementation goes here
    []


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
            |> List.filter (\x -> not (isQueenUnderAttack y x state))
            |> List.map (\x -> ( y, x ) :: state)
            |> List.map (oneMoreQueen boardSize solutions)
            |> List.unzip
            |> Tuple.mapBoth List.concat List.concat

    else
        ( [], state :: solutions )


isQueenUnderAttack : Int -> Int -> State -> Bool
isQueenUnderAttack y x state =
    List.any
        (\( yy, xx ) ->
            xx == x || yy == y || abs (yy - y) == abs (xx - x)
        )
        state


tests : List Test
tests =
    -- Your implementation should pass
    -- these tests
    [ List.length (queens 3) |> equal 0
    , List.length (queens 4) |> equal 2
    , List.length (queens 5) |> equal 10
    , List.length (queens 6) |> equal 4
    , List.length (queens 7) |> equal 40
    , List.length (queens 8) |> equal 92
    ]


view : Element msg
view =
    column [ spacing 20, width fill ] <|
        List.map
            (\n ->
                let
                    solutions : List (List Int)
                    solutions =
                        queens n

                    boards : List (List (List Char))
                    boards =
                        List.map (\solution -> visualize solution) solutions
                in
                boards
                    |> List.indexedMap (boardToElement n)
                    |> row [ spacing 15, scrollbars, width fill ]
                    |> (\board ->
                            column [ spacing 5, width fill ]
                                [ text <| String.fromInt n ++ " X " ++ String.fromInt n ++ " (" ++ String.fromInt (List.length boards) ++ " solutions)"
                                , board
                                ]
                       )
            )
            (List.range 3 8)


visualize : List Int -> List (List Char)
visualize solution =
    List.indexedMap
        (\index x ->
            List.Extra.setAt x '♛' (List.repeat (List.length solution) '•')
        )
        solution


attrs : Int -> Int -> List (Attribute msg)
attrs x y =
    [ width <| px 30
    , height <| px 30
    , Background.color <|
        if modBy 2 (x + y) == 0 then
            rgb255 254 207 157

        else
            rgb255 211 138 70
    ]


boardToElement : Int -> Int -> List (List Char) -> Element msg
boardToElement n s board =
    column
        [ Border.width 1
        , Border.color <| rgb 0.6 0.6 0.6
        , inFront <|
            el
                [ Font.size (n * 24)
                , Font.bold
                , centerX
                , centerY
                , alpha 0.3
                ]
            <|
                text <|
                    String.fromInt (s + 1)
        ]
    <|
        List.indexedMap
            (\y row_ ->
                row [] <|
                    List.indexedMap
                        (\x char ->
                            if char == '♛' then
                                image
                                    (attrs x y)
                                    { src = "/images/Chess_qlt45.svg.png"
                                    , description = ""
                                    }

                            else
                                el (attrs x y) none
                        )
                        row_
            )
            board


main : Program Flags (Model ()) (Msg ())
main =
    exerciseWithView
        { tests = tests
        , view = view
        , portLocalStoragePop = portLocalStoragePop
        , portLocalStoragePush = portLocalStoragePush
        }


port portLocalStoragePop : (String -> msg) -> Sub msg


port portLocalStoragePush : String -> Cmd msg
