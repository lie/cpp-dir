# cpp-dir
Generic Makefile and directory structure for C++

## Directory Structure

```
📁 example/
┃
┣━📁 bin/
┃  ┗━📄 example     -- Executable file
┃
┣━📁 src/           -- .cpp source files
┃  ┣━📄 main.cpp
┃  ┣━📄 bar.cpp
┃  ┗━📁 dirsample/
┃     ┗━📄 foo.cpp
┃
┣━📁 include/       -- .hpp header files
┃  ┣━📄 alllib.hpp
┃  ┗━📄 foobar.hpp
┃
┣━📁 obj/           -- .o object files and .d dependency files
┃  ┣━📄 main.o
┃  ┣━📄 main.d
┃  ┣━📄 bar.o
┃  ┣━📄 bar.d
┃  ┗━📁 dirsample/
┃     ┣━📄 foo.o
┃     ┗━📄 foo.d
┃
┣━📁 docs/          -- Doxygen HTML documents
┃ 
┗━📄 Makefile
```

## Reference

[シンプルで応用の効くmakefileとその解説 - URIN HACK](http://urin.github.io/posts/2013/simple-makefile-for-clang)
