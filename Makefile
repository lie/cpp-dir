# コンパイラ、オプション等の設定。必要に応じて変更する
CC      = g++
CFLAGS  = -g -MMD -MP -std=c++14
LDFLAGS =
LIBS    =
MKDIR   = mkdir
RM      = rm

# ターゲット等の変数の宣言
MFDIR   = $(shell basename `readlink -f .`)
BINDIR  = ./bin
TARGET  = $(BINDIR)/$(MFDIR)
INCLUDE = -I./include
SRCDIR  = ./src
SOURCES = $(wildcard $(SRCDIR)/*.cpp)
OBJDIR  = ./obj
OBJECTS = $(addprefix $(OBJDIR)/, $(notdir $(SOURCES:.cpp=.o)))
DEPENDS = $(OBJECTS:.o=.d)

# 単に `make` を実行すると、先頭のこれが実行される
$(TARGET): $(OBJECTS) $(LIBS)
	$(CC) -o $@ $^ $(LDFLAGS)

$(OBJDIR)/%.o: $(SRCDIR)/%.cpp
	$(MKDIR) -p $(OBJDIR)
	$(CC) $(CFLAGS) $(INCLUDE) -o $@ -c $<

# `make all` で、強制的に全ソースを再コンパイルする
all: clean $(TARGET)

# `make clean` で、全ての中間ファイル・実行ファイルを削除する
clean:
	$(RM) -f $(OBJECTS) $(DEPENDS) $(TARGET)

-include $(DEPENDS)

.PHONY: all clean