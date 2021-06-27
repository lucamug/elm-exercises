module MainWithTea exposing (..)

import Browser
import Codec
import Element exposing (..)
import Exercises exposing (..)
import Html
import Html.Events
import List.Extra
import Random


manyOf : Random.Seed -> Int -> List a -> List a -> ( List a, Random.Seed )
manyOf seed n source acc =
    let
        ( x, seed2 ) =
            Random.step (select source) seed
    in
    if n < 1 then
        ( acc, seed )

    else
        ( x
            ++ Tuple.first
                (manyOf seed2 (n - 1) (removeElements x source) acc)
        , seed2
        )


randomSelect : Random.Seed -> Int -> List a -> ( List a, Random.Seed )
randomSelect seed n source =
    manyOf seed n source []


removeElements : List a -> List a -> List a
removeElements exclude source =
    List.filter (\x -> not (List.member x exclude)) source


select : List a -> Random.Generator (List a)
select list =
    Random.map (\y -> list |> List.drop y |> List.take 1) (Random.int 0 (List.length list - 1))



--
-- randomSelect : Random.Seed -> Int -> List a -> ( List a, Random.Seed )
-- randomSelect seed n list =
--     let
--         ( l, r, s ) =
--             randSelect n ( [], list, seed )
--     in
--     ( l, s )
--
--
-- randSelect : Int -> ( List a, List a, Random.Seed ) -> ( List a, List a, Random.Seed )
-- randSelect n ( l, r, seed ) =
--     if n > 0 then
--         let
--             ( idx, seed_ ) =
--                 Random.step (Random.int 1 (List.length r)) seed
--
--             e =
--                 List.Extra.getAt (idx - 1) r
--
--             r_ =
--                 List.Extra.removeAt (idx - 1) r
--         in
--         case e of
--             Nothing ->
--                 ( l, r, seed )
--
--             Just x ->
--                 randSelect (n - 1) ( x :: l, r_, seed_ )
--
--     else
--         ( l, r, seed )
--
--
--
-- randomSelect : Random.Seed -> Int -> List a -> ( List a, Random.Seed )
-- randomSelect seed n list =
--     -- Your implementation goes here
--     ( [], seed )
--


main : Program Flags (Model ModelExercise) (Msg MsgExercise)
main =
    exerciseWithTea
        { tests =
            -- Your implementation should pass
            -- these tests
            \model ->
                let
                    seed =
                        Random.initialSeed model.intSeed

                    ( l1, s1 ) =
                        randomSelect seed 3 (List.range 1 1000)

                    ( l2, s2 ) =
                        randomSelect seed 3 (List.range 1 1000)

                    ( l3, s3 ) =
                        randomSelect s2 3 (List.range 1 1000)

                    ( l4, s4 ) =
                        randomSelect s3 9 (List.range 1 9)

                    ( l5, s5 ) =
                        randomSelect s4 3 [ "a", "b" ]

                    ( l6, s6 ) =
                        randomSelect s5 0 [ 'a', 'b' ]

                    ( l7, s7 ) =
                        randomSelect s6 -1 [ 'a', 'b' ]

                    ( l8, s8 ) =
                        randomSelect s6 1 []
                in
                [ List.sort l1 |> equal (List.sort l2)
                , l2 |> notEqual l3
                , List.sort l4 |> equal (List.range 1 9)
                , List.sort l5 |> equal [ "a", "b" ]
                , l6 |> equal []
                , l7 |> equal []
                , l8 |> equal []
                ]
        , init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias ModelExercise =
    { intSeed : Int }


init : ( ModelExercise, Cmd MsgExercise )
init =
    ( { intSeed = 1 }, Random.generate NewFace (Random.int Random.minInt Random.maxInt) )



-- UPDATE


type MsgExercise
    = Test
    | NewFace Int


update : MsgExercise -> ModelExercise -> ( ModelExercise, Cmd MsgExercise )
update msg model =
    case msg of
        Test ->
            ( model, Random.generate NewFace (Random.int Random.minInt Random.maxInt) )

        NewFace newSeed ->
            ( { model | intSeed = newSeed }, Cmd.none )



-- TODO - Combine together the test passed by current implementation
--      - Maybe having a special Exercises.exercise that inject some element
--      - in the middle of the page
--
--      - Make tow example, without TEA and with TEA.
-- SUBSCRIPTIONS


subscriptions : ModelExercise -> Sub MsgExercise
subscriptions model =
    Sub.none



-- VIEW


view : ModelExercise -> Html.Html MsgExercise
view model =
    Html.div []
        [ Html.p [] [ Html.text ("Seed value: " ++ String.fromInt model.intSeed) ]
        , Html.p [] [ Html.text ("Your die roll is " ++ (Maybe.withDefault "" <| Maybe.map String.fromInt <| List.head <| Tuple.first <| randomSelect (Random.initialSeed model.intSeed) 1 (List.range 1 6))) ]
        , Html.button [ Html.Events.onClick Test ] [ Html.text "Test again" ]
        ]
