PROGRAM = hello
OBJ     = $(PROGRAM).o

#-----------------------
# Tools isolation.
#-----------------------
CC   = g++
ECHO = echo
RM   = rm
SDL2_CONFIG = sdl2-config

#-----------------------
# Compile options.
#-----------------------
opt_DEBUG   = -g
opt_RELEASE = -O2
opt_FLAGS   = $(opt_DEBUG)
std_FLAGS   = -std=c++11

sdl2_CFLAGS = $(shell $(SDL2_CONFIG) --cflags)
CFLAGS := $(opt_FLAGS) $(sdl2_CFLAGS) $(std_FLAGS) $(WFLAGS)

space :=
space +=
comma =,

#-----------------------
# Platform link options.
#-----------------------
sdl2_macos_FW  = CoreAudio AudioToolbox CoreFoundation CoreGraphics CoreVideo ForceFeedback IOKit Carbon AppKit
sdl2_macos_LDFLAGS = -Wl,-framework,$(subst $(space),$(comma)-framework$(comma),$(sdl2_macos_FW))
#LDFLAGS_OPTS = $(sdl2_macos_LDFLAGS) -liconv

#-----------------------
# Link options.
#-----------------------
LIBS = -lSDL2_ttf
sdl2_LDFLAGS = $(shell $(SDL2_CONFIG) --libs)
LDFLAGS := $(sdl2_LDFLAGS) $(LIBS) $(LDFLAGS_OPTS)

#-----------------------
# Build recipes.
#-----------------------
.SUFFIXES=

$(PROGRAM): $(OBJ) ../sdl-widgets.a
	$(CC) $^ -o $@ $(LDFLAGS)

%.o: %.cpp
	$(CC) -c $< -I.. $(CFLAGS)

$(OBJ): ../sdl-widgets.h

.PHONY: debugmake
debugmake:
	@$(ECHO) PROGRAM      = $(PROGRAM)
	@$(ECHO) SDL2_CONFIG  = $(SDL2_CONFIG)
	@$(ECHO) sdl2_CFLAGS  = $(sdl2_CFLAGS)	
	@$(ECHO) opt_FLAGS    = $(opt_FLAGS)	
	@$(ECHO) CFLAGS       = $(CFLAGS)	
	@$(ECHO) LIBS         = $(LIBS)	
	@$(ECHO) LDFLAGS_OPTS = $(LDFLAGS_OPTS)
	@$(ECHO) LDFLAGS      = $(LDFLAGS)	

.PHONY: clean
rm_FLAGS = -f
clean:
	-$(RM) $(rm_FLAGS) $(PROGRAM) $(OBJ)
