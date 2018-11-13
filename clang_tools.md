
## Agenda

- **Clang**
- **Clang-Format**
  - What it is?
  - Why?
  - How it works
  - Samples.
- **Clang-Tidy**
  - What it is?
  - Why?
  - How it works
  - Samples.

::: notes

Clang - clang-format clang-tidy and what why how and some samples.

:::


# Clang

##

- Part of LLVM compiler project.
- C family compiler (C/C++/Objective-C).
- Expressive diagnostics.
- Modular library based architecture.

## Clang possibilities

- Compiler
- IDE Integrations (Autocompletion)
- Static Code Analysis.
- Refactor tools.


<style type="text/css">

.reveal p {
    margin: 0;
  }
.reveal pre code {
    max-height: 1000px;
    max-width: 1000px;
    }
.reveal section img {
    margin: 1px 0px;
  }  
</style>

## Compiler

Compiler design
![](./images/compiler_design.svg)

Clang

![](./images/clang_compiler.svg)

## Abstract Syntax Tree

::: {.columns}
::: {.column width="40%"}
```
    while b ≠ 0
        if a > b
            a := a − b
        else
            b := b − a
    return a
```
:::
::: {.column width="60%"}
![](./images/ast.svg)
:::
:::

# Clang-Format

## What

- Automatically reformatting C/C++ sources.
- Library and a stand-alone tool.
  - Good IDE integrations.
  - Used to create other tools.
- Based on styles.

::: notes
stand-alone tool and a library
provides the means to extend it or integrate it into bugger tools like IDE
:::

## Why

- Unified coding style.
- Automatize tedious tasks:
  - Not typing spaces.

::: notes

Helps readability
Helps to understand.
Consistency.

:::

## {transition="none"}

Rename function.

```C++
int testFunction(int a,
                 int b,
                 int c)
```

## {transition="none"}

Rename function.

```C++
int testFunctionNewName(int a,
                 int b,
                 int c)
```

## {transition="none"}

Rename function.

```C++
int testFunctionNewName(int a,
                        int b,
                 int c)
```

## {transition="none"}

Rename function.

```C++
int testFunctionNewName(int a,
                        int b,
                        int c)
```

::: notes

Simple but what if API?

:::

## {transition="none"}

API code

```C++
int testFunction(int a,
                 int b,
                 int c)

void otherFunction();

void foo(const std::string& text,
         size_t size);

size_t foo2(const std::string& text,
            const std::vector<int>& a;
            size_t size
            bool b);
```

## {transition="none"}

API code

```C++
int mylib_testFunction(int a,
                       int b,
                       int c)

void mylib_otherFunction();

void mylib_foo(const std::string& text,
               size_t size);

size_t mylib_foo2(const std::string& text,
                  const std::vector<int>& a;
                  size_t size
                  bool b);
```

## How

- Clang's Lexer.
- Generates a token stream.
- Change white spaces around tokens.

::: notes
Clang-format uses Clang’s Lexer to transform an input file into a token stream and then changes all the whitespace around those tokens.
:::

## Configuration

- Using CLI.
- YAML format.
- Based on predefined styles (LLVM, Google, Chromium, Mozilla, WebKit).
- Or create your own custom style.

##

Sample configuration

```YAML
---
# We'll use defaults from the LLVM style, but with 4 columns indentation.
BasedOnStyle: LLVM
IndentWidth: 4
---
Language: Cpp
# Force pointers to the type for C++.
DerivePointerAlignment: false
PointerAlignment: Left
---
Language: JavaScript
# Use 100 columns for JS.
ColumnLimit: 100
---
Language: Proto
# Don't format .proto files.
DisableFormat: true
...
```

::: notes

Derived pointer and pointer location

:::
## 

PointerAlignment (PointerAlignmentStyle)

::: {.columns}
::: {.column width="33%"}
Left
```C++
int* a;
```
:::
::: {.column width="33%"}
Right
```C++
int *a;
```
:::
::: {.column width="33%"}
Middle
```C++
int * a;
```
:::
:::

## 

AllowShortCaseLabelsOnASingleLine (bool)

::: {.columns}
::: {.column width="50%"}
```C++
  switch (a) {
  case 1: x = 1; break;
  case 2: return;
  }
```
:::
::: {.column width="50%"}
```C++
switch (a) {
case 1:
  x = 1;
  break;
case 2:
  return;
}
```
:::
:::

## More

- Integration with VSCode, VIM, Visual Studio...
- Online tools and good documentation.
    - [clangformat](https://clangformat.com/)

# Clang-Tidy

## What

- Clang-base C++ "linter" tool.
- Framework for diagnosis and fix errors.
- Extensible with new checks.

::: notes
Not just a linter, it is better defined as a framework for checks.
:::

## Why

- Can detect common programming pitfall.
- Interface misuses.
- Force code conventions.

## How

- Clang's AST and preprocessor.
- Uses compile command files.
- Huge list of programmed checks.

::: notes
:::

##

Selectable checks

- boost
- cppcoreguidelines
- clang-analyzer
- hicpp
- modernize
- performance
- portability

## 

modernize

```C++
for (std::vector<std::string>::iterator it = names.begin(); it != names.end(); ++it)
{
    std::cout << *it;
}
```

```zsh
warning: use range-based for loop instead [modernize-loop-convert]
for (std::vector<std::string>::iterator it = names.begin(); it != names.end(); ++it)
     ^   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        (auto & name : names)
```

## 

bugprone findings

```C
#define BUFLEN 42
    char buf[BUFLEN];
    memset(buf, 0, sizeof(BUFLEN));
```

```zsh
warning: suspicious usage of 'sizeof(K)'; did you mean 'K'? [bugprone-sizeof-expression]
    memset(buf, 0, sizeof(BUFLEN));
```

## 

bugprone findings

```C
std::string str = "Hello, world!\n";
std::vector<std::string> messages;
messages.emplace_back(std::move(str));
std::cout << str;
```

```zsh
warning: 'str' used after it was moved [bugprone-use-after-move]
    std::cout << str;
```

## 

cppcoreguidelines

```C
struct B { int a; virtual int f(); };
struct D : B { int b; int f() override; };

void use(B b) {
  b.f();
}

D d;
use(d);
```

. . .

```zsh
warning: slicing object from type 'D' to 'B' discards 4 bytes of state [cppcoreguidelines-slicing]
    test::use(d);
              ^
warning: slicing object from type 'D' to 'B' discards override 'f' [cppcoreguidelines-slicing]
```

## More

- Python helper launcher script.
- Integrated in the latest version of CMake.
- Extensible rules.