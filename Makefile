#-----------------
# Tools isolation.
#-----------------
AR = ar
CC = g++
RM = rm
SDL2_CONFIG = sdl2-config

#-----------------
# Compile options.
#-----------------
WFLAGS  = -Wall 
WFLAGS += -Wuninitialized 
WFLAGS += -Wshadow 
WFLAGS += -Wno-non-virtual-dtor 
WFLAGS += -Wno-delete-non-virtual-dtor 
WFLAGS += -Wno-multichar

sdl2_CFLAGS = $(shell $(SDL2_CONFIG) --cflags)
CFLAGS := -g -O $(sdl2_CFLAGS) -std=c++11 $(WFLAGS)

#-----------------
# Link options.
#-----------------
LIBS = -lSDL2_ttf -liconv
sdl2_LDFLAGS = $(shell $(SDL2_CONFIG) --libs)
LDFLAGS := $(sdl2_LDFLAGS) $(LIBS) $(LDFLAGS_OPTS)

#LDFLAGS_OPTS = Wl,-framework,CoreAudio,-framework,AudioToolbox,-framework,CoreFoundation,-framework,CoreGraphics,-framework,CoreVideo,-framework,ForceFeedback,-framework,IOKit,-framework,Carbon,-framework,AppKit

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
	$(MAKE) -C $@ CFLAGS="$(CFLAGS)" LDFLAGS="$(LDFLAGS)"

sdl-widgets.o: sdl-widgets.h sw-pixmaps.h config.h shapes.h

testsw.o: sdl-widgets.h shapes.h

rm_FLAGS = -rf
clean:
	$(RM) $(rm_FLAGS) *.o sdl-widgets.a */*.o hello/hello make-waves/make-waves bouncy-tune/bouncy-tune
