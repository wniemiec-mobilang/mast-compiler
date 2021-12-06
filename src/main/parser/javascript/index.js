//-----------------------------------------------------------------------------
//    IMPORTS
//-----------------------------------------------------------------------------
const fs = require('fs');
const acorn = require('acorn');


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
    let isNextLineScript = false;
    let index = 0;

    while (index < lines.length) {
        if (isNextLineScript) {
            let javascriptAst = parseJavascript(lines[index]);
            lines[index] = lines[index].replaceAll(/\[.+\]/g, '[label="' + javascriptAst + '"]');
        }

        isNextLineScript = lines[index].includes('<behavior>');
        index++;
    }
}

function parseJavascript(javascriptLine) {
    let code = javascriptLine.split('label=')[1];
    code = code.substring(1, code.length - 3);

    return javascriptToAst(code);
}

function javascriptToAst(code) {
    const ast = acorn.parse(code);

    return JSON.stringify(ast);
}
