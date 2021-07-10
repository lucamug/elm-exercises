exerciseData = {"solutions":["Recursive search for the last element.\n```\nlast : List a -> Maybe a\nlast list =\n    case list of\n        [] ->\n            Nothing\n\n        [ a ] ->\n            Just a\n\n        x :: xs ->\n            last xs\n```","Reverse and take the head.\n```\nlast : List a -> Maybe a\nlast list =\n    List.reverse list |> List.head\n```","[Point-free style](https://en.wikipedia.org/wiki/Tacit_programming), reverse and take the head.\n```\nlast : List a -> Maybe a\nlast =\n    List.reverse >> List.head\n```","Use `List.foldl`.\n```\nlast : List a -> Maybe a\nlast list =\n    case list of\n        [] ->\n            Nothing\n\n        x :: xs ->\n            Just (List.foldl (\\y _ -> y) x xs)\n```"],"dummySolutions":"last : List a -> Maybe a\nlast xs =\n    -- Your implementation goes here\n    Nothing","hints":["Use recursion.","How can you leverage a List's `head` function to solve this problem?"],"tests":["last [ 1, 2, 3, 4 ] |> equal (Just 4)","last [ 1 ] |> equal (Just 1)","last [] |> equal Nothing","last [ 'a', 'b', 'c' ] |> equal (Just 'c')"],"problem":"Write a function `last` that returns the last element of a list. An empty list doesn't have a last element, therefore `last` must return a `Maybe`.","reference":"https://johncrane.gitbooks.io/ninety-nine-elm-problems/content/p/p01.html","ellieId":"dFhBMLPrtWsa1","categories":["Lists","Recursion"],"difficulty":"Easy","title":"Returns the last element of a list","id":1}