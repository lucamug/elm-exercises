# TODO

* Make the "Result" title disappear if there is no Result
* Add by categories list
* Reverse the order in "Exercises by Category"
* Add "Ignore the code below"

# NOTE

```
  #1                  https://ellie-app.com/dZnNLKLm2GSa1
  #2 -                https://ellie-app.com/dZnRhJBf27Qa1
 #90 - Elm Exercise - https://ellie-app.com/dZfrCXKY89Fa1
 #23 - Elm Exercise - https://ellie-app.com/dZgZqMHCKvWa1
#100                  https://ellie-app.com/dZk36Lv5h4ca1
```

@Simon Lydell, thank you for the feedback! Let me address some of your points:

> I think it would look nicer if the footer is at the bottom

I never know how to do it. I hoped that nobody has a screen large enough to notice it. I have to figure this out

> Every time I go to the next exercise Ellie says “It looks like Ellie may have crashed before you had a chance to save your work. Do you want to recover what you were working on?“. Do you know why?

Ellie issue https://github.com/ellie-app/ellie/issues/150

> When you click “Next exercise” it is opened in a new tab. If you go back to the previous tab, the “Next exercise” link in the header is now hard to read in Firefox (blue on blue). Some :visited styling, maybe?

Yep, need some extra CSS

> Given that exercise #1 provided a point-free solution, I was surprised that there was no point-free solution provided in #2 (instead it re-implements List.head).

Good point

> The “Eight queens puzzle” did not contain enough information for me to understand what to return in my function.

Right, need to add an Example as in the other exercises

EDIT: I noted that the visualization was not showing the queens. Fixed now: https://ellie-app.com/dZLQZGDGgNsa1

> The “Fútbol announcer goal functions” puzzle was too easy for me when the g, o and f functions were already defined.

I see, interesting. I need to get the empty exercise to compile so I am not sure how to solve this unless I make the tests be an empty list and having the real tests to be commented out. So to solve the exercise, a user would need to first uncomment the tests, then add the three functions. (edited) 