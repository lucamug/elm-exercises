var lsName = "elm-exercises";
var undefined = "undefined";
var ls = localStorage.getItem(lsName);
var app = Elm[Object.keys(Elm)[0]].init({
    node: document.getElementById("elm"),
    flags: {
        index: JSON.stringify(typeof index === undefined ? null : index),
        exerciseData: JSON.stringify(typeof exerciseData === undefined ? null : exerciseData),
        localStorage: ls === null ? "[]" : ls,
    }
});
if (app && app.ports && app.ports.portLocalStoragePush) {
    app.ports.portLocalStoragePush.subscribe(function(state) {
        localStorage.setItem(lsName, state);
    });
}
if (app && app.ports && app.ports.portLocalStoragePop) {
    window.onstorage = function(event) {
        app.ports.portLocalStoragePop.send(event.newValue);
    };
}

// hljs.highlightAll();
