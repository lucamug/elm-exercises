module E001 exposing (exerciseData)

import Exercises exposing (..)


exerciseData : ExerciseData
exerciseData =
    { id = 1
    , title = "Returns the last element of a list"
    , difficulty = difficulty.easy
    , categories = [ "Lists", "Recursion" ]

    -- , ellieId = "dFhBMLPrtWsa1"
    , ellieId = "dZnNLKLm2GSa1"
    , reference = "https://johncrane.gitbooks.io/ninety-nine-elm-problems/content/p/p01.html"
    , problem = "Write a function `last` that returns the last element of a list. An empty list doesn't have a last element, therefore `last` must return a `Maybe`."
    , example = "last [ 1, 2, 3, 4 ] == Just 4\n\nlast [] == Nothing"
    , tests =
        [ "last [ 1, 2, 3, 4 ] |> equal (Just 4)"
        , "last [ 1 ] |> equal (Just 1)"
        , "last [] |> equal Nothing"
        , "last [ 'a', 'b', 'c' ] |> equal (Just 'c')"
        ]
    , hints =
        [ "Use recursion."
        , "How can you leverage a List's `head` function to solve this problem?"
        ]
    , dummySolution = """last : List a -> Maybe a
last xs =
    -- """ ++ yourImplementationGoesHere ++ """
    Nothing"""
    , solutions =
        [ """Recursive search for the last element.
```
last : List a -> Maybe a
last list =
    case list of
        [] ->
            Nothing

        [ a ] ->
            Just a

        x :: xs ->
            last xs
```"""
        , """Reverse and take the head.
```
last : List a -> Maybe a
last list =
    List.reverse list |> List.head
```"""
        , """[Point-free style](https://en.wikipedia.org/wiki/Tacit_programming), reverse and take the head.
```
last : List a -> Maybe a
last =
    List.reverse >> List.head
```"""
        , """Use `List.foldl`.
```
last : List a -> Maybe a
last list =
    case list of
        [] ->
            Nothing

        x :: xs ->
            Just (List.foldl (\\y _ -> y) x xs)
```"""
        ]
    }
