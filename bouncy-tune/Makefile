CC = g++
CFLAGS := -g $$(sdl2-config --cflags) -I.. -std=c++11 -O \
  -Wuninitialized -Wshadow -Wall -Wno-non-virtual-dtor -Wno-delete-non-virtual-dtor -Wno-multichar
LDFLAGS := $$(sdl2-config --libs) -lSDL2_ttf

.SUFFIXES=

OBJ = bouncy-tune.o ../make-waves/dump-wave.o ../sdl-widgets.a
bouncy-tune: $(OBJ)
	make -C .. archive
	$(CC) $(OBJ) -o $@ $(LDFLAGS)

%.o: %.cpp
	$(CC) -c $< $(CFLAGS)

bouncy-tune.o: ../sdl-widgets.h ../make-waves/dump-wave.h templates.h
../make-waves/dump-wave.o: ../make-waves/dump-wave.h
