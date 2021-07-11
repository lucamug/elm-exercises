module E002 exposing (exerciseData)

import Exercises exposing (..)


exerciseData : ExerciseData
exerciseData =
    { id = 2
    , title = "Find the next to last element of a list"
    , difficulty = difficulty.easy
    , categories = [ "Lists", "Recursion" ]
    , ellieId = "dFdvdf7wKmQa1"
    , reference = "https://johncrane.gitbooks.io/ninety-nine-elm-problems/content/p/p02.html"
    , problem = "Implement the function `penultimate` to find the next to last element of a list."
    , tests =
        [ "penultimate [ 1, 2, 3, 4 ] |> equal (Just 3)"
        , "penultimate [ 1, 2 ] |> equal (Just 1)"
        , "penultimate [ 1 ] |> equal Nothing"
        , "penultimate [] |> equal Nothing"
        , """penultimate [ "a", "b", "c" ] |> equal (Just "b")"""
        , """penultimate [ "a" ] |> equal Nothing"""
        ]
    , hints =
        [ "Use recursion."
        , "What can you do to a list to make [List.head](https://package.elm-lang.org/packages/elm/core/latest/List#head) solve this problem?"
        ]
    , dummySolution = """penultimate : List a -> Maybe a
penultimate list =
    -- """ ++ yourImplementationGoesHere ++ """
    Nothing"""
    , solutions =
        [ """Recursive search for the last element
```
penultimate : List a -> Maybe a
penultimate list =
    case list of
        [] ->
            Nothing

        [ y ] ->
            Nothing

        [ y, z ] ->
            Just y

        y :: ys ->
            penultimate ys
```"""
        , """Reverse the list and take the head of the tail.
```
penultimate : List a -> Maybe a
penultimate list =
    case List.reverse list of
        [] ->
            Nothing

        y :: ys ->
            List.head ys
```"""
        , """Reverse the list, drop one and take the head.
```
penultimate : List a -> Maybe a
penultimate list =
    case List.drop 1 (List.reverse list) of
        [] ->
            Nothing

        y :: ys ->
            Just y
```"""
        ]
    }
