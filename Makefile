SRC_DIR := ./src
BUILD_DIR := ./build
DEBUG_DIR := ./example
EXAMPLE_BASE_FLAGS = $(shell ctags -x --c-kinds=f $(SRC_DIR)/cobdom.c | awk '{printf "-K %s ", $$1}' | sed 's/ $$//') 
LIB_INSTALL_DIR = /usr/share/emsdk/upstream/emscripten/cache/sysroot/lib/wasm32-emscripten

all: $(BUILD_DIR)/lib/libcobdom.a

install: all
	cp $(BUILD_DIR)/lib/libcobdom.a $(LIB_INSTALL_DIR)/libcobdom.a

remove:
	rm $(LIB_INSTALL_DIR)/libcobdom.a

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(BUILD_DIR)/lib: $(BUILD_DIR)
	mkdir -p $(BUILD_DIR)/lib

$(BUILD_DIR)/lib/libcobdom.a: $(BUILD_DIR)/cobdom.o $(BUILD_DIR)/lib
	emar rcs $@ $<

$(BUILD_DIR)/cobdom.o: $(SRC_DIR)/cobdom.c | $(BUILD_DIR)
	emcc -c $< -o $@

$(BUILD_DIR)/example: $(BUILD_DIR)
	mkdir -p $(BUILD_DIR)/example

$(BUILD_DIR)/example/example.c: all | $(BUILD_DIR)/example 
	cobc -C -o $@ ./example/example.cob $(EXAMPLE_BASE_FLAGS) -K LAYOUT -K FETCHCALLBACK -K TAB1 -K TAB2 -K TAB3

$(BUILD_DIR)/example/example.js: $(BUILD_DIR)/example/example.c
	emcc -o $@ $< $(BUILD_DIR)/lib/libcobdom.a -lgmp -lcob -s EXPORTED_FUNCTIONS=_cob_init,_EXAMPLE,_LAYOUT,_FETCHCALLBACK,_TAB1,_TAB2,_TAB3 -s EXPORTED_RUNTIME_METHODS=ccall,cwrap,_malloc,HEAP8

example: $(BUILD_DIR)/example/example.js 
	cp $(DEBUG_DIR)/index.html $(BUILD_DIR)/example/index.html

clean:
	rm -rf $(BUILD_DIR)

.PHONY: all clean install remove
