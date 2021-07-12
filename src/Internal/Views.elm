module Internal.Views exposing (..)

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
import Internal.Data
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


viewHeader :
    Internal.Data.Model modelExercise
    -> Element (Internal.Data.Msg msgExercise)
viewHeader model =
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
                    , onPress = Just <| Internal.Data.ChangeMenu Internal.Data.OtherExercises
                    }
               ]
        )


viewFooter : Element (Internal.Data.Msg msgExercise)
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
                { onPress = Just <| Internal.Data.ChangeMenu Internal.Data.OtherExercises
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
                { onPress = Just <| Internal.Data.ChangeMenu Internal.Data.Help
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
                { onPress = Just <| Internal.Data.ChangeMenu Internal.Data.Contribute
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
            ++ [ viewHeader model ]
            ++ [ viewBody tea model ]
         -- ++ [ viewFooter ]
        )


accordion :
    { hideItem : Int -> msg
    , items : Internal.Data.Show
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


isOpen : Internal.Data.Show -> Int -> Bool
isOpen show index =
    case show of
        Internal.Data.ShowAll ->
            True

        Internal.Data.ShowNone ->
            False

        Internal.Data.Show set ->
            Set.member index set


contentOtherExercises : Internal.Data.Model modelExercise -> ( String, List (Element msg) )
contentOtherExercises model =
    ( "Other Exercises"
    , []
        ++ [ viewTitle "Exercises by Category" ]
        ++ [ model.index
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
                                            , text <| Internal.Data.difficultyToString i.difficulty
                                            , text ")"
                                            ]
                                    }
                                ]
                            ]
                    )
                    model.index
           ]
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


viewBody :
    Internal.Data.TEA modelExercise msgExercise
    -> Internal.Data.Model modelExercise
    -> Element (Internal.Data.Msg msgExercise)
viewBody tea model =
    row [ spacing 40, paddingEach { top = 20, right = 60, bottom = 20, left = 40 } ]
        [ column [ spacing 40, width fill, alignTop ]
            ([]
                ++ [ viewMainTitle "Problem" ]
                ++ [ column [ spacing 16, width fill ] <|
                        Internal.Markdown.markdown model.exerciseData.problem
                            ++ [ paragraph [ alpha 0.5 ]
                                    [ text "Diffculty level: "
                                    , el [] <| text <| Internal.Data.difficultyToString model.exerciseData.difficulty
                                    ]
                               ]
                   ]
            )
        , column [ spacing 40, width fill, alignTop ]
            ([]
                ++ [ viewMainTitle "Tests" ]
                ++ [ viewTests model ]
                ++ (case tea.maybeView of
                        Just view_ ->
                            [ viewMainTitle "Result"
                            , el [ paddingLeft, width fill ] <| map Internal.Data.MsgTEA <| view_ model.modelExercise
                            ]

                        Nothing ->
                            []
                   )
                ++ [ wrappedRow [ spacing 10 ]
                        [ paragraph [ Region.heading 2, Font.size 20, Font.bold ] [ text "Hints" ]
                        , Input.button attrsButton { onPress = Just Internal.Data.ShowHintsAll, label = text "Show All" }
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
                ++ [ wrappedRow [ spacing 10 ]
                        [ paragraph [ Region.heading 2, Font.size 20, Font.bold ] [ text "Solutions" ]
                        , Input.button attrsButton { onPress = Just Internal.Data.ShowSolutionsAll, label = text "Show All" }
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
            )
        ]


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
            , onPress = Just <| Internal.Data.ChangeMenu Internal.Data.OtherExercises
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
                    [ svgBulb
                        |> html
                        |> el [ centerX, height <| px 24, width <| px 24 ]
                    , column [ width fill, spacing 4 ]
                        [ el [ Font.size 12 ] <| text "SOLUTIONS"
                        ]
                    ]
            , onPress = Just <| Internal.Data.ChangeMenu Internal.Data.OtherExercises
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
            , onPress = Just <| Internal.Data.ChangeMenu Internal.Data.OtherExercises
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
            , onPress = Just <| Internal.Data.ChangeMenu Internal.Data.OtherExercises
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
            , onPress = Just <| Internal.Data.ChangeMenu Internal.Data.Help
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
            , onPress = Just <| Internal.Data.ChangeMenu Internal.Data.Contribute
            }
        ]


view :
    Internal.Data.TEA modelExercise msgExercise
    -> Internal.Data.Model modelExercise
    -> Html.Html (Internal.Data.Msg msgExercise)
view tea model =
    layoutWith
        { options = [ focusStyle { borderColor = Nothing, backgroundColor = Nothing, shadow = Nothing } ] }
        ([]
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
        )
        (viewElement tea model)


viewSideMenu :
    Internal.Data.Model modelExercise
    -> Element (Internal.Data.Msg msgExercise)
viewSideMenu model =
    case model.localStorageRecord.menuContent of
        Internal.Data.OtherExercises ->
            viewContent model <| contentOtherExercises model

        Internal.Data.Help ->
            viewContent model <| contentHelp

        Internal.Data.Contribute ->
            viewContent model <| contentContribute


viewContent :
    Internal.Data.Model modelExercise
    -> ( String, List (Element msg) )
    -> Element msg
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
        , if model.localStorageRecord.menuOpen then
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


green : Color
green =
    rgb 0 0.6 0


red : Color
red =
    rgb 0.8 0 0



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



--
--
--


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
    -- Svg.svg [ SA.xmlns "http://www.w3.org/2000/svg", SA.viewBox "0 0 442 442" ]
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
