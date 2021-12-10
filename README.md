![](https://github.com/williamniemiec/mast-compiler/blob/master/docs/img/logo/logo.jpg?raw=true)

<h1 align='center'>MAST compiler</h1>
<p align='center'>Mobilang compiler.</p>
<p align="center">
	<a href="https://github.com/williamniemiec/mast-compiler/actions/workflows/ubuntu.yml"><img src="https://github.com/williamniemiec/mast-compiler/actions/workflows/ubuntu.yml/badge.svg" alt=""></a>
	<a href="https://github.com/williamniemiec/mast-compiler/blob/master/LICENSE"><img src="https://img.shields.io/badge/License-MIT-919191.svg" alt="License"></a>

## ❇ Introduction
Mobilang is an extended markup language created for representing any mobile application. This compiler converts it to an Abstract Syntax Tree (AST), which can be used by [ASC compiler](https://github.com/williamniemiec/asc-compiler/) for generate a mobile application using a framework.

## ❓ How to use

```
make
sudo make compilation filename=<mobilang_filepath_without_extension>
```

### Example

```
sudo make compilation filename=./src/resources/close2dinoapp
```

## Requirements
- [NodeJS](https://nodejs.dev)
- [Flex](https://www.geeksforgeeks.org/flex-fast-lexical-analyzer-generator/)
- [Bison](https://www.gnu.org/software/bison/)

## Libraries
- [CSS Parser](https://github.com/reworkcss/css)
- [HTML Parser](https://github.com/mykolaharmash/hyntax)
- [Javascript Parser](https://github.com/acornjs/acorn)

## Notes
- Behavior tag
  - Every statement must end with `;`
   