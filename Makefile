#-----------------------
# Tools isolation.
#-----------------------
AR   = ar
CC   = g++
ECHO = echo
RM   = rm
SDL2_CONFIG = sdl2-config

#-----------------------
# Compile options.
#-----------------------
WFLAGS  = -Wall 
WFLAGS += -Wuninitialized 
WFLAGS += -Wshadow 
WFLAGS += -Wno-non-virtual-dtor 
WFLAGS += -Wno-delete-non-virtual-dtor 
WFLAGS += -Wno-multichar

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
#LDFLAGS_OPTS = $(sdl2_macos_LDFLAGS)

#-----------------------
# Link options.
#-----------------------
LIBS = -lSDL2_ttf -liconv
sdl2_LDFLAGS = $(shell $(SDL2_CONFIG) --libs)
LDFLAGS := $(sdl2_LDFLAGS) $(LIBS) $(LDFLAGS_OPTS)

#-----------------------
# Build recipes.
#-----------------------
.SUFFIXES=
.PHONY: all hello make-waves bouncy-tune archive

all: testsw hello make-waves bouncy-tune

%: %.o sdl-widgets.a 
	$(CC) $< sdl-widgets.a -o $@ $(LDFLAGS)

%.o: %.cpp
	$(CC) -c $< $(CFLAGS)

archive: sdl-widgets.a

ar_FLAGS = -rs
sdl-widgets.a: sdl-widgets.o shapes.o mingw32-specific.o
	$(AR) $(ar_FLAGS) $@ sdl-widgets.o shapes.o mingw32-specific.o

hello make-waves bouncy-tune:
	$(MAKE) -C $@ CFLAGS="$(CFLAGS)" LDFLAGS="$(LDFLAGS)" SDL2_CONFIG="$(SDL2_CONFIG)"

sdl-widgets.o: sdl-widgets.h sw-pixmaps.h config.h shapes.h

testsw.o: sdl-widgets.h shapes.h

.PHONY: debugmake
debugmake:
	@$(ECHO) macos_FW      = $(macos_FW)
	@$(ECHO) macos_LDFLAGS = $(macos_LDFLAGS)
	@$(ECHO) LDFLAGS_OPTS  = $(LDFLAGS_OPTS)
	@$(ECHO) SDL2_CONFIG   = $(SDL2_CONFIG)
	@$(ECHO) sdl2_CFLAGS   = $(sdl2_CFLAGS)
	@$(ECHO) opt_FLAGS     = $(opt_FLAGS)
	@$(ECHO) CFLAGS        = $(CFLAGS)
	@$(ECHO) LIBS          = $(LIBS)
	@$(ECHO) LDFLAGS       = $(LDFLAGS)

rm_FLAGS = -rf
clean:
	$(RM) $(rm_FLAGS) testsw sdl-widgets.a */*.o make-waves/make-waves bouncy-tune/bouncy-tune
	$(MAKE) -C hello clean SDL2_CONFIG="$(SDL2_CONFIG)"
