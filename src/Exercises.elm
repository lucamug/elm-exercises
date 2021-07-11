module Exercises exposing
    ( exercise, exerciseWithView, exerciseWithTea, Flags, Model, Msg
    , ExerciseData, Difficulty, difficulty
    , attrsButton, yourImplementationGoesHere
    , Test, equal, notEqual, all, lessThan, atMost, greaterThan, atLeast, FloatingPointTolerance, within, notWithin, true, false, ok, err, equalLists, equalDicts, equalSets, pass, fail, onFail
    , update, viewElement, init, TEA, Index
    , codecIndex, codecExerciseData
    )

{-|


# Ellie Elements

These are the elements used inside Ellie to build an exercise.

@docs exercise, exerciseWithView, exerciseWithTea, Flags, Model, Msg


# ExerciseData

@docs ExerciseData, Difficulty, difficulty


# Helpers

@docs attrsButton, yourImplementationGoesHere


# Tests

These are the same tests of [elm-explorations/test](https://package.elm-lang.org/packages/elm-explorations/test/latest/Expect). Refer to that package for the documentation.

@docs Test, equal, notEqual, all, lessThan, atMost, greaterThan, atLeast, FloatingPointTolerance, within, notWithin, true, false, ok, err, equalLists, equalDicts, equalSets, pass, fail, onFail


# For internal use

@docs update, viewElement, init, TEA, Index


## Codecs

@docs codecIndex, codecExerciseData

-}

import Browser
import Codec
import Dict
import Element exposing (..)
import Exercises.Data
import Expect
import FeatherIcons
import Html
import Html.Attributes
import Internal.Codecs
import Internal.Data
import Internal.Markdown
import Internal.Views
import Json.Decode
import Set
import Svg
import Svg.Attributes as SA
import Test.Runner
import Test.Runner.Failure


{-| -}
codecIndex : Codec.Codec Internal.Data.Index
codecIndex =
    Internal.Codecs.codecIndex


{-| -}
codecExerciseData : Codec.Codec Exercises.Data.ExerciseData
codecExerciseData =
    Internal.Codecs.codecExerciseData


{-| -}
viewElement :
    Internal.Data.TEA modelExercise msgExercise
    -> Internal.Data.Model modelExercise
    -> Internal.Data.LocalStorageRecord
    -> Element (Internal.Data.Msg msgExercise)
viewElement =
    Internal.Views.viewElement


{-| -}
attrsButton : List (Attribute msg)
attrsButton =
    Internal.Views.attrsButton


{-| -}
type alias ExerciseData =
    Exercises.Data.ExerciseData


{-| -}
type alias Difficulty =
    Exercises.Data.Difficulty


{-| -}
difficulty :
    { easy : Exercises.Data.Difficulty
    , hard : Exercises.Data.Difficulty
    , medium : Exercises.Data.Difficulty
    , undefined : Exercises.Data.Difficulty
    }
difficulty =
    { easy = Exercises.Data.Easy
    , medium = Exercises.Data.Medium
    , hard = Exercises.Data.Hard
    , undefined = Exercises.Data.Undefined
    }


{-| -}
yourImplementationGoesHere : String
yourImplementationGoesHere =
    "Your implementation goes here"


{-| Rename `Expectation` to `Test` as they can be run immediately in this context
-}
type alias Test =
    Expect.Expectation


{-| -}
equal : a -> a -> Test
equal =
    Expect.equal


{-| -}
notEqual : a -> a -> Test
notEqual =
    Expect.notEqual


{-| -}
all : List (subject -> Test) -> subject -> Test
all =
    Expect.all


{-| -}
lessThan : comparable -> comparable -> Test
lessThan =
    Expect.lessThan


{-| -}
atMost : comparable -> comparable -> Test
atMost =
    Expect.atMost


{-| -}
greaterThan : comparable -> comparable -> Test
greaterThan =
    Expect.greaterThan


{-| -}
atLeast : comparable -> comparable -> Test
atLeast =
    Expect.atLeast


{-| -}
type alias FloatingPointTolerance =
    Expect.FloatingPointTolerance


{-| -}
within : FloatingPointTolerance -> Float -> Float -> Test
within =
    Expect.within


{-| -}
notWithin : FloatingPointTolerance -> Float -> Float -> Test
notWithin =
    Expect.notWithin


{-| -}
true : String -> Bool -> Test
true =
    Expect.true


{-| -}
false : String -> Bool -> Test
false =
    Expect.false


{-| -}
ok : Result a b -> Test
ok =
    Expect.ok


{-| -}
err : Result a b -> Test
err =
    Expect.err


{-| -}
equalLists : List a -> List a -> Test
equalLists =
    Expect.equalLists


{-| -}
equalDicts : Dict.Dict comparable a -> Dict.Dict comparable a -> Test
equalDicts =
    Expect.equalDicts


{-| -}
equalSets : Set.Set comparable -> Set.Set comparable -> Test
equalSets =
    Expect.equalSets


{-| -}
pass : Test
pass =
    Expect.pass


{-| -}
fail : String -> Test
fail =
    Expect.fail


{-| -}
onFail : String -> Test -> Test
onFail =
    Expect.onFail


{-| -}
onlyTests :
    { a
        | tests : List Test
        , portLocalStoragePop : (String -> Msg msgExercise) -> Sub (Msg msgExercise)
        , portLocalStoragePush : String -> Cmd (Msg msgExercise)
    }
    -> Element ()
    ->
        { init : ( (), Cmd () )
        , view : () -> Element ()
        , update : () -> () -> ( (), Cmd () )
        , subscriptions : () -> Sub ()
        , tests : () -> List Test
        , portLocalStoragePop : (String -> Msg msgExercise) -> Sub (Msg msgExercise)
        , portLocalStoragePush : String -> Cmd (Msg msgExercise)
        }
onlyTests args view_ =
    { init = ( (), Cmd.none )
    , view = \_ -> view_
    , update = \_ _ -> ( (), Cmd.none )
    , subscriptions = \_ -> Sub.none
    , tests = \_ -> args.tests
    , portLocalStoragePop = args.portLocalStoragePop
    , portLocalStoragePush = args.portLocalStoragePush
    }


{-| -}
type alias TEA modelExercise msgExercise =
    Internal.Data.TEA modelExercise msgExercise


{-|

    import Exercises exposing (..)


    -- Write a function `last` that returns
    -- the last element of a list.
    --
    last : List a -> Maybe a
    last xs =
        -- Your implementation goes here
        Nothing

    main : Program Flags Model Msg
    main =
        exercise
            -- Your implementation should pass
            -- these tests
            [ last [ 1, 2, 3, 4 ] == Just 4
            , last [ 1 ] == Just 1
            , last [] == Nothing
            , last [ 'a', 'b', 'c' ] == Just 'c'
            ]

-}
exercise :
    { tests : List Test
    , portLocalStoragePop : (String -> Msg ()) -> Sub (Msg ())
    , portLocalStoragePush : String -> Cmd (Msg ())
    }
    -> Program Flags (Model ()) (Msg ())
exercise args =
    exerciseWithTea
        (onlyTests args none)


{-| `Flags` are used to pass details about the exercises to the page.

They can be either loaded from external scripts, like in this example:

_(HTML)_

```html
<script src="https://elm-exercises.netlify.app/js/index.js"></script>
<script src="https://elm-exercises.netlify.app/js/001.js"></script>
<script src="https://elm-exercises.netlify.app/start.js"></script>
```

You can check the forrmat of the data in these files as reference:

  - <https://elm-exercises.netlify.app/js/index.js>
  - <https://elm-exercises.netlify.app/js/001.js>
  - <https://elm-exercises.netlify.app/start.js>

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
    Exercises.Data.Flags


{-| -}
exerciseWithView :
    { tests : List Test
    , portLocalStoragePop : (String -> Msg ()) -> Sub (Msg ())
    , portLocalStoragePush : String -> Cmd (Msg ())
    , view : Element ()
    }
    -> Program Flags (Model ()) (Msg ())
exerciseWithView args =
    exerciseWithTea
        (onlyTests args args.view)


{-| If the exercise require The Elm Architecure and tests need to access the Model, it is possible to use `exerciseWithTea` instead of the simpler `exercise`. It is the analogue of `Browser.element` but without flags.

    import Exercises exposing (..)


    -- Write a function `last` that returns
    -- the last element of a list.
    --
    last : List a -> Maybe a
    last xs =
        -- Your implementation goes here
        Nothing

    main : Program Flags (Model ModelExercise) (Msg MsgExercise)
    main =
        exerciseWithTea
            { tests =
                -- Your implementation should pass
                -- these tests
                \model ->
                    [ last [ 1, 2, 3, 4 ] == Just 4
                    , last [ 1 ] == Just 1
                    , last [] == Nothing
                    , last [ 'a', 'b', 'c' ] == Just 'c'
                    ]
            , init = init
            , view = view
            , update = update
            , subscriptions = subscriptions
            }

    -- Following the definitions of
    -- init, view, update, and subscriptions.

-}
exerciseWithTea :
    { init : ( modelExercise, Cmd msgExercise )
    , view : modelExercise -> Element msgExercise
    , update : msgExercise -> modelExercise -> ( modelExercise, Cmd msgExercise )
    , subscriptions : modelExercise -> Sub msgExercise
    , tests : modelExercise -> List Test
    , portLocalStoragePop : (String -> Msg msgExercise) -> Sub (Msg msgExercise)
    , portLocalStoragePush : String -> Cmd (Msg msgExercise)
    }
    -> Program Exercises.Data.Flags (Model modelExercise) (Msg msgExercise)
exerciseWithTea tea =
    let
        tea2 =
            { init = tea.init
            , maybeView = Just tea.view
            , update = tea.update
            , subscriptions = tea.subscriptions
            , tests = tea.tests
            , portLocalStoragePop = tea.portLocalStoragePop
            , portLocalStoragePush = tea.portLocalStoragePush
            }
    in
    Browser.element
        { init = init tea2
        , subscriptions = subscriptions tea2
        , update = update tea2
        , view = Internal.Views.view tea2
        }


subscriptions : TEA modelExercise msgExercise -> Model modelExercise -> Sub (Msg msgExercise)
subscriptions tea _ =
    tea.portLocalStoragePop Internal.Data.PortLocalStoragePop


{-| -}
init : TEA modelExercise msgExercise -> Exercises.Data.Flags -> ( Model modelExercise, Cmd (Msg msgExercise) )
init tea flags =
    let
        modelExercise : modelExercise
        modelExercise =
            Tuple.first tea.init
    in
    ( { index =
            case Codec.decodeString (Codec.list Internal.Codecs.codecIndex) flags.index of
                Ok index ->
                    index

                Err error ->
                    []
      , exerciseData =
            case Codec.decodeString Internal.Codecs.codecExerciseData flags.exerciseData of
                Ok exerciseData ->
                    exerciseData

                Err error ->
                    Exercises.Data.emptyExerciseData
      , localStorage =
            case Codec.decodeString Internal.Codecs.codecLocalStorageAsList flags.localStorage of
                Ok localStorageAsList ->
                    Dict.fromList localStorageAsList

                Err error ->
                    Dict.empty
      , modelExercise = modelExercise
      , menuOver = False
      , failureReasons =
            modelExercise
                |> tea.tests
                |> List.map Test.Runner.getFailureReason
      }
    , Cmd.none
    )


{-| Internal. Exposed to be used in type signatures
-}
type alias Model modelExercise =
    Internal.Data.Model modelExercise


{-| Internal. Exposed to be used in type signatures
-}
type alias Msg msgExercise =
    Internal.Data.Msg msgExercise


{-| -}
update : TEA modelExercise msgExercise -> Msg msgExercise -> Model modelExercise -> ( Model modelExercise, Cmd (Msg msgExercise) )
update tea msg model =
    ( model, Cmd.none )
        |> andThen (updateMain tea) msg



-- |> andThen (updateLocalStorage tea) msg
--
--
-- updateLocalStorage : TEA modelExercise msgExercise -> Msg msgExercise -> Model modelExercise -> ( Model modelExercise, Cmd (Msg msgExercise) )
-- updateLocalStorage tea msg model =
--     ( model
--     , case msg of
--         Internal.Data.PortLocalStoragePop _ ->
--             -- This is the only case where we don't "pushLocalStorage"
--             -- to avoid generating an infinite loop
--             Cmd.none
--
--         _ ->
--             -- We save data to the local storage
--             model
--                 |> modelToLocalStorage
--                 |> localStorageToString
--                 |> tea.portLocalStoragePush
--     )
--
--
-- localStorageToString : Internal.Data.LocalStorage -> String
-- localStorageToString model =
--     Codec.encodeToString 4 Internal.Codecs.codecLocalStorage model
--
--


updateMain : TEA modelExercise msgExercise -> Msg msgExercise -> Model modelExercise -> ( Model modelExercise, Cmd (Msg msgExercise) )
updateMain tea msg model =
    case msg of
        Internal.Data.ShowHint int ->
            -- ( { model | hints = Internal.Data.Show <| Set.insert int <| f model.hints }, Cmd.none )
            ( model, Cmd.none )

        Internal.Data.ShowHintsAll ->
            -- ( { model | hints = Internal.Data.ShowAll }, Cmd.none )
            ( model, Cmd.none )

        Internal.Data.ShowHintsNone ->
            -- ( { model | hints = Internal.Data.ShowNone }, Cmd.none )
            ( model, Cmd.none )

        Internal.Data.HideHint int ->
            -- ( { model | hints = Internal.Data.Show <| Set.remove int <| f model.hints }, Cmd.none )
            ( model, Cmd.none )

        Internal.Data.ShowSolution int ->
            -- ( { model | solutions = Internal.Data.Show <| Set.insert int <| f model.solutions }, Cmd.none )
            ( model, Cmd.none )

        Internal.Data.ShowSolutionsAll ->
            -- ( { model | solutions = Internal.Data.ShowAll }, Cmd.none )
            ( model, Cmd.none )

        Internal.Data.ShowSolutionsNone ->
            -- ( { model | solutions = Internal.Data.ShowNone }, Cmd.none )
            ( model, Cmd.none )

        Internal.Data.HideSolution int ->
            -- ( { model | solutions = Internal.Data.Show <| Set.remove int <| f model.solutions }, Cmd.none )
            ( model, Cmd.none )

        Internal.Data.MsgTEA msgExercise ->
            let
                ( modelExercise, cmdTEA ) =
                    tea.update msgExercise model.modelExercise
            in
            ( { model
                | modelExercise = modelExercise
                , failureReasons =
                    modelExercise
                        |> tea.tests
                        |> List.map Test.Runner.getFailureReason
              }
            , Cmd.map Internal.Data.MsgTEA cmdTEA
            )

        Internal.Data.ChangeMenu menuContent ->
            -- if menuContent == model.menuContent && model.menuOpen then
            --     ( { model | menuOpen = False }, Cmd.none )
            --
            -- else
            --     ( { model | menuOpen = True, menuContent = menuContent }, Cmd.none )
            ( model, Cmd.none )

        Internal.Data.MenuOver bool ->
            ( { model | menuOver = bool }, Cmd.none )

        Internal.Data.PortLocalStoragePop string ->
            -- decode string
            -- load into model
            Debug.todo "xxx"

        Internal.Data.PortLocalStoragePush string ->
            -- decode string
            -- load into model
            ( model, tea.portLocalStoragePush string )



-- INTERNALS


f : Internal.Data.Show -> Set.Set Int
f showSet =
    case showSet of
        Internal.Data.Show set ->
            set

        _ ->
            Set.empty


helper : List comparable -> Dict.Dict comparable (List c) -> c -> Dict.Dict comparable (List c)
helper categories_ acc exerciseData =
    List.foldl
        (\category acc2 ->
            Dict.update category
                (\maybeV ->
                    case maybeV of
                        Just v ->
                            Just <| exerciseData :: v

                        Nothing ->
                            Just [ exerciseData ]
                )
                acc
        )
        acc
        categories_


{-| -}
type alias Index =
    Internal.Data.Index


main : Html.Html msg
main =
    Html.div
        [ Html.Attributes.style "padding" "20px"
        , Html.Attributes.style "margin" "0px"
        , Html.Attributes.style "font-family" "sans-serif"
        ]
        [ Html.h1 [] [ Html.text "elm-exercises" ]
        , Html.a [ Html.Attributes.href "https://github.com/lucamug/elm-exercises" ] [ Html.text "https://github.com/lucamug/elm-exercises" ]
        ]


andThen : (msg -> model -> ( model, Cmd a )) -> msg -> ( model, Cmd a ) -> ( model, Cmd a )
andThen updater msg ( model, cmd ) =
    let
        ( modelNew, cmdNew ) =
            updater msg model
    in
    ( modelNew, Cmd.batch [ cmd, cmdNew ] )
