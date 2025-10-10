#include <emscripten.h>
#include <stdint.h>

EM_JS(int, cd_create_element, (int variable_name,int element_type), {
	try {
		let variableName = UTF8ToString(variable_name);
		let elementType = UTF8ToString(element_type);
		//window[] = ''
		window[variableName] = document.createElement(elementType);
		return 1;
	} catch (e) {
		console.log('CobDOMinate Error:');
		console.log('  Create element: ' + e);
		return -1;
	}
});
int cobdom_create_element(const char *variable_name,const char *element_type) {
	return cd_create_element((intptr_t)variable_name,(intptr_t)element_type);
}
EM_JS(int, cd_append_child, (int variable_name,int parent_name), {
	try {
		let variableName = UTF8ToString(variable_name);
		let parentName = UTF8ToString(parent_name);
		parentName.appendChild(window[variableName]);
		return 1;
	} catch (e) {
		console.log('CobDOMinate Error:');
		console.log('  Append child: ' + e);
		return -1;
	}
});
int cobdom_append_child(const char *variable_name, const char *parent_name) {
	return cd_append_child((intptr_t)variable_name,(intptr_t)parent_name);
}
EM_JS(int, cd_remove_child, (int variable_name,int parent_name), {
	try {
		let variableName = UTF8ToString(variable_name);
		let parentName = UTF8ToString(parent_name);
		parentName.removeChild(window[variableName]);
		return 1;
	} catch (e) {
		console.log('CobDOMinate Error:');
		console.log('  Remove child: ' + e);
		return -1;
	}
});
int cobdom_remove_child(const char *variable_name, const char *parent_name) {
	return cd_remove_child((intptr_t)variable_name,(intptr_t)parent_name);
}
EM_JS(int, cd_inner_html, (int variable_name,int html_content), {
	try {
		let variableName = UTF8ToString(variable_name);
		let htmlContent = UTF8ToString(parent_name);
		window[variableName].innerHTML=htmlContent;
		return 1;
	} catch (e) {
		console.log('CobDOMinate Error:');
		console.log('  Inner HTML: ' + e);
		return -1;
	}
});
int cobdom_inner_html(const char *variable_name, const char *html_content) {
	return cd_inner_html((intptr_t)variable_name,(intptr_t)html_content);
}
EM_JS(int, cd_add_event_listener, (int variable_name,int event_type,int js_code), {
	try {
		let variableName = UTF8ToString(variable_name);
		let eventType = UTF8ToString(event_type);
		let jsCode = UTF8ToString(js_code);
		window[variableName].addEventListener(eventType,jsCode);
		return 1;
	} catch (e) {
		console.log('CobDOMinate Error:');
		console.log('  Add event listener: ' + e);
		return -1;
	}
});
int cobdom_add_event_listener(const char *variable_name, const char *event_type, const char *js_code) { //JS or function?
	return cd_add_event_listener((intptr_t)variable_name,(intptr_t)event_type,(intptr_t)js_code);
}
//int cobdom_class_name(const char *variable_name, const char *class_name) {
//
//}
//int cobdom_style(const char *variable_name, const char *style_) { //Style String?
//
//}
EM_JS(int, cd_set_cookie, (int data,int cookie_name), {
	try {
		let cookieName = UTF8ToString(cookie_name);
		let content = UTF8ToString(data);
		document.cookie=cookieName + encodeURIComponent(content);
		return 1;
	} catch (e) {
		console.log('CobDOMinate Error:');
		console.log('  Set cookie: ' + e);
		return -1;
	}
});
int cobdom_set_cookie(const char *data, const char *cookie_name) {
	return cd_set_cookie((intptr_t)data,(intptr_t)cookie_name);
}
EM_JS(int, cd_get_cookie, (int data,int cookie_name), {
	try {
		let cookieName = UTF8ToString(cookie_name);
		let content = decodeURIComponent(document.cookie.split('; ').find(row => row.startsWith(cookieName + '='))?.split('=')[1] || '');
		stringToUTF8(content, data, 1024);
		return 1;
	} catch (e) {
		console.log('CobDOMinate Error:');
		console.log('  Get cookie: ' + e);
		return -1;
	}
});
int cobdom_get_cookie(char *data, const char *cookie_name) {
	return cd_get_cookie((intptr_t)data,(intptr_t)cookie_name);
}
