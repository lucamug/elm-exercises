exerciseData = {"solutions":["By [hayleigh](https://elm-exercises.netlify.app/100/withsolution):\n\n\n\n```\ng : (String -> a) -> a\ng f =\n    f \"g\"\n\n\no : String -> (String -> a) -> a\no s f =\n    f (s ++ \"o\")\n\n\nal : String -> String\nal s =\n    s ++ \"al\"\n```"],"dummySolutions":"queens : Int -> List (List Int)\nqueens n = \n    -- Your implementation goes here\n    []","hints":["Would these type signatures be of any help?\n```\ng : (String -> a) -> a\n\no : String -> (String -> a) -> a\n\nal : String -> String\n```","There was some discussion in the Elm Slack channel about this puzzle, maybe you can get some [inspiration from that](https://elm-exercises.netlify.app/100/)."],"tests":["g o o o o o o o al |> equal \"goooooooal\"","g o al |> equal \"goal\"","g al |> equal \"gal\""],"example":"g o o o o o o o al == \"goooooooal\"\ng o al             == \"goal\"\ng al               == \"gal\"","problem":"Write three functions, `g`, `o`, and `al`, that can be called like in the example below to produce an appropriately enthusiastic goal announcement.","reference":"https://github.com/carbonfive/functional-programming-weekly-challenge/tree/master/Week002","ellieId":"dZk36Lv5h4ca1","categories":["Puzzles"],"difficulty":"hard","title":"Fútbol announcer goal functions","id":100}