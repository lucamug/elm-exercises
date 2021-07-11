var ls = localStorage.getItem("elm-exercises");
var app = Elm[Object.keys(Elm)[0]].init({
    node: document.getElementById("elm"),
    flags: {
        index: JSON.stringify(typeof index === 'undefined' ? null : index),
        exerciseData: JSON.stringify(typeof exerciseData === 'undefined' ? null : exerciseData),
        localStorage: JSON.stringify(typeof ls === 'undefined' ? null : ls),
    }
});
app.ports.pushLocalStorage.subscribe(function(state) {
    localStorage.setItem("elm-exercises", state);
});
window.onstorage = function(event) {
    app.ports.onLocalStorageChange.send(event.newValue);
};

hljs.highlightAll();

