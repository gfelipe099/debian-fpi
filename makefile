TARGET=debian-fpi
CC=gcc
DEBUG=-g
OPT=-O0
WARN=-Wall
PTHREAD=-pthread
CCFLAGS=$(DEBUG) $(OPT) $(WARN) $(PTHREAD) -pipe
GTKLIB=`pkg-config --cflags glib-2.0 gio-2.0 --libs gtk+-3.0`
LD=gcc
LDFLAGS=$(PTHREAD) $(GTKLIB) -export-dynamic
MAINOBJ=src/main.o
GUIOBJ=src/gui.o

all: ${MAINOBJ} ${GUIOBJ}
	glib-compile-resources --target=src/gui.c --generate-source gui/gresources.xml
	${CC} -o ${TARGET} ${MAINOBJ} ${GUIOBJ} ${PTHREAD} ${GTKLIB}

src/main.o: src/main.c
	${CC} -c ${CCFLAGS} src/main.c ${GTKLIB} -o src/main.o

src/gui.o: src/gui.c
	${CC} -c ${GTKLIB} src/gui.c -o src/gui.o

clean:
	rm -rf src/*.o src/gui.c ${TARGET}
