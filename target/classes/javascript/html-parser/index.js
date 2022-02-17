//-----------------------------------------------------------------------------
//    Imports
//-----------------------------------------------------------------------------
const fs = require('fs');
const { tokenize, constructTree } = require('hyntax');
const stringify = require('json-stringify-safe');


//-----------------------------------------------------------------------------
//    Main
//-----------------------------------------------------------------------------
if (process.argv.length < 3) {
    console.log('Usage: node ' + process.argv[1] + ' FILENAME');
    process.exit(1);
}

parseFile(process.argv[2]);


//-----------------------------------------------------------------------------
//    Functions
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
    let isNextLineStructure = false;
    let index = 0;

    while (index < lines.length) {
        if (isNextLineStructure) {
            let htmlAst = parseHtml(lines[index]);
            htmlAst = htmlAst.replaceAll("\"", "\\\"");

            lines[index] = lines[index].replaceAll(/\[.+\]/g, '[label="' + htmlAst + '"]');
        }

        isNextLineStructure = lines[index].includes('<structure>');
        index++;
    }
}

function parseHtml(htmlLine) {
    let code = htmlLine.split('label=')[1];
    code = code.substring(1, code.length - 3);

    return htmlToAst(code);
}

function htmlToAst(code) {
    const { tokens } = tokenize(code);
    const { ast } = constructTree(tokens);

    return stringify(ast);
}
