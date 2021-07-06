var app = Elm[Object.keys(Elm)[0]].init({
    node: document.getElementById("elm"),
    flags: {
        index: JSON.stringify(typeof index === 'undefined' ? null : index),
        exerciseData: JSON.stringify(typeof exerciseData === 'undefined' ? null : exerciseData)
    }
});
hljs.highlightAll();

