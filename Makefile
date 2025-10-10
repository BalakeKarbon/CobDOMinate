SRC_DIR := ./src
BUILD_DIR := ./build
DEBUG_DIR := ./example

all: $(BUILD_DIR)/lib/libcobdom.a

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(BUILD_DIR)/lib: $(BUILD_DIR)
	mkdir -p $(BUILD_DIR)/lib

$(BUILD_DIR)/lib/libcobdom.a: $(BUILD_DIR)/cobdom.o $(BUILD_DIR)/bridge.o | $(BUILD_DIR)/lib
	emar rcs $@ $< $(BUILD_DIR)/bridge.o

$(BUILD_DIR)/cobdom.o: $(BUILD_DIR)/cobdom.c
	emcc -c $< -o $@

$(BUILD_DIR)/bridge.o: $(SRC_DIR)/bridge.c
	emcc -c $< -o $@

$(BUILD_DIR)/cobdom.c: $(SRC_DIR)/cobdom.cob | $(BUILD_DIR)
	(cd $(SRC_DIR) && cobc -C -o $(abspath $@) $(notdir $<) -K emscripten_run_script_int -K return_string)
	#find $(BUILD_DIR) -type f -name '*.c' -exec sed -i '/module->module_cancel\.funcptr =/ s/^/\/\//' {} +
	#cobc -C $< -o $@

$(BUILD_DIR)/example: $(BUILD_DIR)
	mkdir -p $(BUILD_DIR)/example

$(BUILD_DIR)/example/example.c: all | $(BUILD_DIR)/example 
	cobc -C -o $@ ./example/host.cob -K COBDOM-VERSION -K COBDOM-CREATE-ELEMENT -K COBDOM-APPEND-CHILD -K COBDOM-REMOVE-CHILD -K COBDOM-INNER-HTML -K COBDOM-ADD-EVENT-LISTENER -K COBDOM-CLASS-NAME -K COBDOM-STYLE -K COBDOM-SET-COOKIE -K COBDOM-GET-COOKIE -K EXAMPLE -K TESTFUNC
	#find $(BUILD_DIR)/example -type f -name '*.c' -exec sed -i '/module->module_cancel\.funcptr =/ s/^/\/\//' {} +

$(BUILD_DIR)/example/example.js: $(BUILD_DIR)/example/example.c
	emcc -o $@ $< $(BUILD_DIR)/lib/libcobdom.a -lgmp -lcob -s EXPORTED_FUNCTIONS=_cob_init,_TESTFUNC,_EXAMPLE -s EXPORTED_RUNTIME_METHODS=ccall,cwrap
	#-s STANDALONE_WASM=1

example: $(BUILD_DIR)/example/example.js 
	cp $(DEBUG_DIR)/index.html $(BUILD_DIR)/example/index.html

clean:
	rm -rf $(BUILD_DIR)

.PHONY: all clean
