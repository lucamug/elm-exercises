module Internal.Data exposing (..)

import Codec
import Dict
import Element exposing (..)
import Exercises.Data
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
    | PortLocalStoragePush String


type alias Model modelExercise =
    { index : List Index
    , exerciseData : Exercises.Data.ExerciseData
    , localStorage : Dict.Dict Int LocalStorageRecord
    , modelExercise : modelExercise
    , menuOver : Bool
    , failureReasons : List FailureReason
    }


type alias LocalStorageRecord =
    { hints : Show
    , solutions : Show
    , menuOpen : Bool
    , menuContent : MenuContent
    , firstSeen : Maybe Time.Posix
    , lastSeen : Time.Posix
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
    = OtherExercises
    | Help
    | Contribute


menuContentToString : MenuContent -> String
menuContentToString menuContent =
    case menuContent of
        OtherExercises ->
            "otherExercises"

        Help ->
            "help"

        Contribute ->
            "contribute"


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


type Show
    = ShowAll
    | ShowNone
    | Show (Set.Set Int)


type alias Index =
    { id : Int
    , title : String
    , difficulty : Exercises.Data.Difficulty
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
    , menuContent = OtherExercises
    , firstSeen = Nothing
    , lastSeen = Time.millisToPosix 0
    , testsTotal = 0
    , testsPassed = 0
    }


timeInMillis :
    TEA modelExercise msgExercise1
    -> Model modelExercise
    -> Int
    -> Dict.Dict Int LocalStorageRecord
    -> Cmd (Msg msgExercise)
timeInMillis tea model exerciseId localStorage =
    -- From https://elm.dmy.fr/packages/elm/core/latest/Task#succeed
    Time.now
        |> Task.andThen (\posix -> Task.succeed (toLocalStorage posix tea model exerciseId localStorage))
        |> Task.andThen (\localStorage_ -> Task.succeed (localStorageToString localStorage_))
        |> Task.perform PortLocalStoragePush


toLocalStorage :
    Time.Posix
    -> TEA modelExercise msgExercise
    -> Model modelExercise
    -> comparable
    -> Dict.Dict comparable LocalStorageRecord
    -> Dict.Dict comparable LocalStorageRecord
toLocalStorage posix tea model exerciseId localStorage =
    let
        newLocalStorageRecord : LocalStorageRecord
        newLocalStorageRecord =
            case Dict.get exerciseId localStorage of
                Just localStorageRecord ->
                    toLocalStorageRecord posix tea model localStorageRecord

                Nothing ->
                    toLocalStorageRecord posix tea model initLocalStorageRecord
    in
    Dict.insert exerciseId newLocalStorageRecord localStorage


localStorageToString : Dict.Dict Int LocalStorageRecord -> String
localStorageToString localStorage =
    Debug.todo "TODO"



--
-- port portLocalStoragePush : String -> Cmd msg
--


toLocalStorageRecord :
    Time.Posix
    -> TEA modelExercise msgExercise
    -> Model modelExercise
    -> LocalStorageRecord
    -> LocalStorageRecord
toLocalStorageRecord posix tea model localStorageRecord =
    { localStorageRecord
        | firstSeen =
            case localStorageRecord.firstSeen of
                Nothing ->
                    Just posix

                Just fs ->
                    Just fs
        , lastSeen = posix
        , testsTotal = List.length (tea.tests model.modelExercise)
        , testsPassed =
            model.failureReasons
                |> List.filter ((==) Nothing)
                |> List.length
    }
