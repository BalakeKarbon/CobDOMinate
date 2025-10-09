SRC_DIR := ./src
BUILD_DIR := ./build
DEBUG_DIR := ./debug

all: $(BUILD_DIR)/lib/libcobdom.a

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(BUILD_DIR)/lib: $(BUILD_DIR)
	mkdir -p $(BUILD_DIR)/lib

$(BUILD_DIR)/lib/libcobdom.a: $(BUILD_DIR)/cobdom.o | $(BUILD_DIR)/lib
	emar rcs $@ $<

$(BUILD_DIR)/cobdom.o: $(BUILD_DIR)/cobdom.c
	emcc -c $< -o $@

$(BUILD_DIR)/cobdom.c: $(SRC_DIR)/cobdom.cob | $(BUILD_DIR)
	(cd $(SRC_DIR) && cobc -C -o $(abspath $@) $(notdir $<) -K emscripten_run_script_int)
	find $(BUILD_DIR) -type f -name '*.c' -exec sed -i '/module->module_cancel\.funcptr =/ s/^/\/\//' {} +
	#cobc -C $< -o $@

$(BUILD_DIR)/test: $(BUILD_DIR)
	mkdir -p $(BUILD_DIR)/test

$(BUILD_DIR)/test/test.c: all | $(BUILD_DIR)/test 
	cobc -x -C -o $@ ./debug/host.cob -K COBDOM-INIT -K COBDOM-VERSION -K COBDOM-CREATE-ELEMENT -K COBDOM-APPEND-CHILD -K COBDOM-REMOVE-CHILD -K COBDOM-INNER-HTML -K COBDOM-ADD-EVENT-LISTENER -K HOST-TEST -K TESTFUNC
	find $(BUILD_DIR)/test -type f -name '*.c' -exec sed -i '/module->module_cancel\.funcptr =/ s/^/\/\//' {} +

$(BUILD_DIR)/test/test.js: $(BUILD_DIR)/test/test.c
	emcc -o $@ $< $(BUILD_DIR)/lib/libcobdom.a -lgmp -lcob -s EXPORTED_FUNCTIONS=_cob_init,_TESTFUNC -s EXPORTED_RUNTIME_METHODS=ccall,cwrap -s STANDALONE_WASM=1

test: $(BUILD_DIR)/test/test.js 
	cp $(DEBUG_DIR)/index.html $(BUILD_DIR)/test/index.html

clean:
	rm -rf $(BUILD_DIR)

.PHONY: all clean
