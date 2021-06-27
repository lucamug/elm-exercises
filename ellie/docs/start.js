var app = Elm[Object.keys(Elm)[0]].init({
    node: document.getElementById("elm"),
    flags: {
        index: JSON.stringify(index),
        exerciseData: JSON.stringify(exerciseData)
    }
});
hljs.highlightAll();

