# CONTRIBUTING

Thank you for thinking about contributing to this project.

There are few ways that you can help.

## Submit a new Exercise

To submit a new exercise, you need to

* Modify this Ellie until you are happy about the new exercise.
* Copy and paste the data into `exercises/src/E` folder. See the other files in that folder to see examples.
* Create an Ellie with your exercise, using this Ellie as example.
  * Change the dummy function at the top to reflect a function that can be used as solution of the exercise. Be sure that the type signature is correct and that it compiles. Use dummy values as returned values. For example if the function return `List a`, you can return `[]`. If the function return `Maybe a` you can return `Nothing`, etc.
  * Load the right exercise from the HTML section in Ellie:

        `<script src="/js/001.js"></script>`
        
        Where the number is the number of the exercise you created
  * Add you excercise in this list: `exercises/src/ListExercises.elm`
        
        

## To test all exercises
```
cd exercises
elm reactor
```

## To generate all JavaScript files
```
node exercises/worker.js
```