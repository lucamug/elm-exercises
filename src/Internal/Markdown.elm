module Internal.Markdown exposing (main, markdown)

import Browser
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Element.Region as Region
import Html
import Html.Attributes
import Markdown.Block
import Markdown.Html
import Markdown.Parser
import Markdown.Renderer


view : Model -> { title : String, body : List (Html.Html Msg) }
view model =
    { title = "dillonkearns/elm-markdown demo"
    , body =
        [ layout
            [ width fill
            , Font.family []
            ]
            (row [ width fill ]
                [ Input.multiline
                    [ width (px 400)
                    , alignTop
                    ]
                    { onChange = OnMarkdownInput
                    , text = model
                    , placeholder = Nothing
                    , label = Input.labelHidden "Markdown input"
                    , spellcheck = False
                    }
                , case markdownView model of
                    Ok rendered ->
                        column
                            [ spacing 30
                            , padding 80
                            , width (fill |> maximum 1000)
                            , centerX
                            , alignTop
                            ]
                            rendered

                    Err errors ->
                        text errors
                ]
            )
        ]
    }


markdown : String -> List (Element msg)
markdown string =
    case markdownView string of
        Ok res ->
            res

        Err err ->
            [ text <| "Error: " ++ err ]


markdownView : String -> Result String (List (Element msg))
markdownView string =
    string
        |> Markdown.Parser.parse
        |> Result.mapError (\error -> error |> List.map Markdown.Parser.deadEndToString |> String.join "\n")
        |> Result.andThen (Markdown.Renderer.render renderer)


renderer : Markdown.Renderer.Renderer (Element msg)
renderer =
    { elmUiRenderer
        | html =
            Markdown.Html.oneOf
                [ Markdown.Html.tag "bio"
                    (\name photoUrl twitter github dribbble renderedChildren ->
                        bioView renderedChildren name photoUrl twitter github dribbble
                    )
                    |> Markdown.Html.withAttribute "name"
                    |> Markdown.Html.withAttribute "photo"
                    |> Markdown.Html.withOptionalAttribute "twitter"
                    |> Markdown.Html.withOptionalAttribute "github"
                    |> Markdown.Html.withOptionalAttribute "dribbble"
                ]
    }


bioView :
    List (Element msg)
    -> String
    -> String
    -> Maybe String
    -> Maybe String
    -> Maybe String
    -> Element msg
bioView renderedChildren name photoUrl twitter github dribbble =
    column
        [ Border.shadow
            { offset = ( 0.3, 0.3 )
            , size = 2
            , blur = 0.5
            , color = rgba255 0 0 0 0.22
            }
        , padding 20
        , spacing 30
        , centerX
        , Font.center
        ]
        (row [ spacing 20 ]
            [ avatarView photoUrl
            , el
                [ Font.bold
                , Font.size 30
                ]
                (text name)
            , icons twitter github dribbble
            ]
            :: renderedChildren
        )


icons : Maybe String -> Maybe String -> Maybe String -> Element msg
icons twitter github dribbble =
    row []
        ([ twitter
            |> Maybe.map
                (\twitterHandle ->
                    link []
                        { url = "https://twitter.com/" ++ twitterHandle
                        , label =
                            image [] { src = "https://i.imgur.com/tXSoThF.png", description = "Twitter Logo" }
                        }
                )
         , github
            |> Maybe.map
                (\twitterHandle ->
                    link []
                        { url = "https://github.com/" ++ twitterHandle
                        , label =
                            image [] { src = "https://i.imgur.com/0o48UoR.png", description = "Github Logo" }
                        }
                )
         , dribbble
            |> Maybe.map
                (\dribbbleHandle ->
                    link []
                        { url = "https://dribbble.com/" ++ dribbbleHandle
                        , label =
                            image [] { src = "https://i.imgur.com/1AGmwO3.png", description = "Dribbble Logo" }
                        }
                )
         ]
            |> List.filterMap identity
        )


avatarView : String -> Element msg
avatarView avatarUrl =
    image [ width fill ]
        { src = avatarUrl, description = "Avatar image" }
        |> el
            [ width (px 80) ]


markdownBody : String
markdownBody =
    """# Custom HTML Renderers

You just render it like this

```
<bio
  name="Dillon Kearns"
  photo="https://avatars2.githubusercontent.com/u/1384166"
  twitter="dillontkearns"
  github="dillonkearns"
>
Dillon really likes building things with Elm! Here are some links

- [Articles](https://incrementalelm.com/articles)
</bio>
```

And you get a custom view like this!

<bio
  name="Dillon Kearns"
  photo="https://avatars2.githubusercontent.com/u/1384166"
  twitter="dillontkearns"
  github="dillonkearns"
>
Dillon really likes building things with Elm! Here are some links

- [Articles](https://incrementalelm.com/articles)
</bio>

Note that these attributes are all optional. Try removing them and see what happens!
Or you can add `dribbble="something"` and see that icon show up if it's provided.
"""


type Msg
    = OnMarkdownInput String


type alias Flags =
    ()


type alias Model =
    String


main : Platform.Program Flags Model Msg
main =
    Browser.document
        { init = \_ -> ( markdownBody, Cmd.none )
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }


update : Msg -> a -> ( String, Cmd msg )
update msg _ =
    case msg of
        OnMarkdownInput newMarkdown ->
            ( newMarkdown, Cmd.none )


elmUiRenderer : Markdown.Renderer.Renderer (Element msg)
elmUiRenderer =
    { heading = heading
    , paragraph =
        paragraph
            [ spacing 8 ]
    , thematicBreak = none
    , text = text
    , strong = \content -> row [ Font.bold ] content
    , emphasis = \content -> row [ Font.italic ] content
    , strikethrough = \content -> row [ Font.strike ] content
    , codeSpan = code
    , link =
        \{ title, destination } body ->
            newTabLink
                []
                { url = destination
                , label = paragraph [] body
                }
    , hardLineBreak = Html.br [] [] |> html
    , image =
        \image_ ->
            case image_.title of
                Just _ ->
                    image [] { src = image_.src, description = image_.alt }

                Nothing ->
                    image [] { src = image_.src, description = image_.alt }
    , blockQuote =
        \children ->
            column
                [ Border.widthEach { top = 0, right = 0, bottom = 0, left = 10 }
                , padding 10
                , Border.color (rgb255 145 145 145)
                , Background.color (rgb255 245 245 245)
                ]
                children
    , unorderedList =
        \items ->
            column [ spacing 5, paddingEach { top = 0, right = 0, bottom = 0, left = 20 } ]
                (items
                    |> List.map
                        (\(Markdown.Block.ListItem task children) ->
                            row
                                [ spacing 10 ]
                                ((el [ alignTop ] <|
                                    case task of
                                        Markdown.Block.IncompleteTask ->
                                            Input.defaultCheckbox False

                                        Markdown.Block.CompletedTask ->
                                            Input.defaultCheckbox True

                                        Markdown.Block.NoTask ->
                                            text "•"
                                 )
                                    :: [ paragraph [ alignTop ] children ]
                                )
                        )
                )
    , orderedList =
        \startingIndex items ->
            column [ spacing 15 ]
                (items
                    |> List.indexedMap
                        (\index itemBlocks ->
                            row [ spacing 5 ]
                                [ row [ alignTop ]
                                    (text (String.fromInt (index + startingIndex) ++ " ") :: itemBlocks)
                                ]
                        )
                )
    , codeBlock = codeBlock
    , html = Markdown.Html.oneOf []
    , table = column []
    , tableHeader = column []
    , tableBody = column []
    , tableRow = row []
    , tableHeaderCell =
        \_ children ->
            paragraph [] children
    , tableCell =
        \_ children ->
            paragraph [] children
    }


code : String -> Element msg
code snippet =
    el
        [ Background.color
            (rgba 0 0 0 0.05)
        , Border.rounded 2
        , Font.size 14

        -- , Border.width 1
        -- , Border.color <| rgba 0 0 0 0.15
        -- , Font.color <| rgb255 38 139 210
        , Font.color <| rgb255 181 137 0

        -- , htmlAttribute <| Html.Attributes.style "margin-left" "5px"
        -- , htmlAttribute <| Html.Attributes.style "margin-right" "5px"
        , paddingXY 5 2
        , Font.family
            [ Font.typeface "Source Code Pro"
            , Font.monospace
            ]
        ]
        (text snippet)


codeBlock : { body : String, language : Maybe String } -> Element msg
codeBlock details =
    -- el
    --     [ Background.color (rgba 0 0 0 0.03)
    --     , htmlAttribute (Html.Attributes.style "white-space" "pre")
    --     , padding 20
    --     , Font.family
    --         [ Font.external
    --             { url = "https://fonts.googleapis.com/css?family=Source+Code+Pro"
    --             , name = "Source Code Pro"
    --             }
    --         ]
    --     ]
    --     (text details.body)
    el [ scrollbars, width fill ] <|
        html <|
            Html.pre []
                [ Html.code [ Html.Attributes.class "language-elm" ]
                    [ Html.text details.body ]
                ]



-- text details.body


heading : { level : Markdown.Block.HeadingLevel, rawText : String, children : List (Element msg) } -> Element msg
heading { level, rawText, children } =
    paragraph
        [ Font.size
            (case level of
                Markdown.Block.H1 ->
                    26

                Markdown.Block.H2 ->
                    22

                Markdown.Block.H3 ->
                    18

                _ ->
                    16
            )
        , Font.bold
        , Region.heading (Markdown.Block.headingLevelToInt level)
        , htmlAttribute
            (Html.Attributes.attribute "name" (rawTextToId rawText))
        , htmlAttribute
            (Html.Attributes.id (rawTextToId rawText))
        ]
        children


rawTextToId : String -> String
rawTextToId rawText =
    rawText
        |> String.split " "
        |> String.join "-"
        |> String.toLower
