# Multi-Environment Version ( macOS and Cygwin )

CC      = g++
CFLAGS  = -g -MMD -MP -std=c++14
LDFLAGS =
LIBS    =
MKDIR   = mkdir
RM      = rm

# Detect environment
ifeq "$(shell uname | awk '$$0 = substr($$0, 1, 6)')" "Darwin"
	ENV = mac
else ifeq "$(shell uname | awk '$$0 = substr($$0, 1, 6)')" "CYGWIN"
	ENV = cygwin
else
	ENV = other
endif

BINDIR  = ./bin
TARGET  = $(BINDIR)/$(ENV)
INCLUDE = -I./include
SRCDIR  = ./src
SOURCES = $(wildcard $(SRCDIR)/*.cpp)
OBJDIR  = ./obj/$(ENV)
OBJECTS = $(addprefix $(OBJDIR)/, $(notdir $(SOURCES:.cpp=.o)))
DEPENDS = $(OBJECTS:.o=.d)

$(TARGET): $(OBJECTS) $(LIBS)
	$(CC) -o $@ $^ $(LDFLAGS)

$(OBJDIR)/%.o: $(SRCDIR)/%.cpp
	$(MKDIR) -p $(OBJDIR)
	$(CC) $(CFLAGS) $(INCLUDE) -o $@ -c $<

all: clean $(TARGET)

clean:
	$(RM) -f $(OBJECTS) $(DEPENDS) $(TARGET)

-include $(DEPENDS)

.PHONY: all clean