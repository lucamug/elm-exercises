module Exercises exposing
    ( exercise, exerciseWithView, exerciseWithTea, Flags, Model, Msg
    , ExerciseData, Difficulty(..)
    , attrsButton, yourImplementationGoesHere
    , Test, equal, notEqual, all, lessThan, atMost, greaterThan, atLeast, FloatingPointTolerance, within, notWithin, true, false, ok, err, equalLists, equalDicts, equalSets, pass, fail, onFail
    , update, viewElement, init, TEA, Index
    , codecExerciseData, codecIndex
    )

{-|


# Ellie Elements

These are the elements used inside Ellie to build an exercise.

@docs exercise, exerciseWithView, exerciseWithTea, Flags, Model, Msg


# ExerciseData

@docs ExerciseData, Difficulty


# Helpers

@docs attrsButton, yourImplementationGoesHere


# Tests

These are the same tests of [elm-explorations/test](https://package.elm-lang.org/packages/elm-explorations/test/latest/Expect). Refer to that package for the documentation.

@docs Test, equal, notEqual, all, lessThan, atMost, greaterThan, atLeast, FloatingPointTolerance, within, notWithin, true, false, ok, err, equalLists, equalDicts, equalSets, pass, fail, onFail


# For internal use

@docs update, viewElement, init, TEA, Index


## Codecs

@docs codecExerciseData, codecIndex

-}

import Browser
import Codec
import Dict
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Events as Events
import Element.Font as Font
import Element.Input as Input
import Element.Region as Region
import Expect
import FeatherIcons
import Html
import Html.Attributes
import Internal.Markdown
import Json.Decode
import Set
import Svg
import Svg.Attributes as SA
import Test.Runner
import Test.Runner.Failure


version : String
version =
    "2.0.0"


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
    { init : ( modelExercise, Cmd msgExercise )
    , maybeView : Maybe (modelExercise -> Element msgExercise)
    , update : msgExercise -> modelExercise -> ( modelExercise, Cmd msgExercise )
    , subscriptions : modelExercise -> Sub msgExercise
    , tests : modelExercise -> List Test
    , portLocalStoragePop : (String -> Msg msgExercise) -> Sub (Msg msgExercise)
    , portLocalStoragePush : String -> Cmd (Msg msgExercise)
    }


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
    -> Program Flags (Model modelExercise) (Msg msgExercise)
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
        , view = view tea2
        }


subscriptions : TEA modelExercise msgExercise -> Model modelExercise -> Sub (Msg msgExercise)
subscriptions tea _ =
    tea.portLocalStoragePop PortLocalStoragePop


{-| -}
init : TEA modelExercise msgExercise -> Flags -> ( Model modelExercise, Cmd (Msg msgExercise) )
init tea flags =
    ( { hints = ShowNone
      , solutions = ShowNone
      , resultIndex = Codec.decodeString (Codec.list codecIndex) flags.index
      , resultExerciseData = Codec.decodeString codecExerciseData flags.exerciseData
      , modelExercise = Tuple.first tea.init
      , menuOpen = False
      , menuOver = False
      , menuContent = OtherExercises
      , flags = flags
      }
    , Cmd.none
    )


{-| Internal. Exposed to be used in type signatures
-}
type alias Model modelExercise =
    { hints : Show
    , solutions : Show
    , resultExerciseData : Result Codec.Error ExerciseData
    , resultIndex : Result Codec.Error (List Index)
    , modelExercise : modelExercise
    , menuOpen : Bool
    , menuOver : Bool
    , menuContent : MenuContent
    , flags : Flags
    }


modelToLocalStorage : Model modelExercise -> LocalStorage
modelToLocalStorage model =
    { hints = model.hints
    , solutions = model.solutions
    , menuOpen = model.menuOpen
    , menuContent = model.menuContent
    }


modelFromLocalStorage : Model modelExercise -> LocalStorage -> Model modelExercise
modelFromLocalStorage model localStorage =
    { model
        | hints = localStorage.hints
        , solutions = localStorage.solutions
        , menuOpen = localStorage.menuOpen
        , menuContent = localStorage.menuContent
    }


type alias LocalStorage =
    { hints : Show
    , solutions : Show
    , menuOpen : Bool
    , menuContent : MenuContent
    }


{-| -}
type Show
    = ShowAll
    | ShowNone
    | Show (Set.Set Int)


codecShow : Codec.Codec Show
codecShow =
    Codec.custom
        (\showAll showNone show value ->
            case value of
                ShowAll ->
                    showAll

                ShowNone ->
                    showNone

                Show setInt ->
                    show setInt
        )
        |> Codec.variant0 "ShowAll" ShowAll
        |> Codec.variant0 "ShowNone" ShowNone
        |> Codec.variant1 "Show" Show (Codec.set Codec.int)
        |> Codec.buildCustom


codecLocalStorage : Codec.Codec LocalStorage
codecLocalStorage =
    Codec.object LocalStorage
        |> Codec.field "hints" .hints codecShow
        |> Codec.field "solutions" .solutions codecShow
        |> Codec.field "menuOpen" .menuOpen Codec.bool
        |> Codec.field "menuContent" .menuContent (Codec.map stringToMenuContent menuContentToString Codec.string)
        |> Codec.buildObject


type MenuContent
    = OtherExercises
    | Help
    | Contribute


menuContentToString : MenuContent -> String
menuContentToString menuContent =
    case menuContent of
        OtherExercises ->
            "OtherExercises"

        Help ->
            "Help"

        Contribute ->
            "Contribute"


stringToMenuContent : String -> MenuContent
stringToMenuContent string =
    if string == menuContentToString OtherExercises then
        OtherExercises

    else if string == menuContentToString Help then
        Help

    else if string == menuContentToString Contribute then
        Contribute

    else
        Contribute


{-| Internal. Exposed to be used in type signatures
-}
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
    , tests : List String
    , hints : List String
    , dummySolution : String
    , solutions : List String
    }


{-| -}
type Difficulty
    = Easy
    | Medium
    | Hard
    | Undefined


{-| -}
update : TEA modelExercise msgExercise -> Msg msgExercise -> Model modelExercise -> ( Model modelExercise, Cmd (Msg msgExercise) )
update tea msg model =
    ( model, Cmd.none )
        |> andThen (updateMain tea) msg
        |> andThen (updateLocalStorage tea) msg


updateLocalStorage : TEA modelExercise msgExercise -> Msg msgExercise -> Model modelExercise -> ( Model modelExercise, Cmd (Msg msgExercise) )
updateLocalStorage tea msg model =
    ( model
    , case msg of
        PortLocalStoragePop _ ->
            -- This is the only case where we don't "pushLocalStorage"
            -- to avoid generating an infinite loop
            Cmd.none

        _ ->
            -- We save data to the local storage
            model
                |> modelToLocalStorage
                |> localStorageToString
                |> tea.portLocalStoragePush
    )


localStorageToString : LocalStorage -> String
localStorageToString model =
    Codec.encodeToString 4 codecLocalStorage model


updateMain : TEA modelExercise msgExercise -> Msg msgExercise -> Model modelExercise -> ( Model modelExercise, Cmd (Msg msgExercise) )
updateMain tea msg model =
    case msg of
        ShowHint int ->
            ( { model | hints = Show <| Set.insert int <| f model.hints }, Cmd.none )

        ShowHintsAll ->
            ( { model | hints = ShowAll }, Cmd.none )

        ShowHintsNone ->
            ( { model | hints = ShowNone }, Cmd.none )

        HideHint int ->
            ( { model | hints = Show <| Set.remove int <| f model.hints }, Cmd.none )

        ShowSolution int ->
            ( { model | solutions = Show <| Set.insert int <| f model.solutions }, Cmd.none )

        ShowSolutionsAll ->
            ( { model | solutions = ShowAll }, Cmd.none )

        ShowSolutionsNone ->
            ( { model | solutions = ShowNone }, Cmd.none )

        HideSolution int ->
            ( { model | solutions = Show <| Set.remove int <| f model.solutions }, Cmd.none )

        MsgTEA msgExercise ->
            let
                ( modelExercise, cmdTEA ) =
                    tea.update msgExercise model.modelExercise
            in
            ( { model | modelExercise = modelExercise }, Cmd.map MsgTEA cmdTEA )

        ChangeMenu menuContent ->
            if menuContent == model.menuContent && model.menuOpen then
                ( { model | menuOpen = False }, Cmd.none )

            else
                ( { model | menuOpen = True, menuContent = menuContent }, Cmd.none )

        MenuOver bool ->
            ( { model | menuOver = bool }, Cmd.none )

        PortLocalStoragePop string ->
            -- decode string
            -- load into model
            Debug.todo "xxx"


type alias FailureReason =
    Maybe
        { description : String
        , given : Maybe String
        , reason : Test.Runner.Failure.Reason
        }


{-| -}
viewElement : TEA modelExercise msgExercise -> Model modelExercise -> Element (Msg msgExercise)
viewElement tea model =
    case model.resultExerciseData of
        Err error ->
            column [ spacing 0, width fill, height fill ]
                ([]
                    ++ [ viewHeader emptyExerciseData model.resultIndex ]
                    ++ [ column [ centerX, centerY, spacing 30 ]
                            [ paragraph [ Font.size 30, Font.center ] [ text <| "Error" ]
                            , paragraph [ Font.center ] [ text <| "Problems while decoding the flag 'exerciseData' that is uqual to '" ++ model.flags.exerciseData ++ "'." ]
                            , paragraph [ Font.center ] [ text <| Json.Decode.errorToString error ]
                            ]
                       ]
                    ++ [ viewFooter ]
                )

        Ok exerciseData ->
            column
                [ spacing 0
                , width fill
                , Font.size 16
                , Font.family [ Font.typeface "Source Sans Pro", Font.sansSerif ]
                , inFront <| html <| Html.node "style" [] [ Html.text """
            /* unvisited link */
            a:link {
                color: rgb(18, 147, 216);
            }

            /* visited link */
            a:visited {
                color: rgb(0, 100, 180);
            }

            /* mouse over link */
            a:hover {
                color: rgb(0, 100, 180);
            }

            /* selected link */
            a:active {
                color: rgb(0, 100, 180);
            }

            a.linkInTheHeader:link {
                color: rgba(255, 255, 255, 0.8);
            }

            a.linkInTheHeader:hover {
                color: rgb(255, 255, 255);
            }

            .hljs {
                background-color: rgb(250, 250, 250);
                border: 1px solid rgb(220, 220, 220);
                border-radius: 6px;
                font-size: 14px;
                line-height: 18px;
                padding: 10px;
                font-family: 'Source Code Pro', monospace;
            }
            """ ]
                ]
                ([]
                    ++ [ viewHeader exerciseData model.resultIndex ]
                    ++ [ viewBody tea model exerciseData ]
                    ++ [ viewFooter ]
                )



-- INTERNALS


viewBody :
    TEA modelExercise msgExercise
    -> Model modelExercise
    -> ExerciseData
    -> Element (Msg msgExercise)
viewBody tea model exerciseData =
    let
        tests : List FailureReason
        tests =
            model.modelExercise
                |> tea.tests
                |> List.map Test.Runner.getFailureReason
    in
    column [ padding 20, spacing 20, width fill ]
        ([]
            ++ [ paragraph [ Region.heading 2, Font.size 24, Font.bold ] [ text "Problem" ] ]
            ++ [ column [ paddingLeft, spacing 16, width fill ] <|
                    Internal.Markdown.markdown exerciseData.problem
                        ++ [ paragraph [ alpha 0.5 ]
                                [ text "Diffculty level: "
                                , el [] <| text <| difficultyToString exerciseData.difficulty
                                ]
                           ]
               ]
            ++ (case tea.maybeView of
                    Just view_ ->
                        [ paragraph [ Region.heading 2, Font.size 20, Font.bold ] [ text "Result" ]
                        , el [ paddingLeft, width fill ] <| map MsgTEA <| view_ model.modelExercise
                        ]

                    Nothing ->
                        []
               )
            ++ [ paragraph [ Region.heading 2, Font.size 24, Font.bold ] [ text "Tests" ] ]
            ++ [ column [ paddingLeft, spacing 20, width fill ] <|
                    ([]
                        ++ [ let
                                failed : Int
                                failed =
                                    tests
                                        |> List.filter
                                            (\failureReason ->
                                                case failureReason of
                                                    Just _ ->
                                                        True

                                                    Nothing ->
                                                        False
                                            )
                                        |> List.length

                                total : Int
                                total =
                                    tests
                                        |> List.length
                             in
                             case
                                failed
                             of
                                0 ->
                                    column [ spacing 15 ] <|
                                        []
                                            ++ [ paragraph [ Font.color green, Font.size 20 ]
                                                    [ text <|
                                                        "The current implementation passed all tests! 🎉"
                                                    ]
                                               ]
                                            ++ (case model.resultIndex of
                                                    Ok index ->
                                                        let
                                                            maybeNext =
                                                                Tuple.second <| previousAndNext exerciseData index
                                                        in
                                                        case maybeNext of
                                                            Just next ->
                                                                [ paragraph [ Font.color green, Font.size 20 ]
                                                                    [ el [] <|
                                                                        text <|
                                                                            "Check the next exercise: "
                                                                    , newTabLink []
                                                                        { url = "https://ellie-app.com/" ++ next.ellieId
                                                                        , label =
                                                                            paragraph []
                                                                                [ el [] <| text <| next.title
                                                                                ]
                                                                        }
                                                                    ]
                                                                ]

                                                            Nothing ->
                                                                []

                                                    _ ->
                                                        []
                                               )

                                1 ->
                                    paragraph [ Font.color red ]
                                        [ text <|
                                            "The current implementation failed one test, try again!"
                                        ]

                                x ->
                                    paragraph [ Font.color red ]
                                        [ text <|
                                            "The current implementation failed "
                                                ++ String.fromInt x
                                                ++ " tests, try again"
                                        ]
                           ]
                        ++ (let
                                zipped =
                                    zip exerciseData.tests tests
                            in
                            List.map
                                (\( test, failureReason ) ->
                                    case failureReason of
                                        Nothing ->
                                            wrappedRow [ spacing 10 ]
                                                [ el [ alignTop, moveDown 3 ] <| text "✅"
                                                , el [ Font.color green, width <| px 50, alignTop, moveDown 3 ] <| text "Passed"
                                                , paragraph [] <|
                                                    Internal.Markdown.markdown <|
                                                        "`"
                                                            ++ test
                                                            ++ "`"
                                                ]

                                        Just reason ->
                                            wrappedRow [ spacing 10, width fill ]
                                                [ el [ alignTop, moveDown 3 ] <| text "❌"
                                                , el [ Font.color red, width <| px 50, alignTop, moveDown 3 ] <| text "Failed"
                                                , paragraph [] <|
                                                    Internal.Markdown.markdown <|
                                                        "`"
                                                            ++ test
                                                            ++ "` "
                                                            ++ failureReasonToString reason.reason
                                                ]
                                )
                                zipped
                           )
                    )
               ]
            ++ [ wrappedRow [ spacing 10 ]
                    [ paragraph [ Region.heading 2, Font.size 20, Font.bold ] [ text "Hints" ]
                    , Input.button attrsButton { onPress = Just ShowHintsAll, label = text "Show All" }
                    , Input.button attrsButton { onPress = Just ShowHintsNone, label = text "Hide All" }
                    ]
               ]
            ++ [ accordion { items = model.hints, hideItem = HideHint, showItem = ShowHint, itemsContent = exerciseData.hints } ]
            ++ [ wrappedRow [ spacing 10 ]
                    [ paragraph [ Region.heading 2, Font.size 20, Font.bold ] [ text "Solutions" ]
                    , Input.button attrsButton { onPress = Just ShowSolutionsAll, label = text "Show All" }
                    , Input.button attrsButton { onPress = Just ShowSolutionsNone, label = text "Hide All" }
                    ]
               ]
            ++ [ accordion { items = model.solutions, hideItem = HideSolution, showItem = ShowSolution, itemsContent = exerciseData.solutions } ]
        )


previousAndNext : { a | id : Int } -> List Index -> ( Maybe Index, Maybe Index )
previousAndNext exerciseData listIndex =
    let
        maybeCurrentPosition =
            indexedFoldl
                (\i index acc ->
                    if exerciseData.id == index.id then
                        case acc of
                            Nothing ->
                                Just i

                            Just _ ->
                                acc

                    else
                        acc
                )
                Nothing
                listIndex
    in
    case maybeCurrentPosition of
        Nothing ->
            -- No position were found
            ( Nothing, Nothing )

        Just currentPosition ->
            ( getAt (currentPosition - 1) listIndex
            , getAt (currentPosition + 1) listIndex
            )


logo : Html.Html msg
logo =
    Svg.svg [ SA.fill "#fff", SA.width "40", SA.height "40", SA.viewBox "0 0 600 600" ]
        [ Svg.polygon [ SA.points "0,20 280,300 0,580" ] []
        , Svg.polygon [ SA.points "20,600 300,320 580,600" ] []
        , Svg.polygon [ SA.points "320,0 600,0 600,280" ] []
        , Svg.polygon [ SA.points "20,0 280,0 402,122 142,122" ] []
        , Svg.polygon [ SA.points "170,150 430,150 300,280" ] []
        , Svg.polygon [ SA.points "320,300 450,170 580,300 450,430" ] []
        , Svg.polygon [ SA.points "470,450 600,320 600,580" ] []
        ]


f : Show -> Set.Set Int
f showSet =
    case showSet of
        Show set ->
            set

        _ ->
            Set.empty


{-| -}
attrsButton : List (Attribute msg)
attrsButton =
    [ Border.width 1
    , Border.color <| rgba 0 0 0 0.2
    , Border.rounded 2
    , mouseOver
        [ Border.shadow
            { offset = ( 0, 0 )
            , size = 1
            , blur = 0
            , color = rgba255 18 147 216 0.8
            }
        ]
    , paddingXY 7 5
    , alignTop
    ]


paddingLeft : Attribute msg
paddingLeft =
    paddingEach { top = 0, right = 0, bottom = 0, left = 20 }


viewSideButtons : Model modelExercise -> Element (Msg msgExercise)
viewSideButtons model =
    column
        [ alignRight
        , centerY
        , spacing 10
        , Events.onMouseEnter <| MenuOver True
        , Events.onMouseLeave <| MenuOver False
        , htmlAttribute <| Html.Attributes.style "transition" "0.2s"
        , if model.menuOpen then
            if model.menuOver then
                moveRight 0

            else
                moveRight 130

          else if model.menuOver then
            moveRight 0

          else
            moveRight 93
        ]
        [ Input.button
            [ padding 13
            , Border.widthEach { bottom = 1, left = 1, right = 0, top = 1 }
            , Border.roundEach { topLeft = 4, topRight = 0, bottomLeft = 4, bottomRight = 0 }
            , Border.color <| rgba 0 0 0 0.2
            , Background.color <| rgba 1 1 1 0.9
            , width fill
            ]
            { label =
                row [ spacing 15 ]
                    [ FeatherIcons.crosshair
                        |> FeatherIcons.toHtml []
                        |> html
                        |> el [ centerX ]
                    , column [ width fill, spacing 4 ]
                        [ el [ Font.size 12 ] <| text "HINTS"
                        ]
                    ]
            , onPress = Just <| ChangeMenu OtherExercises
            }
        , Input.button
            [ padding 13
            , Border.widthEach { bottom = 1, left = 1, right = 0, top = 1 }
            , Border.roundEach { topLeft = 4, topRight = 0, bottomLeft = 4, bottomRight = 0 }
            , Border.color <| rgba 0 0 0 0.2
            , Background.color <| rgba 1 1 1 0.9
            , width fill
            ]
            { label =
                row [ spacing 15 ]
                    [ FeatherIcons.list
                        |> FeatherIcons.toHtml []
                        |> html
                        |> el [ centerX ]
                    , column [ width fill, spacing 4 ]
                        [ el [ Font.size 12 ] <| text "SOLUTIONS"
                        ]
                    ]
            , onPress = Just <| ChangeMenu OtherExercises
            }
        , Input.button
            [ padding 13
            , Border.widthEach { bottom = 1, left = 1, right = 0, top = 1 }
            , Border.roundEach { topLeft = 4, topRight = 0, bottomLeft = 4, bottomRight = 0 }
            , Border.color <| rgba 0 0 0 0.2
            , Background.color <| rgba 1 1 1 0.9
            , width fill
            ]
            { label =
                row [ spacing 15 ]
                    [ FeatherIcons.clock
                        |> FeatherIcons.toHtml []
                        |> html
                        |> el [ centerX ]
                    , column [ width fill, spacing 4 ]
                        [ el [ Font.size 12 ] <| text "HISTORY"
                        ]
                    ]
            , onPress = Just <| ChangeMenu OtherExercises
            }
        , Input.button
            [ padding 13
            , Border.widthEach { bottom = 1, left = 1, right = 0, top = 1 }
            , Border.roundEach { topLeft = 4, topRight = 0, bottomLeft = 4, bottomRight = 0 }
            , Border.color <| rgba 0 0 0 0.2
            , Background.color <| rgba 1 1 1 0.9
            , width fill
            ]
            { label =
                row [ spacing 15 ]
                    -- [ FeatherIcons.list
                    [ FeatherIcons.edit
                        |> FeatherIcons.toHtml []
                        |> html
                        |> el [ centerX ]
                    , column [ width fill, spacing 4 ]
                        [ el [ Font.size 12 ] <| text "OTHER"
                        , el [ Font.size 12 ] <| text "EXERCISES"
                        ]
                    ]
            , onPress = Just <| ChangeMenu OtherExercises
            }
        , Input.button
            [ padding 13
            , Border.widthEach { bottom = 1, left = 1, right = 0, top = 1 }
            , Border.roundEach { topLeft = 4, topRight = 0, bottomLeft = 4, bottomRight = 0 }
            , Border.color <| rgba 0 0 0 0.2
            , Background.color <| rgba 1 1 1 0.8
            , width fill
            ]
            { label =
                row [ spacing 15 ]
                    [ FeatherIcons.helpCircle
                        |> FeatherIcons.toHtml []
                        |> html
                        |> el [ centerX ]
                    , el [ Font.size 12 ] <| text "HELP"
                    ]
            , onPress = Just <| ChangeMenu Help
            }
        , Input.button
            [ padding 13
            , Border.widthEach { bottom = 1, left = 1, right = 0, top = 1 }
            , Border.roundEach { topLeft = 4, topRight = 0, bottomLeft = 4, bottomRight = 0 }
            , Border.color <| rgba 0 0 0 0.2
            , Background.color <| rgba 1 1 1 0.8
            , width fill
            ]
            { label =
                row [ spacing 15 ]
                    [ FeatherIcons.heart
                        |> FeatherIcons.toHtml []
                        |> html
                        |> el [ centerX ]
                    , el [ Font.size 12 ] <| text "CONTRIBUTE"
                    ]
            , onPress = Just <| ChangeMenu Contribute
            }
        ]


view : TEA modelExercise msgExercise -> Model modelExercise -> Html.Html (Msg msgExercise)
view tea model =
    layoutWith
        { options = [ focusStyle { borderColor = Nothing, backgroundColor = Nothing, shadow = Nothing } ] }
        ([]
            ++ (if model.menuOpen then
                    [ inFront <|
                        -- Cover layer
                        el
                            [ width fill
                            , height fill
                            , Background.color <| rgba 0 0 0 0.2
                            , htmlAttribute <| Html.Attributes.style "transition" "0.2s"
                            , Events.onClick <| ChangeMenu model.menuContent
                            ]
                        <|
                            none
                    ]

                else
                    [ inFront <| text "" ]
               )
            ++ [ inFront <| viewSideMenu model ]
            ++ [ inFront <| viewSideButtons model ]
            ++ (if model.menuOpen then
                    [ inFront <|
                        Input.button
                            (attrsButton
                                ++ [ alignRight
                                   , Font.size 24
                                   , padding 10
                                   , Border.width 0
                                   , moveLeft 15
                                   , moveDown 17
                                   , mouseOver []
                                   ]
                            )
                            { label =
                                FeatherIcons.x
                                    |> FeatherIcons.withSize 32
                                    |> FeatherIcons.toHtml []
                                    |> html
                            , onPress = Just <| ChangeMenu model.menuContent
                            }
                    ]

                else
                    []
               )
        )
        (viewElement tea model)


viewSideMenu : Model modelExercise -> Element (Msg msgExercise)
viewSideMenu model =
    case model.menuContent of
        OtherExercises ->
            viewContent model <| contentOtherExercises model

        Help ->
            viewContent model <| contentHelp

        Contribute ->
            viewContent model <| contentContribute


viewContent : Model modelExercise -> ( String, List (Element msg) ) -> Element msg
viewContent model ( title, content ) =
    let
        widthSize : Int
        widthSize =
            400
    in
    column
        [ width <| px widthSize
        , height fill
        , alignRight
        , scrollbarY
        , htmlAttribute <| Html.Attributes.style "transition" "0.2s"
        , Font.size 16
        , Font.family [ Font.typeface "Source Sans Pro", Font.sansSerif ]
        , Background.color <| rgba 1 1 1 1
        , Border.shadow { offset = ( 0, 0 ), size = 0, blur = 10, color = rgba 0 0 0 0.2 }
        , if model.menuOpen then
            moveRight 0

          else
            moveRight <| toFloat <| widthSize + 10
        ]
    <|
        []
            ++ [ paragraph
                    [ Region.heading 2
                    , Font.size 24
                    , Font.bold
                    , Background.color <| rgba 0 0 0 0.1
                    , padding 10
                    , width fill
                    , paddingXY 20 30
                    ]
                    [ text title ]
               ]
            ++ [ column
                    [ paddingEach { top = 30, right = 20, bottom = 20, left = 20 }
                    , spacing 20

                    -- scrollabar is not working
                    , scrollbarY
                    , width fill
                    , height fill
                    ]
                 <|
                    content
               ]


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


categories : List Index -> Dict.Dict String (List Index)
categories exercises =
    List.foldl
        (\exerciseData acc ->
            List.foldl
                (\category acc2 ->
                    -- let
                    --     _ =
                    --         Debug.log "xxx2" ( category, acc2 )
                    -- in
                    Dict.update category
                        (\maybeV ->
                            case maybeV of
                                Just v ->
                                    Just <| exerciseData :: v

                                Nothing ->
                                    Just [ exerciseData ]
                        )
                        acc2
                )
                acc
                exerciseData.categories
        )
        Dict.empty
        exercises


difficulties : List Index -> Dict.Dict String Index
difficulties exercises =
    List.foldl
        (\exerciseData acc ->
            Dict.insert (difficultyToString exerciseData.difficulty) exerciseData acc
        )
        Dict.empty
        exercises


contentOtherExercises : Model modelExercise -> ( String, List (Element msg) )
contentOtherExercises model =
    case model.resultIndex of
        Ok index ->
            ( "Other Exercises"
            , []
                ++ [ viewTitle "Exercises by Category" ]
                ++ [ index
                        |> categories
                        |> Dict.map
                            (\category excercises ->
                                subtitle <| category ++ " (" ++ String.fromInt (List.length excercises) ++ ")"
                            )
                        |> Dict.values
                        |> column []
                   ]
                ++ [ subtitle "Exercises by Difficulty Level" ]
                ++ [ subtitle "All Exercises" ]
                ++ [ column [ paddingLeft, spacing 5 ] <|
                        List.map
                            (\i ->
                                row [ spacing 10 ]
                                    [ el [ alignTop ] <| text "•"
                                    , paragraph [] <|
                                        -- if i.id == exerciseData.id then
                                        --     [ paragraph []
                                        --         [ el [ Font.bold ] <| text "You are here ☞ "
                                        --         , text <| i.title
                                        --         , text " (#"
                                        --         , text <| String.fromInt i.id
                                        --         , text ", "
                                        --         , text <| difficultyToString i.difficulty
                                        --         , text ")"
                                        --         ]
                                        --     ]
                                        --
                                        -- else
                                        [ newTabLink [ alignTop ]
                                            { url = "https://ellie-app.com/" ++ i.ellieId
                                            , label =
                                                paragraph []
                                                    [ text <| i.title
                                                    , text " (#"
                                                    , text <| String.fromInt i.id
                                                    , text ", "
                                                    , text <| difficultyToString i.difficulty
                                                    , text ")"
                                                    ]
                                            }
                                        ]
                                    ]
                            )
                            index
                   ]
            )

        Err _ ->
            ( "Other Exercises"
            , [ el [ paddingLeft ] <| text "Index not available" ]
            )


viewTitle : String -> Element msg
viewTitle string =
    paragraph
        [ Region.heading 2
        , Font.size 20
        , Font.bold
        , Font.color <| rgba 0 0 0 0.8
        ]
        [ text string ]


subtitle : String -> Element msg
subtitle string =
    paragraph [ Region.heading 2, Font.size 20 ] [ text string ]


contentHelp : ( String, List (Element msg) )
contentHelp =
    ( "Help"
    , []
        ++ [ viewTitle "How does this work?" ]
        ++ [ column [ paddingLeft, spacing 16, width fill ] <|
                [ paragraph [] <|
                    [ text "Try solving the problem by writing Elm code in the editor on the left. Then click the "
                    , row
                        [ Background.color <| rgba 0 0 0 0.5
                        , Font.color <| rgba 1 1 1 0.9
                        , Border.rounded 2
                        , paddingXY 5 2
                        , Font.size 14
                        , spacing 3
                        , Border.color <| rgba 0 0 0 0.8
                        , Border.width 1
                        ]
                        [ el [ Font.size 13 ] <| text "▶"
                        , el [ Font.color <| rgba 0 0 0 0.2 ] <| text "|"
                        , text "COMPILE"
                        ]
                    , text " button that you find at the top and check if your implementation passes all tests. If not, try again!"
                    ]
                , paragraph [] [ text "You need to write only Elm language, so you can minimize the HTML editor in the left bottom area, to optimize your working space." ]
                , column [ spacing 16, width fill ] <| Internal.Markdown.markdown """If you need support, [join the Elm community in Slack](https://elmlang.herokuapp.com/).

There are also a lot of valuable resources to learn Elm on-line. for example:

* [An Introduction to Elm](https://guide.elm-lang.org/) - The official Elm Guide
* [Elm Packages](https://package.elm-lang.org/) - Documentation of Elm Packages
* [Elm Cheat Sheet](https://lucamug.github.io/elm-cheat-sheet/) - A condensate list of the most useful Elm concepts
* [Awesome Elm](https://github.com/sporto/awesome-elm) - A list of Elm resources"""
                ]
           ]
        ++ [ paragraph [ Font.center, paddingXY 10 30 ] [ text "♡ Happy coding! ♡" ] ]
    )


contentContribute : ( String, List (Element msg) )
contentContribute =
    ( "Contribute"
    , []
        ++ [ subtitle "Improve this Exercise" ]
        ++ [ column [ paddingLeft, spacing 16, width fill ] <| Internal.Markdown.markdown "If you find some mistake or you have some goot hint or a nice solution to add to this exercise, you can [edit it directly](https://github.com/lucamug/elm-exercises/edit/master/exercises/src/E/E001.elm)."
           ]
        ++ [ column [ paddingLeft, spacing 16, width fill ] <|
                -- https://github.com/lucamug/elm-exercises/edit/master/exercises/src/E/E001.elm
                [ column [ spacing 16, width fill ] <| Internal.Markdown.markdown """If you have some exercise that you would like to add to this list or if you have any other feedback, [learn how you can contribute](https://github.com/lucamug/elm-exercises/blob/master/CONTRIBUTING.md)."""
                ]
           ]
    )


viewFooter : Element (Msg msgExercise)
viewFooter =
    column [ width fill ]
        [ wrappedRow
            [ paddingEach { top = 40, right = 0, bottom = 0, left = 0 }
            , Font.color <| rgba 0 0 0 0.5
            , Background.color <| rgba 0 0 0 0.05
            , width fill
            , spacing 20
            ]
            [ Input.button (attrsButton ++ [ padding 10, centerX, Border.width 0 ])
                { onPress = Just <| ChangeMenu OtherExercises
                , label =
                    row [ spacing 7 ]
                        [ FeatherIcons.list
                            |> FeatherIcons.withSize 16
                            |> FeatherIcons.toHtml []
                            |> html
                            |> el [ centerX ]
                        , text <| "Other Exercises"
                        ]
                }
            , Input.button (attrsButton ++ [ padding 10, centerX, Border.width 0 ])
                { onPress = Just <| ChangeMenu Help
                , label =
                    row [ spacing 7 ]
                        [ FeatherIcons.helpCircle
                            |> FeatherIcons.withSize 16
                            |> FeatherIcons.toHtml []
                            |> html
                            |> el [ centerX ]
                        , text <| "Help"
                        ]
                }
            , Input.button (attrsButton ++ [ padding 10, centerX, Border.width 0 ])
                { onPress = Just <| ChangeMenu Contribute
                , label =
                    row [ spacing 7 ]
                        [ FeatherIcons.heart
                            |> FeatherIcons.withSize 16
                            |> FeatherIcons.toHtml []
                            |> html
                            |> el [ centerX ]
                        , text <| "Contribute"
                        ]
                }
            ]
        , paragraph
            [ Font.center
            , paddingXY 10 30
            , Font.size 14
            , Font.color <| rgba 0 0 0 0.5
            , Background.color <| rgba 0 0 0 0.05
            ]
            [ text <| "Made with "
            , newTabLink [] { url = "https://package.elm-lang.org/packages/lucamug/elm-exercises/latest/", label = text "elm-exercises" }
            , text " "
            , text version
            ]
        ]


viewHeader :
    { a | difficulty : Difficulty, id : Int, title : String }
    -> Result Codec.Error (List Index)
    -> Element (Msg msgExercise)
viewHeader exerciseData resultIndex =
    row
        [ width fill
        , spacing 20
        , Background.color <| rgb255 18 147 216
        , Font.color <| rgb 1 1 1
        , padding 20
        ]
        ([]
            ++ [ el [ alignTop ] <| html <| logo
               , column [ spacing 10, width fill ]
                    (if exerciseData.id == 0 then
                        [ paragraph [ Font.size 18 ] [ text "Elm Exercise" ] ]

                     else
                        []
                            ++ [ paragraph [ Font.size 14 ] [ text <| "Elm Exercise #" ++ String.fromInt exerciseData.id ] ]
                            ++ [ paragraph [ moveUp 5, Region.heading 1, Font.size 25 ] [ text exerciseData.title ] ]
                            ++ (case resultIndex of
                                    Ok index ->
                                        let
                                            maybeNext =
                                                Tuple.second <| previousAndNext exerciseData index
                                        in
                                        case maybeNext of
                                            Just next ->
                                                [ paragraph []
                                                    [ newTabLink [ htmlAttribute <| Html.Attributes.class "linkInTheHeader" ]
                                                        { url = "https://ellie-app.com/" ++ next.ellieId
                                                        , label =
                                                            row [ spacing 10 ]
                                                                [ el [ Font.size 12 ] <| text "▶"
                                                                , paragraph []
                                                                    [ text " Next exercise: "
                                                                    , text <| next.title
                                                                    ]
                                                                ]
                                                        }
                                                    ]
                                                ]

                                            Nothing ->
                                                []

                                    Err _ ->
                                        []
                               )
                    )
               ]
            ++ [ Input.button
                    (attrsButton
                        ++ [ alignRight
                           , Font.size 24
                           , padding 10
                           , Border.width 0
                           ]
                    )
                    { label = text "☰"
                    , onPress = Just <| ChangeMenu OtherExercises
                    }
               ]
        )


isOpen : Show -> Int -> Bool
isOpen show index =
    case show of
        ShowAll ->
            True

        ShowNone ->
            False

        Show set ->
            Set.member index set


accordion :
    { hideItem : Int -> msg
    , items : Show
    , itemsContent : List String
    , showItem : Int -> msg
    }
    -> Element msg
accordion { items, hideItem, showItem, itemsContent } =
    column [ paddingLeft, spacing 0, width fill ] <|
        List.indexedMap
            (\index solution ->
                column [ width fill, spacing 5 ]
                    [ if isOpen items index then
                        Input.button [ alignTop, width fill ]
                            { label =
                                row
                                    [ width fill
                                    , spacing 10
                                    , mouseOver [ Background.color <| rgba 0 0 0 0.05 ]
                                    , paddingXY 0 6
                                    ]
                                    [ el attrsButton <| text <| String.fromInt (index + 1)
                                    , el
                                        [ htmlAttribute <|
                                            Html.Attributes.style "transition" ".2s"
                                        , rotate -pi
                                        ]
                                      <|
                                        text "▼"
                                    , el [ Font.size 14 ] <| text " Hide"
                                    ]
                            , onPress = Just <| hideItem index
                            }

                      else
                        Input.button [ alignTop, width fill ]
                            { label =
                                row
                                    [ width fill
                                    , spacing 10
                                    , mouseOver [ Background.color <| rgba 0 0 0 0.05 ]
                                    , paddingXY 0 6
                                    ]
                                    [ el attrsButton <| text <| String.fromInt (index + 1)
                                    , el
                                        [ htmlAttribute <| Html.Attributes.style "transition" ".2s"
                                        ]
                                      <|
                                        text "▼"
                                    , el [ Font.size 14 ] <| text " Show"
                                    ]
                            , onPress = Just <| showItem index
                            }
                    , column
                        ([ alignTop
                         , paddingEach { top = 0, right = 0, bottom = 10, left = 30 }
                         , width fill
                         ]
                            ++ (if isOpen items index then
                                    []

                                else
                                    [ htmlAttribute <| Html.Attributes.style "display" "none" ]
                               )
                        )
                      <|
                        Internal.Markdown.markdown <|
                            solution
                    ]
            )
            itemsContent


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
            "Easy"

        Medium ->
            "Medium"

        Hard ->
            "Hard"

        Undefined ->
            ""


emptyExerciseData : ExerciseData
emptyExerciseData =
    { id = 0
    , title = ""
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
codecExerciseData : Codec.Codec ExerciseData
codecExerciseData =
    Codec.object ExerciseData
        |> Codec.field "id" .id Codec.int
        |> Codec.field "title" .title Codec.string
        |> Codec.field "difficulty" .difficulty (Codec.map stringToDifficulty difficultyToString Codec.string)
        |> Codec.field "categories" .categories (Codec.list Codec.string)
        |> Codec.field "ellieId" .ellieId Codec.string
        |> Codec.field "reference" .reference Codec.string
        |> Codec.field "problem" .problem Codec.string
        |> Codec.field "tests" .tests (Codec.list Codec.string)
        |> Codec.field "hints" .hints (Codec.list Codec.string)
        |> Codec.field "dummySolutions" .dummySolution Codec.string
        |> Codec.field "solutions" .solutions (Codec.list Codec.string)
        |> Codec.buildObject


{-| -}
type alias Index =
    { id : Int
    , title : String
    , difficulty : Difficulty
    , categories : List String
    , ellieId : String
    }


{-| -}
codecIndex : Codec.Codec Index
codecIndex =
    Codec.object Index
        |> Codec.field "id" .id Codec.int
        |> Codec.field "title" .title Codec.string
        |> Codec.field "difficulty" .difficulty (Codec.map stringToDifficulty difficultyToString Codec.string)
        |> Codec.field "categories" .categories (Codec.list Codec.string)
        |> Codec.field "ellieId" .ellieId Codec.string
        |> Codec.buildObject


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



-- FROM List.Extra


zip : List a -> List b -> List ( a, b )
zip =
    List.map2 Tuple.pair


getAt : Int -> List a -> Maybe a
getAt idx xs =
    if idx < 0 then
        Nothing

    else
        List.head <| List.drop idx xs


indexedFoldl : (Int -> a -> b -> b) -> b -> List a -> b
indexedFoldl func acc list =
    let
        step : a -> ( Int, b ) -> ( Int, b )
        step x ( i, thisAcc ) =
            ( i + 1, func i x thisAcc )
    in
    Tuple.second (List.foldl step ( 0, acc ) list)


failureReasonToString : Test.Runner.Failure.Reason -> String
failureReasonToString failureReason =
    case failureReason of
        --
        -- Refer to https://package.elm-lang.org/packages/elm-explorations/test/latest/Test-Runner-Failure#Reason
        --
        -- TODO - Refine these messages
        --
        Test.Runner.Failure.Equality expected actual ->
            "because I was given `"
                ++ actual
                ++ "` instead of `"
                ++ expected
                ++ "`"

        Test.Runner.Failure.Custom ->
            "Custom"

        Test.Runner.Failure.Comparison string1 string2 ->
            "Comparison `"
                ++ string1
                ++ "`,  `"
                ++ string2
                ++ "`"

        Test.Runner.Failure.ListDiff listString1 listString2 ->
            "ListDiff `"
                ++ String.join ", " listString1
                ++ "`, `"
                ++ String.join ", " listString2
                ++ "`"

        Test.Runner.Failure.CollectionDiff record ->
            "CollectionDiff, Expected = "
                ++ record.expected
                ++ ", Actual = "
                ++ record.actual
                ++ ", Extra = "
                ++ String.join "|" record.extra
                ++ ", Missing = "
                ++ String.join "|" record.missing

        Test.Runner.Failure.TODO ->
            "TODO"

        Test.Runner.Failure.Invalid invalidReason ->
            "Invalid, "
                ++ (case invalidReason of
                        Test.Runner.Failure.EmptyList ->
                            "EmptyList"

                        Test.Runner.Failure.NonpositiveFuzzCount ->
                            "NonpositiveFuzzCount"

                        Test.Runner.Failure.InvalidFuzzer ->
                            "InvalidFuzzer"

                        Test.Runner.Failure.BadDescription ->
                            "BadDescription"

                        Test.Runner.Failure.DuplicatedName ->
                            "DuplicatedName"
                   )


green : Color
green =
    rgb 0 0.6 0


red : Color
red =
    rgb 0.8 0 0


andThen : (msg -> model -> ( model, Cmd a )) -> msg -> ( model, Cmd a ) -> ( model, Cmd a )
andThen updater msg ( model, cmd ) =
    let
        ( modelNew, cmdNew ) =
            updater msg model
    in
    ( modelNew, Cmd.batch [ cmd, cmdNew ] )
