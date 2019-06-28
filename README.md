# cpp-dir
Generic Makefile and directory structure for C++

## Directory Structure

```
○example/
┣○bin/
┃┗●example   -- Executable file
┣○src/        -- cpp source files
┃┣●main.cpp
┃┗●hoge.cpp
┣○include/    -- hpp header files
┃┣●alllib.hpp
┃┗●hoge.hpp
┣○obj/        -- .o object files and .d files
┃┣●main.d
┃┣●main.o
┃┣●hoge.d
┃┗●hoge.o
┣○script/
┃┗●class.sh -- for class coding
┗●Makefile
```

## Reference

[シンプルで応用の効くmakefileとその解説 - URIN HACK](http://urin.github.io/posts/2013/simple-makefile-for-clang)
