module E023 exposing (exerciseData)

import Exercises exposing (..)


exerciseData : ExerciseData
exerciseData =
    { id = 23
    , title = "Extract randomly selected elements from a list"
    , difficulty = difficulty.hard
    , categories = [ "Randomness" ]

    -- , ellieId = "dFdF4NRQPVSa1"
    , ellieId = "dZgZqMHCKvWa1"
    , reference = "https://johncrane.gitbooks.io/ninety-nine-elm-problems/content/p/p23.html"
    , problem = """Extract a given number of randomly selected elements from a list.

You must use [Elm's Random](https://package.elm-lang.org/packages/elm/random/latest/) to implement `randomSelect`. Use [`Random.step`](https://package.elm-lang.org/packages/elm/random/latest/Random#step) to generate a pseudo-random number. `Random.step` takes a [`Generator`](https://package.elm-lang.org/packages/elm/random/latest/Random#Generator) and a [`Seed`](https://package.elm-lang.org/packages/elm/random/latest/Random#Seed). The seed is passed as a parameter to `randomSelect`. You will need to create a generator such as [`Random.int`](https://package.elm-lang.org/packages/elm/random/latest/Random#int).

`Random.step` will return both a randomly generated value from the generator, and a new seed. You must use the new seed for subsequent random numbers."""
    , example = """randomSelect seed 3 ["Al", "Biff", "Cal", "Dee", "Ed", "Flip"] == ["Cal", "Dee", "Al"]"""
    , tests =
        [ "List.sort list1 |> equal (List.sort list2)"
        , "list2 |> notEqual list3"
        , "List.sort list4 |> equal (List.range 1 9)"
        , "List.sort list5 |> equal [ \"a\", \"b\" ]"
        , "list6 |> equal []"
        , "list7 |> equal []"
        , "list8 |> equal []"
        ]
    , hints =
        [ "[`getAt`](https://package.elm-lang.org/packages/elm-community/list-extra/latest/List-Extra#getAt) and [`removeAt`](https://package.elm-lang.org/packages/elm-community/list-extra/latest/List-Extra#removeAt) from `elm-community/list-extra` could prove useful."
        , "A more Elm-ish solution would be to define a new `Random.Generator`."
        ]
    , dummySolution = """randomSelect : Random.Seed -> Int -> List a -> ( List a, Random.Seed )
randomSelect seed n list =
    -- """ ++ yourImplementationGoesHere ++ """
    ( [], seed )"""
    , solutions = [ """Using [`getAt`](https://package.elm-lang.org/packages/elm-community/list-extra/latest/List-Extra#getAt) and [`removeAt`](https://package.elm-lang.org/packages/elm-community/list-extra/latest/List-Extra#removeAt) from `elm-community/list-extra`.
    
```elm
import List.Extra


randomSelect : Random.Seed -> Int -> List a -> ( List a, Random.Seed )
randomSelect seed n list =
    let
        ( l, r, s ) =
            randSelect n ( [], list, seed )
    in
    ( l, s )


randSelect : Int -> ( List a, List a, Random.Seed ) -> ( List a, List a, Random.Seed )
randSelect n ( l, r, seed ) =
    if n > 0 then
        let
            ( idx, seed_ ) =
                Random.step (Random.int 1 (List.length r)) seed

            e =
                List.Extra.getAt (idx - 1) r

            r_ =
                List.Extra.removeAt (idx - 1) r
        in
        case e of
            Nothing ->
                ( l, r, seed )

            Just x ->
                randSelect (n - 1) ( x :: l, r_, seed_ )

    else
        ( l, r, seed )
```""", """Defining a new `Random.Generator`

```elm
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
    List.filter (\\x -> not (List.member x exclude)) source


select : List a -> Random.Generator (List a)
select list =
    Random.map (\\y -> list |> List.drop y |> List.take 1) (Random.int 0 (List.length list - 1))
```""" ]
    }
