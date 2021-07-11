exerciseData = {"solutions":["Recursive search for the last element\n```\npenultimate : List a -> Maybe a\npenultimate list =\n    case list of\n        [] ->\n            Nothing\n\n        [ y ] ->\n            Nothing\n\n        [ y, z ] ->\n            Just y\n\n        y :: ys ->\n            penultimate ys\n```","Reverse the list and take the head of the tail.\n```\npenultimate : List a -> Maybe a\npenultimate list =\n    case List.reverse list of\n        [] ->\n            Nothing\n\n        y :: ys ->\n            List.head ys\n```","Reverse the list, drop one and take the head.\n```\npenultimate : List a -> Maybe a\npenultimate list =\n    case List.drop 1 (List.reverse list) of\n        [] ->\n            Nothing\n\n        y :: ys ->\n            Just y\n```"],"dummySolutions":"penultimate : List a -> Maybe a\npenultimate list =\n    -- Your implementation goes here\n    Nothing","hints":["Use recursion.","What can you do to a list to make [List.head](https://package.elm-lang.org/packages/elm/core/latest/List#head) solve this problem?"],"tests":["penultimate [ 1, 2, 3, 4 ] |> equal (Just 3)","penultimate [ 1, 2 ] |> equal (Just 1)","penultimate [ 1 ] |> equal Nothing","penultimate [] |> equal Nothing","penultimate [ \"a\", \"b\", \"c\" ] |> equal (Just \"b\")","penultimate [ \"a\" ] |> equal Nothing"],"problem":"Implement the function `penultimate` to find the next to last element of a list.","reference":"https://johncrane.gitbooks.io/ninety-nine-elm-problems/content/p/p02.html","ellieId":"dFdvdf7wKmQa1","categories":["Lists","Recursion"],"difficulty":"easy","title":"Find the next to last element of a list","id":2}