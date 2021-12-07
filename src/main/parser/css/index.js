//-----------------------------------------------------------------------------
//    IMPORTS
//-----------------------------------------------------------------------------
const fs = require('fs');
const css = require('css');


//-----------------------------------------------------------------------------
//    MAIN
//-----------------------------------------------------------------------------
main();

function main() {
    if (process.argv.length < 3) {
        console.log('Usage: node ' + process.argv[1] + ' FILENAME');
        process.exit(1);
    }

    parseFile(process.argv[2]);
}


//-----------------------------------------------------------------------------
//    FUNCTIONS
//-----------------------------------------------------------------------------
function parseFile(filename) {
    let lines = []

    fs.readFile(filename, 'utf8', function (err, data) {
        if (err) throw err;
        console.log('OK: ' + filename);
        lines = data.split(/\r?\n/);

        parseLines(lines);

        let writter = fs.createWriteStream(filename, {
            flags: 'w'
        })
        for (let line of lines) {
            writter.write(line);
            writter.write('\n');
        }
    });
}

function parseLines(lines) {
    let isNextLineStyle = false;
    let index = 0;

    while (index < lines.length) {
        if (isNextLineStyle) {
            let cssAst = parseCss(lines[index]);
            cssAst = cssAst.replaceAll("\"", "\\\"");

            lines[index] = lines[index].replaceAll(/\[.+\]/g, '[label="' + cssAst + '"]');
        }

        isNextLineStyle = lines[index].includes('<style>');
        index++;
    }
}

function parseCss(cssLine) {
    let code = cssLine.split('label=')[1];
    code = code.substring(1, code.length - 3);

    const ast = cssToAst(code);

    return ast;
}

function cssToAst(cssCode) {
    const ast = css.parse(cssCode, { silent: false });

    return JSON.stringify(ast);
}
