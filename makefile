
LIBFTDI_CFLAGS := $(shell pkg-config --cflags libftdi1)
LIBFTDI_LIBS := $(shell pkg-config --libs libftdi1)

CFLAGS := -Wall
CFLAGS += $(LIBFTDI_CFLAGS)
LIB := $(LIBFTDI_LIBS)

INC_DEBUG := $(INC)
CFLAGS_DEBUG := $(CFLAGS) -pg -g
LIBDIR_DEBUG := $(LIBDIR)
LIB_DEBUG := $(LIB)
LDFLAGS_DEBUG := $(LDFLAGS) -pg
OBJDIR_DEBUG := obj/Debug
OUT_DEBUG := bin/Debug/sainsmartrelay

INC_RELEASE := $(INC)
CFLAGS_RELEASE := $(CFLAGS) -O2 -w
LIBDIR_RELEASE := $(LIBDIR)
LIB_RELEASE := $(LIB)
LDFLAGS_RELEASE := $(LDFLAGS) -s
OBJDIR_RELEASE := obj/Release
OUT_RELEASE := bin/Release/sainsmartrelay

OBJ_DEBUG = $(OBJDIR_DEBUG)/sainsmartrelay.o

OBJ_RELEASE = $(OBJDIR_RELEASE)/sainsmartrelay.o

# Install the library
PREFIX := /usr/local
INSTALL_NAME := sainsmartrelay

all: debug release

clean: clean_debug clean_release

before_debug: 
	test -d bin/Debug || mkdir -p bin/Debug
	test -d $(OBJDIR_DEBUG) || mkdir -p $(OBJDIR_DEBUG)

after_debug: 

debug: before_debug out_debug after_debug

out_debug: before_debug $(OBJ_DEBUG) $(DEP_DEBUG)
	$(LD) $(LIBDIR_DEBUG) -o $(OUT_DEBUG) $(OBJ_DEBUG)  $(LDFLAGS_DEBUG) $(LIB_DEBUG)

$(OBJDIR_DEBUG)/sainsmartrelay.o: sainsmartrelay.c
	$(CC) $(CFLAGS_DEBUG) $(INC_DEBUG) -c sainsmartrelay.c -o $(OBJDIR_DEBUG)/sainsmartrelay.o

clean_debug: 
	rm -f $(OBJ_DEBUG) $(OUT_DEBUG)
	rm -rf bin/Debug
	rm -rf $(OBJDIR_DEBUG)

before_release: 
	test -d bin/Release || mkdir -p bin/Release
	test -d $(OBJDIR_RELEASE) || mkdir -p $(OBJDIR_RELEASE)

after_release: 

release: before_release out_release after_release

out_release: before_release $(OBJ_RELEASE) $(DEP_RELEASE)
	$(LD) $(LIBDIR_RELEASE) -o $(OUT_RELEASE) $(OBJ_RELEASE)  $(LDFLAGS_RELEASE) $(LIB_RELEASE)

$(OBJDIR_RELEASE)/sainsmartrelay.o: sainsmartrelay.c
	$(CC) $(CFLAGS_RELEASE) $(INC_RELEASE) -c sainsmartrelay.c -o $(OBJDIR_RELEASE)/sainsmartrelay.o

clean_release: 
	rm -f $(OBJ_RELEASE) $(OUT_RELEASE)
	rm -rf bin/Release
	rm -rf $(OBJDIR_RELEASE)

.PHONY: before_debug after_debug clean_debug before_release after_release clean_release

install: $(BIN)
	@echo "[Install binary]"
	@install -m 0755 -d	$(PREFIX)/bin
	@install -m 0755 $(OUT_RELEASE)	$(PREFIX)/bin/$(INSTALL_NAME)
.PHONY:	install

