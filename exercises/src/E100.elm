module E100 exposing (exerciseData)

import Exercises exposing (..)


exerciseData : ExerciseData
exerciseData =
    { id = 100
    , title = "Fútbol announcer goal functions"
    , difficulty = difficulty.hard
    , categories = [ "Puzzles" ]
    , ellieId = ""
    , reference = "https://github.com/carbonfive/functional-programming-weekly-challenge/tree/master/Week002"
    , problem = """Write three functions, `g`, `o`, and `al`, that can be called like in the example below to produce an appropriately enthusiastic goal announcement.

### Example

```
g o o o o o o o al == "goooooooal"
g o al             == "goal"
g al               == "gal"
```
"""
    , tests =
        [ "g o o o o o o o al |> equal \"goooooooal\""
        , "g o al |> equal \"goal\""
        , "g al |> equal \"gal\""
        ]
    , hints =
        -- Add this: /riddle100/
        [ """Would these type signatures be of any help?
```
g : (String -> a) -> a

o : String -> (String -> a) -> a

al : String -> String
```"""
        , """There was some discussion in the Elm Slack channel about this puzzle, maybe you can get some [inspiration from that](https://elm-exercises.netlify.app/100/)."""
        ]
    , dummySolution = """queens : Int -> List (List Int)
queens n = 
    -- """ ++ yourImplementationGoesHere ++ """
    []"""
    , solutions =
        [ """By [hayleigh](https://elm-exercises.netlify.app/100/withsolution):



```
g : (String -> a) -> a
g f =
    f "g"


o : String -> (String -> a) -> a
o s f =
    f (s ++ "o")


al : String -> String
al s =
    s ++ "al"
```"""
        ]
    }
