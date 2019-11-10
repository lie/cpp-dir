# コンパイラ、オプション等の設定。必要に応じて変更する
CC      := g++
CFLAGS  := -g -MMD -MP -std=c++14 -Wall -Wextra
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

# 実行ファイルを生成する。単に `make` を実行すると、先頭のこれが実行される
$(TARGET): $(OBJDIR) $(OBJECTS) $(LIBS)
	@mkdir -p $(BINDIR)
	@$(CC) -o $@ $(OBJECTS) $(LIBS) $(LDFLAGS)

$(OBJDIR)/%.o: $(SRCDIR)/%.cpp
	@$(CC) $(CFLAGS) $(INCLUDE) -o $@ -c $<

# obj のディレクトリ構成を src と同じにする。.d ファイルの生成に必要
$(OBJDIR): $(SRCDIR)
	@mkdir -p $(OBJDIR)
	@cd $(SRCDIR) && find . -type d | xargs -I{} mkdir -p $(OBJDIR)/{}

# 実効ファイルを生成する
build: $(TARGET)

# 実効ファイルを生成して、それを実行する
run: $(TARGET)
	@$(TARGET)

# 強制的に全ソースを再コンパイルする
all: clean $(TARGET)

# 全てのオブジェクトファイル、依存関係ファイルと実行ファイルを削除する
clean:
	@rm -f $(OBJECTS) $(DEPENDS) $(TARGET)
	@find $(OBJDIR) -mindepth 1 -maxdepth 1 -type d | xargs -I{} rm -r {}
	@touch -t $(shell date -d '1 second' '+%Y%m%d%H%M.%S') $(SRCDIR)

# Doxygen によりドキュメントを生成する
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
	@cd $(DOCSDIR) && doxygen $(DOXYFILE)

# docs/ 内に生成された Doxygen ドキュメントを削除する。.gitkeep と Doxyfile は残す。あまり使わないかも
cleandocs:
	@ls $(DOCSDIR) | grep -v -E "Doxyfile|\.gitkeep" | xargs -I{} rm -rf $(DOCSDIR)/{}

-include $(DEPENDS)

.PHONY: biuld run all clean docs cleandocs
