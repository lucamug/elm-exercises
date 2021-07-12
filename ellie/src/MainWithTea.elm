port module MainWithTea exposing (..)

import Element exposing (..)
import Element.Border as Border
import Element.Input as Input
import Exercises exposing (..)
import Random


randomSelect : Random.Seed -> Int -> List a -> ( List a, Random.Seed )
randomSelect seed n list =
    -- Your implementation goes here
    ( [], seed )


tests : ModelExercise -> List Test
tests modelExercise =
    -- Your implementation should pass
    -- these tests
    let
        seed =
            Random.initialSeed modelExercise.intSeed

        ( list1, seed1 ) =
            randomSelect seed 3 (List.range 1 1000)

        ( list2, seed2 ) =
            randomSelect seed 3 (List.range 1 1000)

        ( list3, seed3 ) =
            randomSelect seed2 3 (List.range 1 1000)

        ( list4, seed4 ) =
            randomSelect seed3 9 (List.range 1 9)

        ( list5, seed5 ) =
            randomSelect seed4 3 [ "a", "b" ]

        ( list6, seed6 ) =
            randomSelect seed5 0 [ 'a', 'b' ]

        ( list7, seed7 ) =
            randomSelect seed6 -1 [ 'a', 'b' ]

        ( list8, seed8 ) =
            randomSelect seed6 1 []
    in
    [ List.sort list1 |> equal (List.sort list2)
    , list2 |> notEqual list3
    , List.sort list4 |> equal (List.range 1 9)
    , List.sort list5 |> equal [ "a", "b" ]
    , list6 |> equal []
    , list7 |> equal []
    , list8 |> equal []
    ]


main : Program Flags (Model ModelExercise) (Msg MsgExercise)
main =
    exerciseWithTea
        { tests = tests
        , init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , portLocalStoragePop = portLocalStoragePop
        , portLocalStoragePush = portLocalStoragePush
        }


port portLocalStoragePop : (String -> msg) -> Sub msg


port portLocalStoragePush : String -> Cmd msg



-- MODEL


type alias ModelExercise =
    { intSeed : Int }



-- INIT


init : ( ModelExercise, Cmd MsgExercise )
init =
    ( { intSeed = 1 }, Random.generate NewFace (Random.int Random.minInt Random.maxInt) )



-- MSG


type MsgExercise
    = Test
    | NewFace Int



-- UPDATE


update : MsgExercise -> ModelExercise -> ( ModelExercise, Cmd MsgExercise )
update msg model =
    case msg of
        Test ->
            ( model, Random.generate NewFace (Random.int Random.minInt Random.maxInt) )

        NewFace newSeed ->
            ( { model | intSeed = newSeed }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : ModelExercise -> Sub MsgExercise
subscriptions model =
    Sub.none



-- VIEW


view : ModelExercise -> Element MsgExercise
view model =
    column [ spacing 10 ]
        [ paragraph [] [ text ("Seed value: " ++ String.fromInt model.intSeed) ]
        , paragraph [] [ text ("Your die roll is " ++ (Maybe.withDefault "" <| Maybe.map String.fromInt <| List.head <| Tuple.first <| randomSelect (Random.initialSeed model.intSeed) 1 (List.range 1 6))) ]
        , Input.button attrsButton
            { onPress = Just Test
            , label = text "Test again"
            }
        ]
