const fs = require("fs");
const child_process = require("child_process");

process.chdir(`exercises`);

const command = `../node_modules/.bin/elm make src/Worker.elm --output=./elm.js --optimize`;
child_process.exec(command, (error, out) => {
    if (error) throw error;
    const Elm = require('./elm.js');
    var app = Elm.Elm.Worker.init();

    app.ports.dataFromElmToJavascript.subscribe(function(data) {
        // Got the file back from Elm!
        // fs.writeFile(dir.ignoredByGit + "/dev" + "/data.json", JSON.stringify(data,null,4), function(){});
        // callback(data);
        const parsedData = JSON.parse(data);
        // console.log(parsedData);
        removeDir(`../ellie/docs/js`, false);
        mkdir(`../ellie/docs/js`);

        parsedData.map(
            (file) => {
                console.log(`Wrtiting ../ellie/docs/js/${file.fileName}`);
                fs.writeFileSync(`../ellie/docs/js/${file.fileName}`, file.content);
            }
        )
    });
});

function mkdir (path) {
    if (fs.existsSync(path)) {
        // path already exsists
    } else {
        try {
            fs.mkdirSync(path, { recursive: true })
        } catch(e) {
            // error creating dir
        }
    }
}

function removeDir (srcDir, removeSelf) {
    if (!fs.existsSync(srcDir)) {
        // source directory doesn't exists
        return;
    }
    const files = fs.readdirSync(srcDir);
    files.map(function (file) {
            const src = `${srcDir}/${file}`;
            const stat = fs.lstatSync(src);
            if (stat && stat.isDirectory()) {
                // Calling recursively removeDir
                removeDir(src, true);
            } else {
                fs.unlinkSync(src);
            }
        }
    )
    if (removeSelf) {
        fs.rmdirSync(srcDir);
    }
};
