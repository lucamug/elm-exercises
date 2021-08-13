var lsName = "elm-exercises";
var notDefined = "undefined";
var ls = localStorage.getItem(lsName);
var app = Elm[Object.keys(Elm)[0]].init({
    node: document.getElementById("elm"),
    flags: {
        index: JSON.stringify(typeof index === notDefined ? null : index),
        exerciseData: JSON.stringify(typeof exerciseData === notDefined ? null : exerciseData),
        localStorage: ls === null ? "[]" : ls,
        width: window.innerWidth,
    }
});
if (app && app.ports && app.ports.portLocalStoragePush) {
    app.ports.portLocalStoragePush.subscribe(function(state) {
        localStorage.setItem(lsName, state);
    });
}
if (app && app.ports && app.ports.portLocalStoragePop) {
    window.onstorage = function(event) {
        if (event.key === lsName) {
            app.ports.portLocalStoragePop.send(event.newValue);
        }
    };
}