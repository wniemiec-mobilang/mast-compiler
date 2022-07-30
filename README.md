![](https://github.com/williamniemiec/mast-compiler/blob/master/docs/img/logo/logo.jpg?raw=true)

<h1 align='center'>MAST compiler</h1>
<p align='center'>MobiLang compiler.</p>
<p align="center">
	<a href="https://github.com/williamniemiec/mast-compiler/actions/workflows/ubuntu.yml"><img src="https://github.com/williamniemiec/mast-compiler/actions/workflows/ubuntu.yml/badge.svg" alt=""></a>
	<a href="http://node.dev"><img src="https://img.shields.io/badge/NodeJS-8+-D0008F.svg" alt="Node compatibility"></a>
	<a href="http://java.oracle.com"><img src="https://img.shields.io/badge/java-11+-D0008F.svg" alt="Java compatibility"></a>
	<a href="https://github.com/williamniemiec/mast-compiler/releases"><img src="https://img.shields.io/github/v/release/williamniemiec/mast-compiler" alt="Release"></a>
	<a href="https://github.com/williamniemiec/mast-compiler/blob/master/LICENSE"><img src="https://img.shields.io/badge/License-MIT-919191.svg" alt="License"></a>
	
<hr>

## ❇ Introduction
MobiLang is an extended markup language created for representing any mobile application. This compiler converts it to an Abstract Syntax Tree (AST), which can be used by [ASC compiler](https://github.com/williamniemiec/asc-compiler/) for generate a mobile application using a framework.

![](https://github.com/williamniemiec/mast-compiler/blob/master/docs/img/mobilang/mobilang-tree.jpg?raw=true)

## ❓ How to use

```
Coming soon
```

### Example

```
Coming soon
```

## ✔ Requirements
- [NodeJS](https://nodejs.dev)
- [Flex](https://www.geeksforgeeks.org/flex-fast-lexical-analyzer-generator/)
- [Bison](https://www.gnu.org/software/bison/)
- [C Compiler](https://gcc.gnu.org)
- [Java](http://java.oracle.com/)

## ⚠ Warnings
- Behavior tag
  - Every statement must end with `;`
  - Inline comments (comments starting with `//`) are not allowed
  - There must be some screen with `id` equals to `home`
   
## 🚩 Changelog
Details about each version are documented in the [releases section](https://github.com/williamniemiec/mast-compiler/releases).

## 🗺 Project structure
![architecture](https://raw.githubusercontent.com/williamniemiec/mast-compiler/master/docs/img/schemas/architecture.png?raw=true)

## References

### Libraries used in this project
- [CSS Parser](https://github.com/reworkcss/css)
- [HTML Parser](https://github.com/mykolaharmash/hyntax)
- [Javascript Parser](https://github.com/acornjs/acorn)
