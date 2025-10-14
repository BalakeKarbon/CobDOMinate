SRC_DIR := ./src
BUILD_DIR := ./build
DEBUG_DIR := ./example
EXAMPLE_BASE_FLAGS = $(shell ctags -x $(SRC_DIR)/cobdom.c | awk '{printf "-K %s ", $$1}' | sed 's/ $$//') 
#EXAMPLE_BASE_FLAGS = $(shell ctags -x --c-kinds=f $(SRC_DIR)/cobdom.c | awk '{printf "-K %s ", $$1}' | sed 's/ $$//') 
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

#$(BUILD_DIR)/lib/libcobdom.a: $(BUILD_DIR)/cobdom.o $(BUILD_DIR)/cobdom-cob.o $(BUILD_DIR)/lib
$(BUILD_DIR)/lib/libcobdom.a: $(BUILD_DIR)/cobdom.o $(BUILD_DIR)/lib
	emar rcs $@ $<
	#emar rcs $@ $< $(BUILD_DIR)/cobdom-cob.o
	#emar rcs $@ $< $(BUILD_DIR)/bridge.o

$(BUILD_DIR)/cobdom.o: $(SRC_DIR)/cobdom.c | $(BUILD_DIR)
	emcc -c $< -o $@
	#emcc -c $< -o $@ -s EXPORTED_FUNCTIONS=_cob_call_cobol

#$(BUILD_DIR)/cobdom-cob.o: $(BUILD_DIR)/cobdom-cob.c | $(BUILD_DIR)
#	emcc -c $< -o $@

#$(BUILD_DIR)/bridge.o: $(SRC_DIR)/bridge.c
#	emcc -c $< -o $@

#$(BUILD_DIR)/cobdom-cob.c: $(SRC_DIR)/cobdom.cob | $(BUILD_DIR)
#	(cd $(SRC_DIR) && cobc -C -o $(abspath $@) $(notdir $<))
	#(cd $(SRC_DIR) && cobc -C -o $(abspath $@) $(notdir $<) -K emscripten_run_script_int -K return_string)
	#find $(BUILD_DIR) -type f -name '*.c' -exec sed -i '/module->module_cancel\.funcptr =/ s/^/\/\//' {} +
	#cobc -C $< -o $@

$(BUILD_DIR)/example: $(BUILD_DIR)
	mkdir -p $(BUILD_DIR)/example

$(BUILD_DIR)/example/example.c: all | $(BUILD_DIR)/example 
	cobc -C -o $@ ./example/example.cob $(EXAMPLE_BASE_FLAGS) -K LAYOUT -K FETCHCALLBACK -K TAB1 -K TAB2 -K TAB3
	#cobc -C -o $@ ./example/example.cob -K cobdom_get_cookie -K cobdom_create_element -K cobdom_inner_html -K cobdom_append_child -K cobdom_remove_child -K cobdom_add_event_listener -K cobdom_norm -K CHECK-COOKIE
#	cobc -C -o $@ ./example/host.cob -K COBDOM-VERSION -K COBDOM-CREATE-ELEMENT -K COBDOM-APPEND-CHILD -K COBDOM-REMOVE-CHILD -K COBDOM-INNER-HTML -K COBDOM-ADD-EVENT-LISTENER -K COBDOM-CLASS-NAME -K COBDOM-STYLE -K COBDOM-SET-COOKIE -K COBDOM-GET-COOKIE -K EXAMPLE -K TESTFUNC
	#find $(BUILD_DIR)/example -type f -name '*.c' -exec sed -i '/module->module_cancel\.funcptr =/ s/^/\/\//' {} +

$(BUILD_DIR)/example/example.js: $(BUILD_DIR)/example/example.c
	emcc -o $@ $< $(BUILD_DIR)/lib/libcobdom.a -lgmp -lcob -s EXPORTED_FUNCTIONS=_cob_init,_EXAMPLE,_LAYOUT,_FETCHCALLBACK,_TAB1,_TAB2,_TAB3 -s EXPORTED_RUNTIME_METHODS=ccall,cwrap
	#-s STANDALONE_WASM=1

example: $(BUILD_DIR)/example/example.js 
	cp $(DEBUG_DIR)/index.html $(BUILD_DIR)/example/index.html

clean:
	rm -rf $(BUILD_DIR)

.PHONY: all clean install remove
