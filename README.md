![logo](https://raw.githubusercontent.com/wniemiec-mobilex/mast-compiler/main/docs/images/logo/logo.png)

<h1 align='center'>MAST compiler</h1>
<p align='center'>Mobilang to AST Compiler</p>
<p align="center">
	<a href="https://github.com/wniemiec-mobilex/mast-compiler/actions/workflows/ubuntu.yml"><img src="https://github.com/wniemiec-mobilex/mast-compiler/actions/workflows/ubuntu.yml/badge.svg" alt=""></a>
	<a href="http://node.dev"><img src="https://img.shields.io/badge/NodeJS-8+-D0008F.svg" alt="Node compatibility"></a>
	<a href="http://java.oracle.com"><img src="https://img.shields.io/badge/java-11+-D0008F.svg" alt="Java compatibility"></a>
	<a href="https://github.com/wniemiec-mobilex/mast-compiler/releases"><img src="https://img.shields.io/github/v/release/wniemiec-mobilex/mast-compiler" alt="Release"></a>
	<a href="https://github.com/wniemiec-mobilex/mast-compiler/blob/master/LICENSE"><img src="https://img.shields.io/github/license/wniemiec-mobilex/mast-compiler" alt="License"></a>
	
<hr>

## ❇ Introduction
Mobilang is an extended markup language created for representing any mobile application. This compiler converts it to an Abstract Syntax Tree (AST), which can be used by [AMA compiler](https://github.com/wniemiec-mobilex/ama-compiler/) for generate mobile applications.

![](https://github.com/wniemiec-mobilex/mast-compiler/blob/master/docs/images/mobilang/mobilang-tree.jpg?raw=true)

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
Details about each version are documented in the [releases section](https://github.com/wniemiec-mobilex/mast-compiler/releases).

## 🗺 Project structure
![architecture](https://raw.githubusercontent.com/wniemiec-mobilex/mast-compiler/master/docs/images/design/architecture.jpg)

## References

### Libraries used in this project
- [StringUtils](https://github.com/wniemiec-util-cpp/string-utils)
- [CSS Parser](https://github.com/reworkcss/css)
- [HTML Parser](https://github.com/mykolaharmash/hyntax)
- [Javascript Parser](https://github.com/acornjs/acorn)
