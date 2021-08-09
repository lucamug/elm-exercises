port module Main exposing
    ( createOutputs
    , main
    )

import Browser
import Codec
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Element.Region as Region
import Exercises
import Html
import Html.Attributes
import ListExercises
import R10.Form
import R10.FormTypes
import Set


type Page
    = Top
    | Index
    | PageOutput
    | ViewJson Exercises.ExerciseData
    | ViewEllie Exercises.ExerciseData
    | ViewExercise Exercises.ExerciseData (Exercises.Model ())


type alias Model =
    { page : Page
    , form : R10.Form.Form
    }


initForm : R10.Form.Form
initForm =
    { conf =
        -- { id : Int
        -- , title : String
        -- , difficulty : Difficulty
        -- , categories : List String
        -- , ellieId : String
        -- , reference : String
        -- , problem : String
        -- , example : String
        -- , tests : List String
        -- , hints : List String
        -- , dummySolution : String
        -- , solutions : List String
        [ R10.Form.entity.field
            { id = "id"
            , idDom = Nothing
            , type_ = R10.FormTypes.TypeText R10.FormTypes.TextPlain
            , label = "ID"
            , helperText = Just "A number to identify the exercise. Number from 1 to 99 are reserved for [blah](https://example.com)"
            , requiredLabel = Just "(Required)"
            , validationSpecs =
                Just
                    { showPassedValidationMessages = False
                    , hidePassedValidationStyle = True
                    , validation = [ R10.Form.validation.required ]
                    , validationIcon = R10.FormTypes.NoIcon
                    }
            }
        , R10.Form.entity.field
            { id = "title"
            , idDom = Nothing
            , type_ = R10.FormTypes.TypeText R10.FormTypes.TextPlain
            , label = "Title"
            , helperText = Just "The title of the exercise"
            , requiredLabel = Just "(Required)"
            , validationSpecs =
                Just
                    { showPassedValidationMessages = False
                    , hidePassedValidationStyle = True
                    , validation = [ R10.Form.validation.required ]
                    , validationIcon = R10.FormTypes.NoIcon
                    }
            }
        , R10.Form.entity.field
            { id = "problem"
            , idDom = Nothing
            , type_ = R10.FormTypes.TypeText R10.FormTypes.TextMultiline
            , label = "Problem"
            , helperText = Nothing
            , requiredLabel = Just "(Required)"
            , validationSpecs = Nothing
            }
        ]
    , state = R10.Form.initState
    }


init : a -> ( Model, Cmd msg )
init model =
    ( { page = Top
      , form = initForm
      }
    , Cmd.none
    )


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , subscriptions = \_ -> Sub.none
        , update = update
        , view = view
        }


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        MsgForm msgForm ->
            let
                form : R10.Form.Form
                form =
                    model.form

                newForm : R10.Form.Form
                newForm =
                    { form
                        | state =
                            form.state
                                |> R10.Form.update msgForm
                                |> Tuple.first
                    }
            in
            ( { model | form = newForm }, Cmd.none )

        ChangePage page ->
            ( { model | page = page }, Cmd.none )

        ExercisesMsg exerciseMsg ->
            case model.page of
                ViewExercise exerciseData exerciseModel ->
                    let
                        ( newModel, cmd ) =
                            Exercises.update (onlyTests (List.length exerciseData.tests)) exerciseMsg exerciseModel
                    in
                    ( { model | page = ViewExercise exerciseData newModel }, Cmd.none )

                _ ->
                    ( model, Cmd.none )


type Msg
    = ChangePage Page
    | ExercisesMsg (Exercises.Msg ())
    | MsgForm R10.Form.Msg


view : Model -> Html.Html Msg
view model =
    layoutWith
        { options = [ focusStyle { borderColor = Nothing, backgroundColor = Nothing, shadow = Nothing } ] }
        [ Font.size 16 ]
    <|
        column [ padding 20, width fill, spacing 20 ]
            [ paragraph [ Region.heading 1, Font.size 35 ] [ text "Elm Exercises Dashboard" ]
            , row [ spacing 10 ] <|
                ([]
                    ++ [ Input.button [ Border.width 1, padding 5 ]
                            { onPress = Just <| ChangePage <| Top
                            , label = text <| "Top"
                            }
                       ]
                    ++ [ Input.button [ Border.width 1, padding 5 ]
                            { onPress = Just <| ChangePage <| PageOutput
                            , label = text <| "Output"
                            }
                       ]
                    ++ [ Input.button [ Border.width 1, padding 5 ]
                            { onPress = Just <| ChangePage <| Index
                            , label = text <| "Index"
                            }
                       ]
                    ++ List.map
                        (\exerciseData ->
                            Input.button [ Border.width 1, padding 5 ]
                                { onPress = Just <| ChangePage <| ViewJson exerciseData
                                , label = text <| String.fromInt exerciseData.id
                                }
                        )
                        ListExercises.exercises
                    ++ List.map
                        (\exerciseData ->
                            Input.button [ Border.width 1, padding 5 ]
                                { onPress =
                                    Just <|
                                        ChangePage <|
                                            ViewExercise exerciseData
                                                (Tuple.first <|
                                                    Exercises.init (onlyTests (List.length exerciseData.tests))
                                                        { index = createIndex 0 ListExercises.exercises
                                                        , exerciseData = Codec.encodeToString 0 Exercises.codecExerciseData exerciseData
                                                        , localStorage = ""
                                                        }
                                                )
                                , label = text <| String.fromInt exerciseData.id
                                }
                        )
                        ListExercises.exercises
                    ++ List.map
                        (\exerciseData ->
                            Input.button [ Border.width 1, padding 5 ]
                                { onPress = Just <| ChangePage <| ViewEllie exerciseData
                                , label = text <| String.fromInt exerciseData.id
                                }
                        )
                        ListExercises.exercises
                )
            , case model.page of
                Top ->
                    column [ spacing 20 ]
                        [ text "Welcome to Elm Exercises."
                        , column [ spacing 10 ] <| List.map (\exercise -> text exercise.title) ListExercises.exercises
                        ]

                PageOutput ->
                    column [ width fill, spacing 10 ]
                        [ paragraph [] [ text "Updated list of all exercises. Copy this JSON data into \"docs/index.json\"." ]
                        , textarea [ width fill ] <| createOutputs 4 ListExercises.exercises
                        ]

                Index ->
                    column [ width fill, spacing 10 ]
                        [ paragraph [] [ text "Updated list of all exercises. Copy this JSON data into \"docs/index.json\"." ]
                        , textarea [ width fill ] <| createIndexJsonp 0 ListExercises.exercises
                        ]

                ViewJson exerciseData ->
                    column [ width fill, spacing 10 ]
                        [ paragraph [] [ text <| "Copy this JSON data into \"docs/" ++ String.padLeft 3 '0' (String.fromInt exerciseData.id) ++ ".json\"." ]
                        , textarea [ width fill ] <| createExerciseJsonp 0 exerciseData
                        ]

                ViewEllie exerciseData ->
                    column [ width fill, spacing 10 ]
                        [ paragraph [] [ text <| "Copy these into an Ellie (https://ellie-app.com/new), then copy the Ellie id back in ..." ]
                        , viewEllie exerciseData
                        ]

                ViewExercise exerciseData exerciseModel ->
                    row [ spacing 20, width fill ]
                        [ column [ width fill, alignTop, spacing 20, width <| fillPortion 2 ]
                            [ column [ width fill, spacing 20 ] <|
                                R10.Form.view model.form MsgForm

                            --
                            --
                            --
                            --
                            -- [ column [spacing 10] [ text "id", paragraph [] [text exerciseModel.exerciseData.id ]]
                            , column [ spacing 10 ] [ text "Title", paragraph [] [ text exerciseModel.exerciseData.title ] ]

                            -- , column [spacing 10] [ text "difficulty", paragraph [] [text exerciseModel.exerciseData.difficulty ]]
                            -- , column [spacing 10] [ text "categories", paragraph [] [text exerciseModel.exerciseData.categories ]]
                            , column [ spacing 10 ] [ text "Ellie ID", paragraph [] [ text exerciseModel.exerciseData.ellieId ] ]
                            , column [ spacing 10 ] [ text "Reference", paragraph [] [ text exerciseModel.exerciseData.reference ] ]
                            , column [ spacing 10 ] [ text "Problem", paragraph [] [ text exerciseModel.exerciseData.problem ] ]
                            , column [ spacing 10 ] [ text "Example", paragraph [] [ text exerciseModel.exerciseData.example ] ]

                            -- , column [spacing 10] [ text "tests", paragraph [] [text exerciseModel.exerciseData.tests ]]
                            -- , column [spacing 10] [ text "hints", paragraph [] [text exerciseModel.exerciseData.hints ]]
                            , column [ spacing 10 ] [ text "Dummy Solution", paragraph [] [ text exerciseModel.exerciseData.dummySolution ] ]

                            -- , column [spacing 10] [ text "solutions", paragraph [] [text exerciseModel.exerciseData.solutions ]]
                            --
                            -- { id : Int
                            -- , title : String
                            -- , difficulty : Difficulty
                            -- , categories : List String
                            -- , ellieId : String
                            -- , reference : String
                            -- , problem : String
                            -- , example : String
                            -- , tests : List String
                            -- , hints : List String
                            -- , dummySolution : String
                            -- , solutions : List String
                            -- text <| Debug.toString <| exerciseModel.exerciseData ]
                            ]
                        , map ExercisesMsg <|
                            el
                                ([ Border.width 1
                                 , Border.color <| rgba 0 0 0 0.2
                                 , width <| fillPortion 3
                                 , Border.shadow { offset = ( 0, 0 ), size = 0, blur = 10, color = rgba 0 0 0 0.2 }
                                 , clip
                                 ]
                                    ++ Exercises.viewElementAttrs exerciseModel
                                )
                            <|
                                Exercises.viewElement (onlyTests (List.length exerciseData.tests)) exerciseModel
                        ]
            ]


onlyTests : Int -> Exercises.TEA () ()
onlyTests qty =
    -- TODO - Add some test here
    --
    { init = ( (), Cmd.none )
    , maybeView = Nothing
    , update = \_ _ -> ( (), Cmd.none )
    , subscriptions = \_ -> Sub.none
    , tests = \_ -> []
    , portLocalStoragePop = portLocalStoragePop
    , portLocalStoragePush = portLocalStoragePush
    }


port portLocalStoragePop : (String -> msg) -> Sub msg


port portLocalStoragePush : String -> Cmd msg


textarea : List (Attribute msg) -> String -> Element msg
textarea attrs string =
    el attrs <|
        html <|
            Html.textarea
                [ Html.Attributes.style "height" "600px"
                , Html.Attributes.style "padding" "10px"
                ]
                [ Html.text <| string
                ]


viewEllie : a -> Element msg
viewEllie _ =
    textarea [ width fill ] htmlForEllie


htmlForEllie : String
htmlForEllie =
    """<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width">
    <link rel="shortcut icon" href="/favicon.ico">

    <!-- Primary Meta Tags -->
    <title>Elm Excercises</title>
    <meta name="title" content="Elm Excercises">
    <meta name="description" content="Elm Excercises">

    <!-- <link rel="stylesheet" href="highlight/styles/default.min.css"> -->
    <link rel="stylesheet" href="https://package.elm-lang.org/assets/highlight/styles/default.css">

    <!-- Fonts -->

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Source+Code+Pro&family=Source+Sans+Pro:wght@400;700&display=swap" rel="stylesheet">

    <!-- <link rel="preconnect" href="https://fonts.gstatic.com">
    <link href="https://fonts.googleapis.com/css2?family=Big+Shoulders+Display:wght@300&family=IBM+Plex+Sans:wght@300;700&display=swap" rel="stylesheet"> -->
</head>

<body>
    <div id="elm"></div>
    <script src="/elm.js"></sc""" ++ """ript>
    <script>
        var app = Elm.Main.init({
            node: document.getElementById("elm"),
        });
    </sc""" ++ """ript>
    <script src="highlight.min.js"></sc""" ++ """ript>
    <script>
        hljs.highlightAll();
    </sc""" ++ """ript>
</body>

</html>"""


createExerciseJsonp : Int -> Exercises.ExerciseData -> String
createExerciseJsonp ind exerciseData =
    "exerciseData = " ++ Codec.encodeToString ind Exercises.codecExerciseData exerciseData


createOutputs : Int -> List Exercises.ExerciseData -> String
createOutputs ind listExerciseData =
    Codec.encodeToString ind
        (Codec.list codecOutput)
        ({ fileName = "index.js"
         , content = createIndexJsonp ind listExerciseData
         }
            :: List.map
                (\exerciseData ->
                    { fileName = String.padLeft 3 '0' (String.fromInt exerciseData.id) ++ ".js"
                    , content = createExerciseJsonp ind exerciseData
                    }
                )
                listExerciseData
        )


codecOutput : Codec.Codec Output
codecOutput =
    Codec.object Output
        |> Codec.field "fileName" .fileName Codec.string
        |> Codec.field "content" .content Codec.string
        |> Codec.buildObject


type alias Output =
    { fileName : String
    , content : String
    }


createIndexJsonp : Int -> List Exercises.ExerciseData -> String
createIndexJsonp ind listExerciseData =
    "index = " ++ createIndex ind listExerciseData


createIndex : Int -> List Exercises.ExerciseData -> String
createIndex ind listExerciseData =
    Codec.encodeToString ind
        (Codec.list Exercises.codecIndex)
        (List.map
            (\exerciseData ->
                { id = exerciseData.id
                , title = exerciseData.title
                , difficulty = exerciseData.difficulty
                , categories = exerciseData.categories
                , ellieId = exerciseData.ellieId
                }
            )
            listExerciseData
        )
