module Exercises.Data exposing (..)

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
    }
