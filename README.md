# cpp-dir
Generic Makefile and directory structure for C++

## Directory Structure

```
○example/
┣○src/        -- cpp source
┃┣●main.cpp
┃┗●hoge.cpp
┣○include/    -- hpp header
┃┣●alllib.hpp
┃┗●hoge.hpp
┣○obj/        -- .o object file, .d file
┃┣○cygwin
┃┃┣●main.d
┃┃┗●main.o
┃┃┣●hoge.d
┃┃┗●hoge.o
┃┣○mac
┃┃┣●main.d
┃┃┗●main.o
┃┃┣●hoge.d
┃┃┗●hoge.o
┃┗○other...
┣○script/
┃┗●class.sh -- for class coding
┣○bin/
┃┣●cygwin
┃┗●mac
┗●Makefile
```

## Reference

[シンプルで応用の効くmakefileとその解説 - URIN HACK](http://urin.github.io/posts/2013/simple-makefile-for-clang/)
