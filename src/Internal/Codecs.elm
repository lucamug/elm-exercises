module Internal.Codecs exposing (..)

import Codec
import Internal.Data
import Time


codecDifficulty : Codec.Codec Internal.Data.Difficulty
codecDifficulty =
    Codec.map
        Internal.Data.stringToDifficulty
        Internal.Data.difficultyToString
        Codec.string


codecIndex : Codec.Codec Internal.Data.Index
codecIndex =
    Codec.object Internal.Data.Index
        |> Codec.field "id" .id Codec.int
        |> Codec.field "title" .title Codec.string
        |> Codec.field "difficulty" .difficulty codecDifficulty
        |> Codec.field "categories" .categories (Codec.list Codec.string)
        |> Codec.field "ellieId" .ellieId Codec.string
        |> Codec.buildObject


codecExerciseData : Codec.Codec Internal.Data.ExerciseData
codecExerciseData =
    Codec.object Internal.Data.ExerciseData
        |> Codec.field "id" .id Codec.int
        |> Codec.field "title" .title Codec.string
        |> Codec.field "difficulty" .difficulty codecDifficulty
        |> Codec.field "categories" .categories (Codec.list Codec.string)
        |> Codec.field "ellieId" .ellieId Codec.string
        |> Codec.field "reference" .reference Codec.string
        |> Codec.field "problem" .problem Codec.string
        |> Codec.field "example" .example Codec.string
        |> Codec.field "tests" .tests (Codec.list Codec.string)
        |> Codec.field "hints" .hints (Codec.list Codec.string)
        |> Codec.field "dummySolutions" .dummySolution Codec.string
        |> Codec.field "solutions" .solutions (Codec.list Codec.string)
        |> Codec.buildObject


codecShow : Codec.Codec Internal.Data.Show
codecShow =
    Codec.custom
        (\showAll showNone show value ->
            case value of
                Internal.Data.ShowAll ->
                    showAll

                Internal.Data.ShowNone ->
                    showNone

                Internal.Data.Show setInt ->
                    show setInt
        )
        |> Codec.variant0 "showAll" Internal.Data.ShowAll
        |> Codec.variant0 "showNone" Internal.Data.ShowNone
        |> Codec.variant1 "show" Internal.Data.Show (Codec.set Codec.int)
        |> Codec.buildCustom


codecMenuContent : Codec.Codec Internal.Data.MenuContent
codecMenuContent =
    Codec.map
        Internal.Data.stringToMenuContent
        Internal.Data.menuContentToString
        Codec.string


codecLocalStorageRecord : Codec.Codec Internal.Data.LocalStorageRecord
codecLocalStorageRecord =
    Codec.object Internal.Data.LocalStorageRecord
        |> Codec.field "hints" .hints codecShow
        |> Codec.field "solutions" .solutions codecShow
        |> Codec.field "menuOpen" .menuOpen Codec.bool
        |> Codec.field "menuContent" .menuContent codecMenuContent
        |> Codec.field "firstSeen" .firstSeen codecPosix
        |> Codec.field "lastSeen" .lastSeen codecPosix
        |> Codec.field "solved" .solved (Codec.maybe codecPosix)
        |> Codec.field "testsTotal" .testsTotal Codec.int
        |> Codec.field "testsPassed" .testsPassed Codec.int
        |> Codec.buildObject


codecLocalStorageAsList : Codec.Codec Internal.Data.LocalStorageAsList
codecLocalStorageAsList =
    Codec.list (Codec.tuple Codec.int codecLocalStorageRecord)


codecPosix : Codec.Codec Time.Posix
codecPosix =
    Codec.map
        Time.millisToPosix
        Time.posixToMillis
        Codec.int
