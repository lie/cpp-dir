# コンパイラ、オプション等の設定。必要に応じて変更する
CC      := g++
CFLAGS  := -g -MMD -MP -std=c++14
LDFLAGS :=
LIBS    :=

SHELL := bash
RM    := rm

# ターゲット等の変数の宣言
MFDIR    := $(dir $(realpath $(firstword $(MAKEFILE_LIST))))
BINDIR   := $(MFDIR)/bin
TARGET   := $(BINDIR)/$(shell basename $(MFDIR))
INCDIR   := $(MFDIR)/include
INCLUDE  := $(addprefix -I, $(INCDIR))
SRCDIR   := $(MFDIR)/src
SRCREL   := $(shell cd $(SRCDIR) && find . -name "*.cpp")
SOURCES  := $(addprefix $(SRCDIR)/, $(SRCREL))
OBJDIR   := $(MFDIR)/obj
OBJECTS  := $(addprefix $(OBJDIR)/, $(SRCREL:.cpp=.o))
DEPENDS  := $(OBJECTS:.o=.d)
DOCSDIR  := $(MFDIR)/docs
DOXYFILE := $(DOCSDIR)/Doxyfile
PROJNAME := $(shell basename $(TARGET))

# 単に `make` を実行すると、先頭のこれが実行される
$(TARGET): $(OBJDIR) $(OBJECTS) $(LIBS)
	mkdir -p $(BINDIR)
	$(CC) -o $@ $(OBJECTS) $(LIBS) $(LDFLAGS)

$(OBJDIR)/%.o: $(SRCDIR)/%.cpp
	$(CC) $(CFLAGS) $(INCLUDE) -o $@ -c $<

# obj のディレクトリ構成を src と同じにする。.d ファイルの生成に必要
$(OBJDIR): $(SRCDIR)
	@echo rules for OBJDIR
	mkdir -p $(OBJDIR)
	cd $(SRCDIR) && find . -type d | xargs -I{} mkdir -p $(OBJDIR)/{}

build: $(TARGET)

run: $(TARGET)
	$(TARGET)

# `make all` で、強制的に全ソースを再コンパイルする
all: clean $(TARGET)

# `make clean` で、全ての中間ファイル・実行ファイルを削除する
clean:
	rm -f $(OBJECTS) $(DEPENDS) $(TARGET)
	find $(OBJDIR) -mindepth 1 -maxdepth 1 -type d | xargs -I{} rm -r {}
	touch -t $(shell date -d '1 second' '+%Y%m%d%H%M.%S') $(SRCDIR)

# `make docs` で、Doxygen によりドキュメントを生成する
docs:
	@mkdir -p $(DOCSDIR)
ifeq ($(shell if [ -a $(DOXYFILE) ]; then echo "exists"; fi), ) # Doxyfile が無ければ、新たに生成する
	@echo "PROJECT_NAME = "$(PROJNAME) > $(DOXYFILE)
	@echo "OUTPUT_DIRECTORY = ./" >> $(DOXYFILE)
	@echo "GENERATE_HTML = YES" >> $(DOXYFILE)
	@echo "HTML_OUTPUT = ./" >> $(DOXYFILE)
	@echo "GENERATE_LATEX = NO" >> $(DOXYFILE)
	@echo "INPUT = ../"$(shell basename $(INCDIR))"/ ../"$(shell basename $(SRCDIR))"/" >> $(DOXYFILE)
	@echo "RECURSIVE = YES" >> $(DOXYFILE)
endif
	cd $(DOCSDIR) && doxygen $(DOXYFILE)

# docs/ 内のファイルを全て削除する。ほとんど使わないかも
cleandocs:
	rm -r $(DOCSDIR)/*

test:
	@echo $(MFDIR)
	@echo $(lastword $(MAKEFILE_LIST))
	@echo $(SOURCES)
	@echo $(OBJECTS)
	if [ -a $(DOXYFILE) ]; then echo "AAA" else 

-include $(DEPENDS)

.PHONY: biuld run all clean objsubdir docs cleandocs test
