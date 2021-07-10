var app = Elm[Object.keys(Elm)[0]].init({
    node: document.getElementById("elm"),
    flags: {
        index: JSON.stringify(typeof index === 'undefined' ? null : index),
        exerciseData: JSON.stringify(typeof exerciseData === 'undefined' ? null : exerciseData),
        localStorage: String(localStorage.getItem("elm-exercises")),
    }
});
app.ports.pushLocalStorage.subscribe(function(state) {
    localStorage.setItem("elm-exercises", state);
});
window.onstorage = function(event) {
    app.ports.onLocalStorageChange.send(event.newValue);
};

hljs.highlightAll();

