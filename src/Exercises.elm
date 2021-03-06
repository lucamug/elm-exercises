module Exercises exposing
    ( exercise, exerciseWithView, exerciseWithTea, Flags, Model, Msg
    , ExerciseData, Difficulty, difficulty
    , attrsButton, yourImplementationGoesHere
    , Test, equal, notEqual, all, lessThan, atMost, greaterThan, atLeast, FloatingPointTolerance, within, notWithin, true, false, ok, err, equalLists, equalDicts, equalSets, pass, fail, onFail
    , update, viewElement, viewElementAttrs, init, TEA, Index
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

@docs update, viewElement, viewElementAttrs, init, TEA, Index


## Codecs

@docs codecIndex, codecExerciseData

-}

import Browser
import Browser.Events
import Codec
import Dict
import Element exposing (..)
import Expect
import Html
import Html.Attributes
import Internal.Codecs
import Internal.Data
import Internal.Views
import Set
import Task
import Test.Runner
import Time


{-| -}
codecIndex : Codec.Codec Internal.Data.Index
codecIndex =
    Internal.Codecs.codecIndex


{-| -}
codecExerciseData : Codec.Codec Internal.Data.ExerciseData
codecExerciseData =
    Internal.Codecs.codecExerciseData


{-| -}
viewElement :
    Internal.Data.TEA modelExercise msgExercise
    -> Internal.Data.Model modelExercise
    -> Element (Internal.Data.Msg msgExercise)
viewElement =
    Internal.Views.viewElement


{-| -}
viewElementAttrs :
    Internal.Data.Model modelExercise
    -> List (Attribute (Internal.Data.Msg msgExercise))
viewElementAttrs =
    Internal.Views.viewElementAttrs


{-| -}
attrsButton : List (Attribute msg)
attrsButton =
    Internal.Views.attrsButton


{-| -}
type alias ExerciseData =
    Internal.Data.ExerciseData


{-| -}
type alias Difficulty =
    Internal.Data.Difficulty


{-| -}
difficulty :
    { easy : Internal.Data.Difficulty
    , hard : Internal.Data.Difficulty
    , medium : Internal.Data.Difficulty
    , undefined : Internal.Data.Difficulty
    }
difficulty =
    { easy = Internal.Data.Easy
    , medium = Internal.Data.Medium
    , hard = Internal.Data.Hard
    , undefined = Internal.Data.Undefined
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
    -> Maybe (Element ())
    ->
        { init : ( (), Cmd () )
        , view : Maybe (() -> Element ())
        , update : () -> () -> ( (), Cmd () )
        , subscriptions : () -> Sub ()
        , tests : () -> List Test
        , portLocalStoragePop : (String -> Msg msgExercise) -> Sub (Msg msgExercise)
        , portLocalStoragePush : String -> Cmd (Msg msgExercise)
        }
onlyTests args view =
    { init = ( (), Cmd.none )
    , view = Maybe.map (\v -> \_ -> v) view
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

    tests : List Test
    tests =
        -- Your implementation should pass
        -- these tests
        [ last [ 1, 2, 3, 4 ] == Just 4
        , last [ 1 ] == Just 1
        , last [] == Nothing
        , last [ 'a', 'b', 'c' ] == Just 'c'
        ]

    main : Program Flags (Model ()) (Msg ())
    main =
        exercise
            { tests = tests
            , portLocalStoragePop = portLocalStoragePop
            , portLocalStoragePush = portLocalStoragePush
            }

    port portLocalStoragePop : (String -> msg) -> Sub msg

    port portLocalStoragePush : String -> Cmd msg

-}
exercise :
    { tests : List Test
    , portLocalStoragePop : (String -> Msg ()) -> Sub (Msg ())
    , portLocalStoragePush : String -> Cmd (Msg ())
    }
    -> Program Flags (Model ()) (Msg ())
exercise args =
    exerciseWithTea
        (onlyTests args Nothing)


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
    Internal.Data.Flags


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
        (onlyTests args (Just args.view))


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
    , view : Maybe (modelExercise -> Element msgExercise)
    , update : msgExercise -> modelExercise -> ( modelExercise, Cmd msgExercise )
    , subscriptions : modelExercise -> Sub msgExercise
    , tests : modelExercise -> List Test
    , portLocalStoragePop : (String -> Msg msgExercise) -> Sub (Msg msgExercise)
    , portLocalStoragePush : String -> Cmd (Msg msgExercise)
    }
    -> Program Internal.Data.Flags (Model modelExercise) (Msg msgExercise)
exerciseWithTea tea =
    let
        tea2 =
            { init = tea.init
            , maybeView = tea.view
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
    Sub.batch
        [ Browser.Events.onResize Internal.Data.Resize
        , tea.portLocalStoragePop Internal.Data.PortLocalStoragePop
        ]


{-| -}
init : TEA modelExercise msgExercise -> Internal.Data.Flags -> ( Model modelExercise, Cmd (Msg msgExercise) )
init tea flags =
    let
        modelExercise : modelExercise
        modelExercise =
            Tuple.first tea.init

        localStorage : Dict.Dict Int Internal.Data.LocalStorageRecord
        localStorage =
            case Codec.decodeString Internal.Codecs.codecLocalStorageAsList flags.localStorage of
                Ok localStorageAsList ->
                    Dict.fromList localStorageAsList

                Err _ ->
                    Dict.empty

        exerciseData : Internal.Data.ExerciseData
        exerciseData =
            case Codec.decodeString Internal.Codecs.codecExerciseData flags.exerciseData of
                Ok ed ->
                    ed

                Err _ ->
                    Internal.Data.emptyExerciseData

        localStorageRecord : Internal.Data.LocalStorageRecord
        localStorageRecord =
            localStorage
                |> Dict.get exerciseData.id
                |> Maybe.withDefault Internal.Data.initLocalStorageRecord

        index : List Internal.Data.Index
        index =
            case Codec.decodeString (Codec.list Internal.Codecs.codecIndex) flags.index of
                Ok i ->
                    i

                Err _ ->
                    []

        model : Model modelExercise
        model =
            { index = index
            , exerciseData = exerciseData
            , localStorage = localStorage
            , localStorageRecord = localStorageRecord
            , modelExercise = modelExercise
            , menuOver = False
            , failureReasons =
                modelExercise
                    |> tea.tests
                    |> List.map Test.Runner.getFailureReason

            -- The first posix could come from flags if necessary
            , posixNow = Time.millisToPosix 0
            , width = flags.width
            }
    in
    ( model
    , saveLocalStorage tea model
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
update :
    TEA modelExercise msgExercise
    -> Msg msgExercise
    -> Model modelExercise
    -> ( Model modelExercise, Cmd (Msg msgExercise) )
update tea msg model =
    ( model, Cmd.none )
        |> andThen (updateMain tea) msg
        |> andThen (updateLocalStorage tea) msg
        |> andThen updatePosix msg


updatePosix :
    Msg msgExercise
    -> Model modelExercise
    -> ( Model modelExercise, Cmd (Msg msgExercise) )
updatePosix msg model =
    case msg of
        Internal.Data.UpdatePosix _ ->
            ( model, Cmd.none )

        _ ->
            ( model, Task.perform Internal.Data.UpdatePosix Time.now )


updateLocalStorage :
    TEA modelExercise msgExercise
    -> Msg msgExercise
    -> Model modelExercise
    -> ( Model modelExercise, Cmd (Msg msgExercise) )
updateLocalStorage tea msg model =
    ( model
    , case msg of
        Internal.Data.PortLocalStoragePop _ ->
            -- This is a case where we don't "pushLocalStorage"
            -- to avoid generating an infinite loop
            Cmd.none

        Internal.Data.PortLocalStoragePush _ ->
            -- This is a case where we don't "pushLocalStorage"
            -- to avoid generating an infinite loop
            Cmd.none

        Internal.Data.UpdatePosix _ ->
            -- This is a case where we don't "pushLocalStorage"
            -- to avoid generating an infinite loop
            Cmd.none

        Internal.Data.MenuOver _ ->
            Cmd.none

        _ ->
            -- We save data to the local storage
            saveLocalStorage tea model
    )


saveLocalStorage :
    Internal.Data.TEA modelExercise msgExercise1
    -> Internal.Data.Model modelExercise
    -> Cmd (Internal.Data.Msg msgExercise)
saveLocalStorage tea model =
    -- From https://elm.dmy.fr/packages/elm/core/latest/Task#succeed
    Time.now
        |> Task.andThen (\posix -> Task.succeed (Internal.Data.toLocalStorage posix tea model))
        |> Task.perform Internal.Data.PortLocalStoragePush


localStorageToString : Dict.Dict Int Internal.Data.LocalStorageRecord -> String
localStorageToString localStorage =
    localStorage
        |> Dict.toList
        |> Codec.encodeToString 0 Internal.Codecs.codecLocalStorageAsList


updateMain : TEA modelExercise msgExercise -> Msg msgExercise -> Model modelExercise -> ( Model modelExercise, Cmd (Msg msgExercise) )
updateMain tea msg model =
    case msg of
        Internal.Data.UpdatePosix posix ->
            ( { model | posixNow = posix }, Cmd.none )

        Internal.Data.ShowHint int ->
            model.localStorageRecord.hints
                |> f
                |> Set.insert int
                |> Internal.Data.Show
                |> changeHints model

        Internal.Data.ShowSolution int ->
            model.localStorageRecord.solutions
                |> f
                |> Set.insert int
                |> Internal.Data.Show
                |> changeSolutions model

        Internal.Data.HideHint int ->
            model.localStorageRecord.hints
                |> f
                |> Set.remove int
                |> Internal.Data.Show
                |> changeHints model

        Internal.Data.HideSolution int ->
            model.localStorageRecord.solutions
                |> f
                |> Set.remove int
                |> Internal.Data.Show
                |> changeSolutions model

        Internal.Data.ShowHintsAll ->
            Internal.Data.ShowAll |> changeHints model

        Internal.Data.ShowSolutionsAll ->
            Internal.Data.ShowAll |> changeSolutions model

        Internal.Data.ShowHintsNone ->
            Internal.Data.ShowNone |> changeHints model

        Internal.Data.ShowSolutionsNone ->
            Internal.Data.ShowNone |> changeSolutions model

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
            if menuContent == model.localStorageRecord.menuContent && model.localStorageRecord.menuOpen then
                changeLocalStorage model (\lsr -> { lsr | menuOpen = False })

            else
                changeLocalStorage model (\lsr -> { lsr | menuOpen = True, menuContent = menuContent })

        Internal.Data.MenuOver bool ->
            ( { model | menuOver = bool }, Cmd.none )

        Internal.Data.PortLocalStoragePop string ->
            let
                localStorage : Dict.Dict Int Internal.Data.LocalStorageRecord
                localStorage =
                    case Codec.decodeString Internal.Codecs.codecLocalStorageAsList string of
                        Ok localStorageAsList ->
                            Dict.fromList localStorageAsList

                        Err _ ->
                            Dict.empty

                localStorageRecord : Internal.Data.LocalStorageRecord
                localStorageRecord =
                    localStorage
                        |> Dict.get model.exerciseData.id
                        |> Maybe.withDefault Internal.Data.initLocalStorageRecord
            in
            ( { model
                | localStorage = localStorage
                , localStorageRecord = localStorageRecord
              }
            , Cmd.none
            )

        Internal.Data.PortLocalStoragePush localStorage ->
            ( { model | localStorage = localStorage }
            , tea.portLocalStoragePush (localStorageToString localStorage)
            )

        Internal.Data.RemoveFromHistory id ->
            ( { model
                | localStorage = Dict.remove id model.localStorage
                , localStorageRecord =
                    if id == model.exerciseData.id then
                        let
                            localStorageRecord =
                                model.localStorageRecord
                        in
                        { localStorageRecord
                            | firstSeen = Time.millisToPosix 0
                            , lastSeen = Time.millisToPosix 0
                            , solved = Nothing
                            , testsTotal = 0
                            , testsPassed = 0
                        }
                            |> Internal.Data.toLocalStorageRecord model.posixNow tea model

                    else
                        model.localStorageRecord
              }
            , Cmd.none
            )

        Internal.Data.RemoveHistory ->
            ( { model | localStorage = Dict.empty }, Cmd.none )

        Internal.Data.Resize width _ ->
            ( { model | width = width }, Cmd.none )



-- INTERNALS


changeLocalStorage :
    { a | localStorageRecord : Internal.Data.LocalStorageRecord }
    -> (Internal.Data.LocalStorageRecord -> Internal.Data.LocalStorageRecord)
    -> ( { a | localStorageRecord : Internal.Data.LocalStorageRecord }, Cmd msg )
changeLocalStorage model newLocalStorageRecord =
    let
        localStorageRecord : Internal.Data.LocalStorageRecord
        localStorageRecord =
            model.localStorageRecord
    in
    ( { model
        | localStorageRecord = newLocalStorageRecord localStorageRecord
      }
    , Cmd.none
    )


changeHints :
    { a | localStorageRecord : Internal.Data.LocalStorageRecord }
    -> Internal.Data.Show
    -> ( { a | localStorageRecord : Internal.Data.LocalStorageRecord }, Cmd msg )
changeHints model newHints =
    let
        localStorageRecord : Internal.Data.LocalStorageRecord
        localStorageRecord =
            model.localStorageRecord
    in
    ( { model
        | localStorageRecord =
            { localStorageRecord
                | hints = newHints
            }
      }
    , Cmd.none
    )


changeSolutions :
    { a | localStorageRecord : Internal.Data.LocalStorageRecord }
    -> Internal.Data.Show
    -> ( { a | localStorageRecord : Internal.Data.LocalStorageRecord }, Cmd msg )
changeSolutions model newSolutions =
    let
        localStorageRecord : Internal.Data.LocalStorageRecord
        localStorageRecord =
            model.localStorageRecord
    in
    ( { model
        | localStorageRecord =
            { localStorageRecord
                | solutions = newSolutions
            }
      }
    , Cmd.none
    )


f : Internal.Data.Show -> Set.Set Int
f showSet =
    case showSet of
        Internal.Data.Show set ->
            set

        _ ->
            Set.empty


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
