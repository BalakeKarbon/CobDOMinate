#include <emscripten.h>

EM_JS(int, get_return_string, (int ptr, int funcCodePtr), {
	let funcCode = UTF8ToString(funcCodePtr);
	try {
		let func = eval("(" + funcCode + ")");
		
		if (typeof func !== 'function') {
			return -1;
		}
		let result = func();
		stringToUTF8(result, ptr, 1024);
		return 1;
	} catch (e) {
		return -1;
	}
});
int return_string(char *ptr, const char *funcCode) {
    return get_return_string((int)ptr, (int)funcCode);
}
