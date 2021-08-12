# elm-exercises

=====

NOTE: This package is a working in progress.

=====

A system to create Elm exercises leveraging the [Ellie](https://ellie-app.com/new) platform.

It can be used in several way:

1. One-off - You can crate a stand alone exercise that is not connected to any series. See this Ellie for an example.
2. To create exercises in the "elm-exercises" series.
3. To create a new series of exercises

It supports three possible implementations:

1. [`exercise`](latest/Exercises#exercise) - This is the simpler version, it only requires a list of tests. Most exercises can be built with this.
2. [`exerciseWithView`](latest/Exercises#exerciseWithView) - This is an intermediate version where you can also create a `view` to be used as `Result` of the exercise.
3. [`exerciseWithTea`](latest/Exercises#exerciseWithTea) - Useful in the rear case that you need a complete Elm Architecture for your exercise.

## How to improve an existing exercise

## How to submit a new Exercise

To submit a new exercise, you need to

* Modify this Ellie until you are happy about the new exercise.
* Copy and paste the data into `exercises/src/E` folder. See to the other files in that folder to see examples.
* Create an Ellie with your exercise, using this Ellie as example.
  * Change the dummy function at the top to reflect a function that can be used as solution of the exercise. Be sure that the type signature is correct and that it compiles. Use dummy values as returned values. For example if the function return `List a`, you can return `[]`. If the function return `Maybe a` you can return `Nothing`, etc.
  * Load the right exercise from the HTML section in Ellie:

        `<script src="/js/001.js"></script>`
        
        Where the number is the number of the exercise you created
  * Add you excercise in this list: `exercises/src/ListExercises.elm`
  
  
```
node exercises/worker.js
```


