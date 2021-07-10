exerciseData = {"solutions":[],"dummySolutions":"queens : Int -> List (List Int)\nqueens n = \n    -- Your implementation goes here\n    []","hints":[],"tests":["List.length (queens 8) |> equal 92","List.length (queens 7) |> equal 40","List.length (queens 6) |> equal 4","List.length (queens 5) |> equal 10","List.length (queens 4) |> equal 2","List.length (queens 3) |> equal 0","List.length (queens 2) |> equal 0","List.length (queens 1) |> equal 1","List.length (queens 0) |> equal 1"],"problem":"The [Eight queens puzzle](https://en.wikipedia.org/wiki/Eight_queens_puzzle) is a classical puzzle in computer science. The objective is to place eight queens on a chessboard so that no two queens are attacking each other; that is no two queens are in the same row, the same column, or on the same diagonal. For example:\n\n![8 Queens Puzzle](/images/8-queens-puzzle.png)        \n        \nRepresent the positions of the queens as a list of numbers 1..N. Example: [4,2,7,3,6,8,5,1] means that the queen in the first column is in row 4, the queen in the second column is in row 2, etc.\n","reference":"https://johncrane.gitbooks.io/ninety-nine-elm-problems/content/p/p90.html","ellieId":"dFdF4NRQPVSa1","categories":["Puzzles","Recursion"],"difficulty":"Hard","title":"The \"Eight queens puzzle\"","id":90}