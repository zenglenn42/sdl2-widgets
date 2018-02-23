#-----------------------
# Tools isolation.
#-----------------------
AR   = ar
CAT  = cat
CC   = g++
ECHO = echo
RM   = rm
SDL2_CONFIG = sdl2-config
SED  = sed

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

# Create a single header file that embodies sdl-widgets.h and shapes.h
# so we only have to #include one file in our client code:
#
# SDL_widgets.h

sdl2_widget_INCDIR = SDL2/
sed_text_SDL_h     := include <$(sdl2_widget_INCDIR)SDL.h>
sed_text_SDL_ttf_h := include <$(sdl2_widget_INCDIR)SDL_ttf.h>
sed_text_MODS_AT_RISK = /* THIS IS A GENERATED FILE. MODIFY AT YOUR OWN RISK. */
SDL_widgets.h: SDL_widgets.h.in
	$(CAT) $? shapes.h | $(SED) -e "s|^\#include.*||" >> $@.1 || $(RM) $@.1
	$(CAT) $@.1 sdl-widgets.h | $(SED) -e "s|^\#include.*||" >> $@.2 || $(RM) $@.2
	$(ECHO) "#endif" >> $@.2 || $(RM) $@.2
	$(SED)\
		-e "s|_sed_tag_mods_at_risk_|$(sed_text_MODS_AT_RISK)|g" \
		-e "s|_sed_tag_SDL_h_|#$(sed_text_SDL_h)|g" \
		-e "s|_sed_tag_SDL_ttf_h_|#$(sed_text_SDL_ttf_h)|g" \
		$@.2 > $@ || $(RM) $@
	$(RM) $@.1 $@.2

.PHONY: debugmake
debugmake:
	@$(ECHO) SDL2_CONFIG   = $(SDL2_CONFIG)
	@$(ECHO) sdl2_CFLAGS   = $(sdl2_CFLAGS)
	@$(ECHO) opt_FLAGS     = $(opt_FLAGS)
	@$(ECHO) CFLAGS        = $(CFLAGS)
	@$(ECHO) LIBS          = $(LIBS)
	@$(ECHO) LDFLAGS_OPTS  = $(LDFLAGS_OPTS)
	@$(ECHO) LDFLAGS       = $(LDFLAGS)

rm_FLAGS = -rf
clean:
	$(RM) $(rm_FLAGS) testsw sdl-widgets.a */*.o make-waves/make-waves bouncy-tune/bouncy-tune SDL_widgets.h
	$(MAKE) -C hello clean SDL2_CONFIG="$(SDL2_CONFIG)"
