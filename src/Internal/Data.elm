module Internal.Data exposing (..)

import Codec
import Dict
import Element exposing (..)
import Expect
import Set
import Task
import Test.Runner.Failure
import Time


type Msg msgExercise
    = ShowHint Int
    | ShowHintsAll
    | ShowHintsNone
    | HideHint Int
      --
    | ShowSolution Int
    | ShowSolutionsAll
    | ShowSolutionsNone
    | HideSolution Int
      --
    | MsgTEA msgExercise
      --
    | ChangeMenu MenuContent
    | MenuOver Bool
      --
    | PortLocalStoragePop String
    | PortLocalStoragePush (Dict.Dict Int LocalStorageRecord)
      --
    | UpdatePosix Time.Posix
      --
    | RemoveFromHistory Int
    | RemoveHistory
      --
    | Resize Int Int


type alias Model modelExercise =
    { index : List Index
    , exerciseData : ExerciseData
    , localStorage : Dict.Dict Int LocalStorageRecord
    , localStorageRecord : LocalStorageRecord
    , modelExercise : modelExercise
    , menuOver : Bool
    , failureReasons : List FailureReason
    , posixNow : Time.Posix
    , width : Int
    }


type alias LocalStorageRecord =
    { hints : Show
    , solutions : Show
    , menuOpen : Bool
    , menuContent : MenuContent
    , firstSeen : Time.Posix
    , lastSeen : Time.Posix
    , solved : Maybe Time.Posix
    , testsTotal : Int
    , testsPassed : Int
    }


type alias FailureReason =
    Maybe
        { description : String
        , given : Maybe String
        , reason : Test.Runner.Failure.Reason
        }


{-| -}
type alias TEA modelExercise msgExercise =
    { init : ( modelExercise, Cmd msgExercise )
    , maybeView : Maybe (modelExercise -> Element msgExercise)
    , update : msgExercise -> modelExercise -> ( modelExercise, Cmd msgExercise )
    , subscriptions : modelExercise -> Sub msgExercise
    , tests : modelExercise -> List Expect.Expectation
    , portLocalStoragePop : (String -> Msg msgExercise) -> Sub (Msg msgExercise)
    , portLocalStoragePush : String -> Cmd (Msg msgExercise)
    }


type MenuContent
    = ContentHints
    | ContentSolutions
    | ContentHistory
    | ContentOtherExercises
    | ContentHelp
    | ContentContribute


menuContentToString : MenuContent -> String
menuContentToString menuContent =
    case menuContent of
        ContentHints ->
            "ContentHints"

        ContentSolutions ->
            "ContentSolutions"

        ContentHistory ->
            "ContentHistory"

        ContentOtherExercises ->
            "ContentOtherExercises"

        ContentHelp ->
            "ContentHelp"

        ContentContribute ->
            "ContentContribute"


stringToMenuContent : String -> MenuContent
stringToMenuContent string =
    if string == menuContentToString ContentHints then
        ContentHints

    else if string == menuContentToString ContentSolutions then
        ContentSolutions

    else if string == menuContentToString ContentHistory then
        ContentHistory

    else if string == menuContentToString ContentOtherExercises then
        ContentOtherExercises

    else if string == menuContentToString ContentHelp then
        ContentHelp

    else if string == menuContentToString ContentContribute then
        ContentContribute

    else
        ContentContribute


type Show
    = ShowAll
    | ShowNone
    | Show (Set.Set Int)


type alias Index =
    { id : Int
    , title : String
    , difficulty : Difficulty
    , categories : List String
    , ellieId : String
    }


type alias LocalStorageAsList =
    List ( Int, LocalStorageRecord )


initLocalStorageRecord : LocalStorageRecord
initLocalStorageRecord =
    { hints = ShowNone
    , solutions = ShowNone
    , menuOpen = False
    , menuContent = ContentOtherExercises
    , firstSeen = Time.millisToPosix 0
    , lastSeen = Time.millisToPosix 0
    , solved = Nothing
    , testsTotal = 0
    , testsPassed = 0
    }


toLocalStorage :
    Time.Posix
    -> TEA modelExercise msgExercise
    -> Model modelExercise
    -> Dict.Dict Int LocalStorageRecord
toLocalStorage posix tea model =
    let
        newLocalStorageRecord : LocalStorageRecord
        newLocalStorageRecord =
            toLocalStorageRecord posix tea model model.localStorageRecord
    in
    Dict.insert model.exerciseData.id newLocalStorageRecord model.localStorage


toLocalStorageRecord :
    Time.Posix
    -> TEA modelExercise msgExercise
    -> Model modelExercise
    -> LocalStorageRecord
    -> LocalStorageRecord
toLocalStorageRecord posix tea model localStorageRecord =
    case localStorageRecord.solved of
        Just _ ->
            { localStorageRecord | lastSeen = posix }

        Nothing ->
            let
                testsTotal : Int
                testsTotal =
                    model.modelExercise
                        |> tea.tests
                        |> List.length

                testsPassed : Int
                testsPassed =
                    model.failureReasons
                        |> List.filter ((==) Nothing)
                        |> List.length
            in
            { localStorageRecord
                | firstSeen =
                    if localStorageRecord.firstSeen == Time.millisToPosix 0 then
                        posix

                    else
                        localStorageRecord.firstSeen
                , lastSeen = posix
                , testsTotal = testsTotal
                , testsPassed = testsPassed
                , solved =
                    if testsTotal == testsPassed then
                        Just posix

                    else
                        Nothing
            }


{-| This record define an exercise.

  - `id` A sequencial number. It should be the same as the file name. Numbers from 1 to 99 are reserved to the [Ninety-nine Problems, Solved in Elm](https://johncrane.gitbooks.io/ninety-nine-elm-problems/content/).
  - `ellieId`, The id from the Ellie url
  - `title` of the exercise. Keep it concise and explicative
  - `difficulty` level of the exercise
  - `problem`, a detailed description of the problem
  - `tests`
  - `hints`, a list of suggestions that the user can unhide to help him in the process of finding a solution
  - `dummySolution`, A placeholder for the solution. Be sure that the type signature is correct and that it compiles. Use dummy values as returned values. For example if the function return `List a`, you can return `[]`. If the function return `Maybe a` you can return `Nothing`, etc.
  - `solutions`, a list of possible solutions

-}
type alias ExerciseData =
    { id : Int
    , title : String
    , difficulty : Difficulty
    , categories : List String
    , ellieId : String
    , reference : String
    , problem : String
    , example : String
    , tests : List String
    , hints : List String
    , dummySolution : String
    , solutions : List String
    }


emptyExerciseData : ExerciseData
emptyExerciseData =
    { id = 0
    , title = "Error loading exercise data"
    , difficulty = Undefined
    , categories = []
    , ellieId = ""
    , reference = ""
    , problem = ""
    , example = ""
    , tests = []
    , hints = []
    , dummySolution = ""
    , solutions = []
    }


{-| -}
type Difficulty
    = Easy
    | Medium
    | Hard
    | Undefined


stringToDifficulty : String -> Difficulty
stringToDifficulty string =
    if string == difficultyToString Easy then
        Easy

    else if string == difficultyToString Medium then
        Medium

    else if string == difficultyToString Hard then
        Hard

    else
        Undefined


difficultyToString : Difficulty -> String
difficultyToString difficulty =
    case difficulty of
        Easy ->
            "easy"

        Medium ->
            "medium"

        Hard ->
            "hard"

        Undefined ->
            ""


{-| `Flags` are the way to pass details about the exercises to the page.

They can be either loaded from external scripts, like in this example:

_(HTML)_

```html
<script src="https://elm-exercises.netlify.app/index.js"></script>
<script src="https://elm-exercises.netlify.app/001.js"></script>
<script src="https://elm-exercises.netlify.app/start.js"></script>
```

Or they can be hard coded, like in this example (See [`ExerciseData`](#ExerciseData) for a detailed explanation of the fields):

_(JavaScript)_

```javascript
var app = Elm.Main.init({
  node: document.getElementById("elm"),
  flags: {
    index: JSON.stringify([]),
    exercise: JSON.stringify(
      { id: 1            // Exercise ID
      , title: ""        // Title of the exercise
      , difficulty: Easy // Easy | Medium | Hard | Undefined
      , problem: ""      // Details of the problem to be solved
      , tests: []        // List of tests
      , hints: []        // List of hints
      , solutions: []    // List of solutions
      , ellie: ""        // Ellie ID
      }
    )
  }
});
```

-}
type alias Flags =
    { index : String
    , exerciseData : String
    , localStorage : String
    , width : Int
    }
