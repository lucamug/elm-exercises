port module Worker exposing (main)

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
import Json.Encode
import ListExercises
import Main
import Platform
import Set


main : Platform.Program () () msg
main =
    Platform.worker
        { init = \_ -> ( (), dataFromElmToJavascript <| Main.createOutputs 0 ListExercises.exercises )
        , update = \_ m -> ( m, Cmd.none )
        , subscriptions = \_ -> Sub.none
        }


port dataFromElmToJavascript : String -> Cmd msg
