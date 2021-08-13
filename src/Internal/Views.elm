module Internal.Views exposing (..)

import Browser
import Chart as C
import Chart.Attributes as CA
import Codec
import DateFormat
import DateFormat.Relative
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
import Internal.Data
import Internal.Markdown
import Json.Decode
import List.Extra
import Set
import String.Extra
import Svg
import Svg.Attributes as SA
import SyntaxHighlight
import Test.Runner
import Test.Runner.Failure
import Time


version : String
version =
    "2.0.5"


subtitle : String -> Element msg
subtitle string =
    paragraph [ Region.heading 2, Font.size 20 ] [ text string ]


contentHelp : ( String, FeatherIcons.Icon, List (Element (Internal.Data.Msg msgExercise)) )
contentHelp =
    ( "Help"
    , icons.help
    , []
        ++ [ viewTitle "How does this work?" ]
        ++ [ column [ spacing 16, width fill ] <|
                [ paragraph [] <|
                    [ text "Try solving the problem by writing Elm code in the editor on the left. Then click the "
                    , row
                        [ Background.color <| rgba 0 0 0 0.5
                        , Font.color <| rgba 1 1 1 0.9
                        , Border.rounded 2
                        , paddingXY 4 1
                        , Font.size 11
                        , spacing 3
                        , Border.color <| rgba 0 0 0 0.8
                        , Border.width 1
                        ]
                        [ el [ Font.size 10 ] <| text "▶"
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


viewHeader :
    Internal.Data.Model modelExercise
    -> Element (Internal.Data.Msg msgExercise)
viewHeader model =
    row
        [ width fill
        , spacing 20
        , padding 20
        , Background.color <| rgb255 53 71 92
        , Background.color <| rgb255 38 121 165
        , Background.color <| rgb255 18 147 216
        , Background.color <| rgb255 0 127 196
        , Font.color <| rgb 1 1 1
        , Font.size 16
        , Font.family [ Font.typeface "Source Sans Pro", Font.sansSerif ]
        ]
        ([]
            ++ [ el [ alignTop ] <| html <| logo
               , column [ spacing 10, width fill ]
                    ([]
                        ++ [ paragraph [ Font.size 14 ] [ text <| "Elm Exercise #" ++ String.fromInt model.exerciseData.id ] ]
                        ++ [ paragraph [ moveUp 5, Region.heading 1, Font.size 25 ] [ text model.exerciseData.title ] ]
                        ++ (let
                                maybeNext =
                                    Tuple.second <| previousAndNext model.exerciseData model.index
                            in
                            case maybeNext of
                                Just next ->
                                    [ paragraph []
                                        [ newTabLink [ htmlAttribute <| Html.Attributes.class "linkInTheHeader" ]
                                            { url = "https://ellie-app.com/" ++ next.ellieId
                                            , label =
                                                row [ spacing 5 ]
                                                    [ FeatherIcons.chevronsRight
                                                        |> FeatherIcons.withSize 20
                                                        |> FeatherIcons.toHtml []
                                                        |> html
                                                        |> el [ moveDown 1.5, alignTop ]
                                                    , paragraph []
                                                        [ text "Next exercise: "
                                                        , text <| next.title
                                                        ]
                                                    ]
                                            }
                                        ]
                                    ]

                                Nothing ->
                                    []
                           )
                    )
               ]
        )


viewFooter : Element (Internal.Data.Msg msgExercise)
viewFooter =
    column
        [ width fill
        , Background.color <| rgba 0 0 0 0.05
        , Font.color <| rgba 0 0 0 0.5
        , paddingXY 10 0
        ]
        [ el [ centerX ] <|
            wrappedRow
                [ paddingEach { top = 40, right = 0, bottom = 0, left = 0 }
                , Font.color <| rgba 0 0 0 0.5
                , spacing 15
                ]
                [ footerLink Internal.Data.ContentHints icons.hints "Hints"
                , footerLink Internal.Data.ContentSolutions icons.solutions "Solutions"
                , footerLink Internal.Data.ContentHistory icons.history "History"
                , footerLink Internal.Data.ContentOtherExercises icons.otherExercises "Other Exercises"
                , footerLink Internal.Data.ContentHelp icons.help "Help"
                , footerLink Internal.Data.ContentContribute icons.contribute "Contribute"
                ]
        , paragraph
            [ Font.center
            , Font.size 14
            , paddingXY 0 30
            ]
            [ text <| "Made with "
            , newTabLink [] { url = "https://package.elm-lang.org/packages/lucamug/elm-exercises/latest/", label = text "elm-exercises" }
            , text " "
            , text version
            ]
        ]


icons :
    { contribute : FeatherIcons.Icon
    , help : FeatherIcons.Icon
    , hints : FeatherIcons.Icon
    , history : FeatherIcons.Icon
    , otherExercises : FeatherIcons.Icon
    , solutions : FeatherIcons.Icon
    }
icons =
    { hints = FeatherIcons.crosshair
    , solutions = FeatherIcons.bookOpen
    , history = FeatherIcons.calendar
    , otherExercises = FeatherIcons.list
    , help = FeatherIcons.helpCircle
    , contribute = FeatherIcons.heart
    }


footerLink :
    Internal.Data.MenuContent
    -> FeatherIcons.Icon
    -> String
    -> Element (Internal.Data.Msg msgExercise)
footerLink content icon string =
    Input.button (attrsButton ++ [ padding 10, centerX, Border.width 0 ])
        { onPress = Just <| Internal.Data.ChangeMenu content
        , label =
            row [ spacing 7 ]
                [ icon
                    |> FeatherIcons.withSize 16
                    |> FeatherIcons.toHtml []
                    |> html
                    |> el [ centerX ]
                , text <| string
                ]
        }


viewElement :
    Internal.Data.TEA modelExercise msgExercise
    -> Internal.Data.Model modelExercise
    -> Element (Internal.Data.Msg msgExercise)
viewElement tea model =
    column
        [ spacing 0
        , width fill
        , Font.size 16
        , Font.family [ Font.typeface "Source Sans Pro", Font.sansSerif ]
        , inFront <| html <| SyntaxHighlight.useTheme SyntaxHighlight.gitHub
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
                color: rgba(255, 255, 255, 0.5);
                transition: .2s;
            }

            a.linkInTheHeader:hover {
                color: rgb(255, 255, 255);
            }
            
            .fail {
                stroke: rgb(204, 0, 0);
            }
            
            .pass { 
                stroke: rgb(0, 153, 0);
            }

            .elmsh {
                background-color: rgba(0,0,0,0);
                font-size: 14px;
                line-height: 18px;
                font-family: 'Source Code Pro', monospace;
            }
            
            
            pre {margin: 0px; padding: 10px}
            
            .s.r > s:first-of-type.accx { flex-grow: 0 !important; }
            .s.r > s:last-of-type.accx { flex-grow: 0 !important; }
            .cx > .wrp { justify-content: center !important; }
            
            """ ]
        ]
        ([]
            ++ [ viewHeader model ]
            ++ [ viewBody tea model ]
            ++ [ viewFooter ]
        )


accordion :
    { hideItem : Int -> msg
    , items : Internal.Data.Show
    , itemsContent : List String
    , showItem : Int -> msg
    }
    -> Element msg
accordion { items, hideItem, showItem, itemsContent } =
    column [ spacing 0, width fill ] <|
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


isOpen : Internal.Data.Show -> Int -> Bool
isOpen show index =
    case show of
        Internal.Data.ShowAll ->
            True

        Internal.Data.ShowNone ->
            False

        Internal.Data.Show set ->
            Set.member index set


gitHubDirectLink : Int -> String
gitHubDirectLink id =
    "https://github.com/lucamug/elm-exercises/edit/master/exercises/src/E"
        ++ String.padLeft 3 '0' (String.fromInt id)
        ++ ".elm"


contentHints :
    Internal.Data.Model modelExercise
    -> ( String, FeatherIcons.Icon, List (Element (Internal.Data.Msg msgExercise)) )
contentHints model =
    ( "Hints"
    , icons.hints
    , if List.isEmpty model.exerciseData.solutions then
        [ el
            [ width fill
            , height fill
            , paddingXY 50 0
            ]
          <|
            column
                [ centerX
                , centerY
                , Font.center
                , spacing 16
                , width fill
                ]
            <|
                Internal.Markdown.markdown
                    ("Sorry, no hints for this exercise yet. If you have a hint, [please add it here]("
                        ++ gitHubDirectLink model.exerciseData.id
                        ++ ")."
                    )
        ]

      else
        []
            ++ [ wrappedRow [ spacing 10 ]
                    [ Input.button attrsButton { onPress = Just Internal.Data.ShowHintsAll, label = text "Show All" }
                    , Input.button attrsButton { onPress = Just Internal.Data.ShowHintsNone, label = text "Hide All" }
                    ]
               ]
            ++ [ accordion
                    { items = model.localStorageRecord.hints
                    , hideItem = Internal.Data.HideHint
                    , showItem = Internal.Data.ShowHint
                    , itemsContent = model.exerciseData.hints
                    }
               ]
    )


contentSolutions :
    Internal.Data.Model modelExercise
    -> ( String, FeatherIcons.Icon, List (Element (Internal.Data.Msg msgExercise)) )
contentSolutions model =
    let
        qty : Int
        qty =
            List.length model.exerciseData.solutions
    in
    ( "Solutions"
    , icons.solutions
    , if qty > 0 then
        []
            ++ [ wrappedRow [ spacing 10 ]
                    [ Input.button attrsButton { onPress = Just Internal.Data.ShowSolutionsAll, label = text "Show All" }
                    , Input.button attrsButton { onPress = Just Internal.Data.ShowSolutionsNone, label = text "Hide All" }
                    ]
               ]
            ++ [ accordion
                    { items = model.localStorageRecord.solutions
                    , hideItem = Internal.Data.HideSolution
                    , showItem = Internal.Data.ShowSolution
                    , itemsContent = model.exerciseData.solutions
                    }
               ]

      else
        [ el
            [ width fill
            , height fill
            , paddingXY 50 0
            ]
          <|
            column
                [ centerX
                , centerY
                , Font.center
                , spacing 16
                , width fill
                ]
            <|
                Internal.Markdown.markdown
                    ("Sorry, no solutions for this exercise yet. If you have a solution, [please add it here]("
                        ++ gitHubDirectLink model.exerciseData.id
                        ++ ")."
                    )
        ]
    )


chart1 :
    { c
        | index : List a1
        , localStorage : Dict.Dict k { b | testsPassed : a, testsTotal : a }
    }
    -> Element msg
chart1 model =
    let
        solved : Int
        solved =
            model.localStorage
                |> Dict.toList
                |> List.filter
                    (\( id, localStorageRecord ) ->
                        localStorageRecord.testsPassed == localStorageRecord.testsTotal
                    )
                |> List.length

        total : Int
        total =
            model.index
                |> List.length

        seen : Int
        seen =
            model.localStorage
                |> Dict.toList
                |> List.length
    in
    C.chart
        [ CA.height 200
        , CA.width 300
        ]
        [ C.grid []
        , C.yLabels [ CA.withGrid ]
        , C.binLabels .label [ CA.moveDown 20 ]
        , C.bars
            []
            [ C.bar .y [ CA.color CA.blue ] ]
            [ { y = toFloat solved, label = "Solved" }
            , { y = toFloat (seen - solved), label = "Not solved" }
            , { y = toFloat seen, label = "Seen" }
            , { y = toFloat (total - seen), label = "Not seen" }
            ]
        , C.barLabels [ CA.moveUp 10 ]
        ]
        |> html
        |> el
            [ width <| px 300
            , centerX
            , paddingXY 0 20
            ]


chart2 :
    { c
        | index : List a1
        , localStorage :
            Dict.Dict
                k
                { b
                    | firstSeen : Time.Posix
                    , solved : Maybe Time.Posix
                    , testsPassed : a
                    , testsTotal : a
                }
    }
    -> Element msg
chart2 model =
    -- This Chart is not ready yet
    let
        test : List Int
        test =
            model.localStorage
                |> Dict.toList
                |> List.foldl
                    (\( id, localStorageRecord ) acc ->
                        case localStorageRecord.solved of
                            Nothing ->
                                acc

                            Just solvedPosix ->
                                (Time.posixToMillis solvedPosix
                                    - Time.posixToMillis localStorageRecord.firstSeen
                                )
                                    // 1000
                                    :: acc
                    )
                    []

        minSecs : Int
        minSecs =
            test
                |> List.minimum
                |> Maybe.withDefault 0

        maxSecs : Int
        maxSecs =
            test
                |> List.maximum
                |> Maybe.withDefault 10000

        maxRange : Int
        maxRange =
            maxSecs + minSecs

        intervals : number
        intervals =
            10

        rangeInterval : Float
        rangeInterval =
            toFloat maxRange / intervals

        f : Int -> List number -> List number
        f index acc =
            let
                iii =
                    500
            in
            if
                (iii
                    > toFloat index
                    * rangeInterval
                )
                    && (iii
                            <= toFloat (index + 1)
                            * rangeInterval
                       )
            then
                iii :: acc

            else
                acc

        tot : List number
        tot =
            List.range 0 intervals
                |> List.Extra.indexedFoldl
                    (\index item acc ->
                        f index acc
                     -- ( toFloat index * rangeInterval, toFloat (index + 1) * rangeInterval ) :: acc
                    )
                    []

        solved : Int
        solved =
            model.localStorage
                |> Dict.toList
                |> List.filter
                    (\( id, localStorageRecord ) ->
                        localStorageRecord.testsPassed == localStorageRecord.testsTotal
                    )
                |> List.length

        total : Int
        total =
            model.index
                |> List.length

        seen : Int
        seen =
            model.localStorage
                |> Dict.toList
                |> List.length
    in
    C.chart
        [ CA.height 200
        , CA.width 300
        ]
        [ C.grid []
        , C.yLabels [ CA.withGrid ]
        , C.binLabels .label [ CA.moveDown 20 ]
        , C.bars
            []
            [ C.bar .y [ CA.color CA.blue ]
            ]
            [ { y = toFloat solved, label = "Solved" }
            , { y = toFloat (seen - solved), label = "Not solved" }
            , { y = toFloat seen, label = "Seen" }
            , { y = toFloat (total - seen), label = "Unseen" }
            ]
        , C.barLabels [ CA.moveDown 15, CA.color "white" ]
        ]
        |> html
        |> el
            [ width <| px 300
            , centerX
            , paddingXY 0 20
            ]


contentHistory :
    Internal.Data.Model modelExercise
    -> ( String, FeatherIcons.Icon, List (Element (Internal.Data.Msg msgExercise)) )
contentHistory model =
    ( "History"
    , icons.history
    , [ column [ spacing 30 ] <|
            []
                ++ [ chart1 model ]
                ++ [ viewTitle "Seen exercises" ]
                ++ List.map
                    (\( id, localStorageRecord ) ->
                        let
                            maybeExerciseData : Maybe Internal.Data.Index
                            maybeExerciseData =
                                model.index
                                    |> List.filter (\e -> e.id == id)
                                    |> List.head
                        in
                        case maybeExerciseData of
                            Just index ->
                                viewExcerciseWithHistory model.posixNow model.exerciseData.id index localStorageRecord

                            Nothing ->
                                none
                    )
                    (List.sortBy
                        (\( id, localStorageRecord ) ->
                            Time.posixToMillis localStorageRecord.firstSeen
                        )
                        (Dict.toList model.localStorage)
                    )
                ++ [ viewTitle "Privacy note" ]
                ++ [ paragraph [] [ text "We don't store this data to any external server. We store it to the local storage of your browser. \n\nThe history is only visible to you to keep track of which exercise you have seen and solved." ] ]
                ++ [ column [ spacing 10 ]
                        [ paragraph [ Font.color red, Font.bold ] [ text "Dangerous zone" ]
                        , Input.button
                            [ padding 10
                            , Border.rounded 5
                            , Font.color red
                            , Border.color red
                            , Border.width 1
                            ]
                            { label = text "Remove the entire history"
                            , onPress = Just Internal.Data.RemoveHistory
                            }
                        ]
                   ]
      ]
    )


viewExcerciseWithHistory :
    Time.Posix
    -> Int
    -> Internal.Data.Index
    -> Internal.Data.LocalStorageRecord
    -> Element (Internal.Data.Msg msgExercise)
viewExcerciseWithHistory posix nowId index localStorageRecord =
    column
        [ spacing 8
        , Border.width 1
        , Border.rounded 5
        , Border.color <| rgba 0 0 0 0.2
        , padding 10
        ]
    <|
        []
            ++ [ exerciseLink [ Font.size 20, paddingEach { top = 0, right = 0, bottom = 10, left = 0 } ] index nowId ]
            ++ [ row [ paddingEach { top = 0, right = 0, bottom = 0, left = 25 }, spacing 10 ]
                    [ FeatherIcons.eye
                        |> FeatherIcons.withSize 18
                        |> FeatherIcons.toHtml []
                        |> html
                        |> el []
                    , paragraph []
                        [ text "First seen "
                        , text <| DateFormat.Relative.relativeTime posix localStorageRecord.firstSeen
                        ]
                    ]
               ]
            ++ [ row [ paddingEach { top = 0, right = 0, bottom = 0, left = 25 }, spacing 10 ]
                    [ (case localStorageRecord.solved of
                        Just _ ->
                            FeatherIcons.check

                        Nothing ->
                            FeatherIcons.x
                      )
                        |> FeatherIcons.withSize 18
                        |> (FeatherIcons.withClass <|
                                case localStorageRecord.solved of
                                    Just _ ->
                                        "pass"

                                    Nothing ->
                                        "fail"
                           )
                        |> FeatherIcons.toHtml []
                        |> html
                        |> el [ alignTop ]
                    , case localStorageRecord.solved of
                        Just solved ->
                            paragraph [ Font.color green ]
                                [ text "Solved in "
                                , text <| DateFormat.Relative.relativeTimeWithOptions relativeTimeOptions localStorageRecord.firstSeen solved
                                ]

                        Nothing ->
                            paragraph [ Font.color red ]
                                [ text <|
                                    "Not solved yet, only "
                                        ++ String.fromInt localStorageRecord.testsPassed
                                        ++ " out of "
                                        ++ String.fromInt localStorageRecord.testsTotal
                                        ++ " tests passed (seen for "
                                        ++ DateFormat.Relative.relativeTimeWithOptions relativeTimeOptions localStorageRecord.firstSeen localStorageRecord.lastSeen
                                        ++ ")"
                                ]
                    ]
               ]
            ++ [ Input.button []
                    { onPress = Just <| Internal.Data.RemoveFromHistory index.id
                    , label =
                        row [ paddingEach { top = 0, right = 0, bottom = 0, left = 25 }, spacing 10 ]
                            [ (if nowId == index.id then
                                FeatherIcons.refreshCw

                               else
                                FeatherIcons.trash2
                              )
                                |> FeatherIcons.withSize 18
                                |> FeatherIcons.toHtml []
                                |> html
                                |> el []
                            , paragraph [ Font.color <| rgb255 18 147 216 ]
                                [ text <|
                                    if nowId == index.id then
                                        "Reset"

                                    else
                                        "Remove from history"
                                ]
                            ]
                    }
               ]


relativeTimeOptions :
    { inSomeDays : Int -> String
    , inSomeHours : Int -> String
    , inSomeMinutes : Int -> String
    , inSomeMonths : Int -> String
    , inSomeSeconds : Int -> String
    , inSomeYears : Int -> String
    , rightNow : String
    , someDaysAgo : Int -> String
    , someHoursAgo : Int -> String
    , someMinutesAgo : Int -> String
    , someMonthsAgo : Int -> String
    , someSecondsAgo : Int -> String
    , someYearsAgo : Int -> String
    }
relativeTimeOptions =
    { someSecondsAgo = \int -> String.fromInt int ++ " seconds"
    , someMinutesAgo = \int -> String.fromInt int ++ " minutes"
    , someHoursAgo = \int -> String.fromInt int ++ " hours"
    , someDaysAgo = \int -> String.fromInt int ++ " days"
    , someMonthsAgo = \int -> String.fromInt int ++ " months"
    , someYearsAgo = \int -> String.fromInt int ++ " years"
    , rightNow = "0 seconds"
    , inSomeSeconds = \int -> String.fromInt int ++ " seconds"
    , inSomeMinutes = \int -> String.fromInt int ++ " minutes"
    , inSomeHours = \int -> String.fromInt int ++ " hours"
    , inSomeDays = \int -> String.fromInt int ++ " days"
    , inSomeMonths = \int -> String.fromInt int ++ " months"
    , inSomeYears = \int -> String.fromInt int ++ " years"
    }


contentOtherExercises :
    Internal.Data.Model modelExercise
    -> ( String, FeatherIcons.Icon, List (Element (Internal.Data.Msg msgExercise)) )
contentOtherExercises model =
    ( "Other Exercises"
    , icons.otherExercises
    , []
        ++ [ viewTitle "Exercises by Category" ]
        ++ [ model.index
                |> categories
                |> Dict.map
                    (\category excercises ->
                        column [ spacing 10 ]
                            [ subtitle <| category ++ " (" ++ String.fromInt (List.length excercises) ++ ")"
                            , column
                                [ paddingEach { top = 0, right = 0, bottom = 0, left = 10 }, spacing 5 ]
                              <|
                                List.map (\exercise -> exerciseLink2 model exercise) excercises
                            ]
                    )
                |> Dict.values
                |> column [ spacing 20 ]
           ]
        ++ [ viewTitle "All Exercises" ]
        ++ [ column [ paddingEach { top = 0, right = 0, bottom = 0, left = 10 }, spacing 5 ] <|
                List.map
                    (\i -> exerciseLink2 model i)
                    model.index
           ]
    )


exerciseLink :
    List (Attribute msg)
    -> Internal.Data.Index
    -> Int
    -> Element msg
exerciseLink attrs index nowId =
    if index.id == nowId then
        row ([ spacing 10 ] ++ attrs)
            [ paragraph [ Font.bold ]
                [ text <| index.title
                , text " (#"
                , text <| String.fromInt index.id
                , text ", "
                , text <| Internal.Data.difficultyToString index.difficulty
                , text ")"
                ]
            ]

    else
        row ([ spacing 10 ] ++ attrs)
            [ paragraph []
                [ newTabLink [ alignTop ]
                    { url = "https://ellie-app.com/" ++ index.ellieId
                    , label =
                        paragraph []
                            [ text <| index.title
                            , text " (#"
                            , text <| String.fromInt index.id
                            , text ", "
                            , text <| Internal.Data.difficultyToString index.difficulty
                            , text ")"
                            ]
                    }
                ]
            ]


exerciseLink2 : { b | exerciseData : { a | id : Int } } -> Internal.Data.Index -> Element msg
exerciseLink2 model i =
    row [ spacing 10 ]
        [ el [ alignTop ] <| text "•"
        , paragraph [] <|
            [ exerciseLink [] i model.exerciseData.id ]
        ]


viewTitle : String -> Element msg
viewTitle string =
    paragraph
        [ Region.heading 2
        , Font.size 20
        , Font.bold
        , Font.color <| rgba 0 0 0 0.8
        ]
        [ text string ]


contentContribute : Int -> ( String, FeatherIcons.Icon, List (Element (Internal.Data.Msg msgExercise)) )
contentContribute id =
    ( "Contribute"
    , icons.contribute
    , []
        ++ [ viewTitle "Improve this exercise" ]
        ++ [ column [ spacing 16, width fill ] <|
                Internal.Markdown.markdown <|
                    "If you find some mistake or you have some goot hint or a nice solution to add to this exercise, you can [edit it directly]("
                        ++ gitHubDirectLink id
                        ++ ")."
           ]
        ++ [ viewTitle "Crate new exercises" ]
        ++ [ column [ spacing 16, width fill ] <|
                -- https://github.com/lucamug/elm-exercises/edit/master/exercises/src/E/E001.elm
                [ column [ spacing 16, width fill ] <| Internal.Markdown.markdown """If you have some exercise that you would like to add to this list or if you have any other feedback, [learn how you can contribute](https://github.com/lucamug/elm-exercises/blob/master/CONTRIBUTING.md)."""
                ]
           ]
    )


viewMainTitle : String -> Element msg
viewMainTitle string =
    paragraph [ Region.heading 2, Font.size 24, Font.bold, moveDown 20 ] [ text string ]


viewTests :
    { c
        | exerciseData : { b | id : Int, tests : List String }
        , failureReasons : List (Maybe { a | reason : Test.Runner.Failure.Reason })
        , index : List Internal.Data.Index
    }
    -> Element msg
viewTests model =
    column [ spacing 20, width fill ] <|
        ([]
            ++ [ let
                    failed : Int
                    failed =
                        model.failureReasons
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
                        model.failureReasons
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
                                ++ (let
                                        maybeNext =
                                            Tuple.second <| previousAndNext model.exerciseData model.index
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
                        zip model.exerciseData.tests model.failureReasons
                in
                List.map
                    (\( test, failureReason ) ->
                        case failureReason of
                            Nothing ->
                                wrappedRow [ spacing 6, width fill ]
                                    [ FeatherIcons.check
                                        |> FeatherIcons.withSize 16
                                        |> FeatherIcons.withClass "pass"
                                        |> FeatherIcons.toHtml []
                                        |> html
                                        |> el [ alignTop, moveDown 4 ]

                                    -- , el [ alignTop, moveDown 3 ] <| text "✅"
                                    , el [ Font.color green, width <| px 50, alignTop, moveDown 3 ] <| text "Passed"
                                    , paragraph [] <|
                                        Internal.Markdown.markdown <|
                                            "`"
                                                ++ test
                                                ++ "`"
                                    ]

                            Just reason ->
                                wrappedRow [ spacing 6, width fill ]
                                    [ FeatherIcons.x
                                        |> FeatherIcons.withSize 16
                                        |> FeatherIcons.withClass "fail"
                                        |> FeatherIcons.toHtml []
                                        |> html
                                        |> el [ alignTop, moveDown 4 ]

                                    -- [ el [ alignTop, moveDown 3 ] <| text "❌"
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


viewBody :
    Internal.Data.TEA modelExercise msgExercise
    -> Internal.Data.Model modelExercise
    -> Element (Internal.Data.Msg msgExercise)
viewBody tea model =
    let
        paddingLeft : Int
        paddingLeft =
            20

        paddingRight : Int
        paddingRight =
            60

        columnSpacing : Int
        columnSpacing =
            20

        isLargeWindow width =
            width > 600

        widthColumn =
            if isLargeWindow model.width then
                (model.width - paddingLeft - paddingRight - columnSpacing) // 2

            else
                model.width - paddingLeft - paddingRight
    in
    column
        [ spacing 40
        , paddingEach
            { top = 10
            , right = paddingRight
            , bottom = 20
            , left = paddingLeft
            }
        , width fill
        ]
    <|
        []
            ++ [ (if isLargeWindow model.width then
                    row

                  else
                    column
                 )
                    [ spacing columnSpacing ]
                    [ column
                        [ spacing 40
                        , alignTop
                        , width <| px widthColumn
                        ]
                        ([]
                            ++ [ viewMainTitle "Problem" ]
                            ++ [ column
                                    [ spacing 16
                                    , width fill
                                    ]
                                 <|
                                    []
                                        ++ Internal.Markdown.markdown
                                            (model.exerciseData.problem
                                                ++ (if String.isEmpty model.exerciseData.example then
                                                        ""

                                                    else
                                                        "\n## Examples\n```elm\n" ++ model.exerciseData.example ++ "\n```\n\n"
                                                   )
                                            )
                                        ++ [ paragraph [ alpha 0.5 ]
                                                [ text "Diffculty level: "
                                                , el [] <| text <| String.Extra.toSentenceCase <| Internal.Data.difficultyToString model.exerciseData.difficulty
                                                ]
                                           ]
                                        ++ (if String.isEmpty model.exerciseData.reference then
                                                []

                                            else
                                                [ paragraph [ alpha 0.5 ]
                                                    [ text "Reference: "
                                                    , newTabLink []
                                                        { label = text model.exerciseData.reference
                                                        , url = model.exerciseData.reference
                                                        }
                                                    ]
                                                ]
                                           )
                               ]
                        )
                    , column
                        [ spacing 40
                        , width fill
                        , alignTop
                        , width <| px widthColumn
                        ]
                        ([]
                            ++ [ viewMainTitle "Tests" ]
                            ++ [ viewTests model ]
                        )
                    ]
               ]
            ++ (case tea.maybeView of
                    Just view_ ->
                        [ viewMainTitle "Result"
                        , el [ width fill ] <| map Internal.Data.MsgTEA <| view_ model.modelExercise
                        ]

                    Nothing ->
                        []
               )


sideButton :
    Internal.Data.MenuContent
    -> FeatherIcons.Icon
    -> String
    -> Maybe Int
    -> Element (Internal.Data.Msg msgExercise)
sideButton content icon string quantity =
    Input.button
        ([]
            ++ [ padding 13
               , Border.widthEach { bottom = 1, left = 1, right = 0, top = 1 }
               , Border.roundEach { topLeft = 4, topRight = 0, bottomLeft = 4, bottomRight = 0 }
               , Border.color <| rgba 0 0 0 0.2
               , Background.color <| rgba 1 1 1 0.9
               , width <| px 145
               ]
            ++ (case quantity of
                    Nothing ->
                        []

                    Just qty ->
                        [ inFront <|
                            el
                                [ width <| px 16
                                , height <| px 16
                                , Background.color <| rgb 0.2 0.6 0.9
                                , Font.color <| rgb 1 1 1
                                , Font.size 12
                                , Border.rounded 16
                                , moveRight 28
                                , moveDown 6
                                ]
                            <|
                                el [ centerX, centerY ] <|
                                    text <|
                                        String.fromInt qty
                        ]
               )
        )
        { label =
            row [ spacing 15 ]
                [ icon
                    |> FeatherIcons.toHtml []
                    |> html
                    |> el [ centerX ]
                , paragraph [ width fill, spacing 4 ]
                    [ el [ Font.size 12 ] <| text <| String.toUpper string
                    ]
                ]
        , onPress = Just <| Internal.Data.ChangeMenu content
        }


viewSideButtons :
    Internal.Data.Model modelExercise
    -> Element (Internal.Data.Msg msgExercise)
viewSideButtons model =
    column
        [ alignRight
        , centerY
        , spacing 10
        , Events.onMouseEnter <| Internal.Data.MenuOver True
        , Events.onMouseLeave <| Internal.Data.MenuOver False
        , htmlAttribute <| Html.Attributes.style "transition" "0.2s"
        , if model.localStorageRecord.menuOpen then
            if model.menuOver then
                moveRight 0

            else
                moveRight 130

          else if model.menuOver then
            moveRight 0

          else
            moveRight 93
        ]
        [ sideButton Internal.Data.ContentHints icons.hints "Hints" (maybeLength model.exerciseData.hints)
        , sideButton Internal.Data.ContentSolutions icons.solutions "Solutions" (maybeLength model.exerciseData.solutions)
        , sideButton Internal.Data.ContentHistory icons.history "History" (maybeLength <| Dict.toList model.localStorage)
        , sideButton Internal.Data.ContentOtherExercises icons.otherExercises "Other Exercises" Nothing
        , sideButton Internal.Data.ContentHelp icons.help "Help" Nothing
        , sideButton Internal.Data.ContentContribute icons.contribute "Contribute" Nothing
        ]


maybeLength : List a -> Maybe Int
maybeLength list =
    let
        length =
            List.length list
    in
    if length == 0 then
        Nothing

    else
        Just length


viewElementAttrs :
    Internal.Data.Model modelExercise
    -> List (Attribute (Internal.Data.Msg msgExercise))
viewElementAttrs model =
    []
        ++ (if model.localStorageRecord.menuOpen then
                [ inFront <|
                    -- Cover layer
                    el
                        [ width fill
                        , height fill
                        , Background.color <| rgba 0 0 0 0.2
                        , htmlAttribute <| Html.Attributes.style "transition" "0.2s"
                        , Events.onClick <| Internal.Data.ChangeMenu model.localStorageRecord.menuContent
                        ]
                    <|
                        none
                ]

            else
                [ inFront <| text "" ]
           )
        ++ [ inFront <| viewSideMenu model ]
        ++ [ inFront <| viewSideButtons model ]
        ++ (if model.localStorageRecord.menuOpen then
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
                        , onPress = Just <| Internal.Data.ChangeMenu model.localStorageRecord.menuContent
                        }
                ]

            else
                []
           )


view :
    Internal.Data.TEA modelExercise msgExercise
    -> Internal.Data.Model modelExercise
    -> Html.Html (Internal.Data.Msg msgExercise)
view tea model =
    layoutWith
        { options = [ focusStyle { borderColor = Nothing, backgroundColor = Nothing, shadow = Nothing } ] }
        ([ inFront <| viewHeader model ]
            ++ viewElementAttrs model
        )
        (viewElement tea model)


viewSideMenu :
    Internal.Data.Model modelExercise
    -> Element (Internal.Data.Msg msgExercise)
viewSideMenu model =
    case model.localStorageRecord.menuContent of
        Internal.Data.ContentHints ->
            viewContent model <| contentHints model

        Internal.Data.ContentSolutions ->
            viewContent model <| contentSolutions model

        Internal.Data.ContentHistory ->
            viewContent model <| contentHistory model

        Internal.Data.ContentOtherExercises ->
            viewContent model <| contentOtherExercises model

        Internal.Data.ContentHelp ->
            viewContent model <| contentHelp

        Internal.Data.ContentContribute ->
            viewContent model <| contentContribute model.exerciseData.id


viewContent :
    Internal.Data.Model modelExercise
    -> ( String, FeatherIcons.Icon, List (Element msg) )
    -> Element msg
viewContent model ( title, icon, content ) =
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
        , if model.localStorageRecord.menuOpen then
            moveRight 0

          else
            moveRight <| toFloat <| widthSize + 10
        ]
    <|
        []
            ++ [ row
                    [ Background.color <| rgba 0 0 0 0.1
                    , width fill
                    , paddingXY 20 30
                    , spacing 10
                    ]
                    [ icon
                        |> FeatherIcons.toHtml []
                        |> html
                        |> el []
                    , paragraph
                        [ Region.heading 2
                        , Font.size 24
                        , Font.bold
                        ]
                        [ text title ]
                    ]
               ]
            ++ [ column
                    [ paddingEach { top = 30, right = 30, bottom = 20, left = 20 }
                    , spacing 20

                    -- scrollabar is not working
                    , scrollbarY
                    , width fill
                    , height fill
                    ]
                 <|
                    content
               ]


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


green : Color
green =
    rgb 0 0.6 0


red : Color
red =
    rgb 0.8 0 0


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


previousAndNext : { a | id : Int } -> List Internal.Data.Index -> ( Maybe Internal.Data.Index, Maybe Internal.Data.Index )
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


categories : List Internal.Data.Index -> Dict.Dict String (List Internal.Data.Index)
categories exercises =
    List.foldl
        (\exerciseData acc ->
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
                        acc2
                )
                acc
                exerciseData.categories
        )
        Dict.empty
        exercises


difficulties : List Internal.Data.Index -> Dict.Dict String Internal.Data.Index
difficulties exercises =
    List.foldl
        (\exerciseData acc ->
            Dict.insert (Internal.Data.difficultyToString exerciseData.difficulty) exerciseData acc
        )
        Dict.empty
        exercises


svgBulb2 : Html.Html msg
svgBulb2 =
    Svg.svg [ SA.viewBox "0 0 442 442", SA.width "100%", SA.height "100%" ]
        [ Svg.path [ SA.d "M221 0a149 149 0 00-77 276l4 35c3 16 16 29 32 29h82c16 0 30-13 32-29l5-35A149 149 0 00221 0zm63 261c-2 1-4 4-5 7l-5 40c-1 7-6 12-12 12h-82c-6 0-11-5-12-12l-5-40c-1-3-2-6-5-7a129 129 0 0163-241 129 129 0 0163 241zM273 351H169a10 10 0 100 20h104a10 10 0 100-20zM261 383h-80c-5 0-10 4-10 10a50 50 0 00100 0c0-6-5-10-10-10zm-40 39c-13 0-24-8-28-19h56c-4 11-15 19-28 19z" ] []
        , Svg.path [ SA.d "M284 155v-1-1-1-1-1a9 9 0 00-2-1v-1a10 10 0 00-5-3 10 10 0 00-2 0h-4l-1 1a9 9 0 00-2 1l-20 16-21-16c-3-3-8-3-12 0l-21 16-20-16a10 10 0 00-1-1h-1a9 9 0 00-1-1h-1-1-1-1a9 9 0 00-2 0 10 10 0 00-5 3v1a11 11 0 00-1 0v2h-1v4a9 9 0 000 2l39 144a10 10 0 1019-5l-31-115 3 2c2 2 4 2 6 2l7-2 20-16 21 16c3 3 8 3 12 0l3-2-31 115a10 10 0 0020 5l38-144a11 11 0 000-2z" ] []
        ]


svgBulb : Html.Html msg
svgBulb =
    Svg.svg [ SA.viewBox "0 0 512 512", SA.width "100%", SA.height "100%" ]
        [ Svg.path [ SA.d "M256 60a15 15 0 000 30c50 0 90 40 90 90a15 15 0 0030 0c0-66-54-120-120-120z" ] []
        , Svg.path [ SA.d "M217 4a179 179 0 00-96 295c19 22 30 49 30 77v30c0 20 13 37 31 43 6 35 36 63 74 63s68-28 74-63c18-6 31-23 31-43v-30c0-28 11-55 30-78A180 180 0 00217 4zm39 478c-19 0-36-13-42-31h84c-6 18-23 31-42 31zm75-76c0 8-7 15-15 15H196c-8 0-15-7-15-15v-15h150v15zm38-127c-21 24-34 52-37 82H180c-3-30-16-59-36-82a150 150 0 11225 0zM45 180H15a15 15 0 000 30h30a15 15 0 000-30z" ] []
        , Svg.path [ SA.d "M51 105L30 84a15 15 0 10-21 21l21 21a15 15 0 1021-21zM51 264c-6-6-15-6-21 0L9 285a15 15 0 1021 21l21-21c6-6 6-15 0-21zM497 180h-30a15 15 0 000 30h30a15 15 0 000-30zM503 84c-6-6-15-6-21 0l-21 21a15 15 0 1021 21l21-21c6-6 6-15 0-21zM503 285l-21-21a15 15 0 10-21 21l21 21a15 15 0 0021-21z" ] []
        ]
