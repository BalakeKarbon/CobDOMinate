#include <emscripten.h>
#include <stdint.h>

char* cobdom_string(char* cobol_string) {
	int len = 0;
	while (cobol_string[len] != '\0') {
		len++;
	}
	while (len > 0 && cobol_string[len - 1] == ' ') {
		len--;
	}
	cobol_string[len] = '\0';
}
EM_JS(int, cd_test_string, (int my_string), {
	try {
		let myString = UTF8ToString(my_string);
		console.log(myString + "-end.");
		return 1;
	} catch (e) {
		console.log('CobDOMinate Error:');
		console.log('  Test string: ' + e);
		return -1;
	}
});
int cobdom_test_string(const char* my_string) {
	cobdom_string(my_string);
	return cd_test_string((intptr_t)my_string);
}
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
	cobdom_string(variable_name);
	cobdom_string(element_type);
	return cd_create_element((intptr_t)variable_name,(intptr_t)element_type);
}
EM_JS(int, cd_append_child, (int variable_name,int parent_name), {
	try {
		let variableName = UTF8ToString(variable_name);
		let parentName = UTF8ToString(parent_name);
		if (parentName == 'body') {
			document.body.appendChild(window[variableName]);
		} else {
			window[parentName].appendChild(window[variableName]);
		}
		return 1;
	} catch (e) {
		console.log('CobDOMinate Error:');
		console.log('  Append child: ' + e);
		return -1;
	}
});
int cobdom_append_child(const char *variable_name, const char *parent_name) {
	cobdom_string(variable_name);
	cobdom_string(parent_name);
	return cd_append_child((intptr_t)variable_name,(intptr_t)parent_name);
}
EM_JS(int, cd_remove_child, (int variable_name,int parent_name), {
	try {
		let variableName = UTF8ToString(variable_name);
		let parentName = UTF8ToString(parent_name);
		if (parentName == 'body') {
			document.body.removeChild(window[variableName]);
		} else {
			window[parentName].removeChild(window[variableName]);
		}
		return 1;
	} catch (e) {
		console.log('CobDOMinate Error:');
		console.log('  Remove child: ' + e);
		return -1;
	}
});
int cobdom_remove_child(const char *variable_name, const char *parent_name) {
	cobdom_string(variable_name);
	cobdom_string(parent_name);
	return cd_remove_child((intptr_t)variable_name,(intptr_t)parent_name);
}
EM_JS(int, cd_inner_html, (int variable_name,int html_content), {
	try {
		let variableName = UTF8ToString(variable_name);
		let htmlContent = UTF8ToString(html_content);
		window[variableName].innerHTML=htmlContent;
		return 1;
	} catch (e) {
		console.log('CobDOMinate Error:');
		console.log('  Inner HTML: ' + e);
		return -1;
	}
});
int cobdom_inner_html(const char *variable_name, const char *html_content) {
	cobdom_string(variable_name);
	cobdom_string(html_content);
	return cd_inner_html((intptr_t)variable_name,(intptr_t)html_content);
}
EM_JS(int, cd_add_event_listener, (int variable_name,int event_type,int cobol_func), {
	try {
		let variableName = UTF8ToString(variable_name);
		let eventType = UTF8ToString(event_type);
		let cobolFunc = UTF8ToString(cobol_func);
		let handler = function () {
			Module.ccall(cobolFunc, null, [], []);
		};
		if (!window._cobHandlers) window._cobHandlers = {};
		let handlerKey = variableName + ':' + eventType;
		window._cobHandlers[handlerKey] = handler;
		window[variableName].addEventListener(eventType,handler);
		return 1;
	} catch (e) {
		console.log('CobDOMinate Error:');
		console.log('  Add event listener: ' + e);
		return -1;
	}
});
int cobdom_add_event_listener(const char *variable_name, const char *event_type, const char *cobol_func) {
	cobdom_string(variable_name);
	cobdom_string(event_type);
	cobdom_string(cobol_func);
	return cd_add_event_listener((intptr_t)variable_name,(intptr_t)event_type,(intptr_t)cobol_func);
}
EM_JS(int, cd_remove_event_listener, (int variable_name,int event_type), {
	try {
		let variableName = UTF8ToString(variable_name);
		let eventType = UTF8ToString(event_type);
		let handlerKey = variableName + ':' + eventType;
		if (window._cobHandler && window._cobHandler[handlerKey]) {
			window[variableName].removeEventListener(eventType,window._cobHandler[handlerKey]);
			delete window._cobHandlers[handlerKey];
			return 1;
		} else {
			console.log('CobDOMinate Error:');
			console.log('  No handler found for remove event listener: ' + e);
			return -1;
		}
	} catch (e) {
		console.log('CobDOMinate Error:');
		console.log('  Remove event listener: ' + e);
		return -1;
	}
});
int cobdom_remove_event_listener(const char *variable_name, const char *event_type) {
	cobdom_string(variable_name);
	cobdom_string(event_type);
	return cd_remove_event_listener((intptr_t)variable_name,(intptr_t)event_type);
}

EM_JS(int, cd_set_class, (int variable_name,int class_name), {
	try {
		let variableName = UTF8ToString(variable_name);
		let nameClass = UTF8ToString(class_name);
		window[variableName].className=nameClass;
		return 1;
	} catch (e) {
		console.log('CobDOMinate Error:');
		console.log('  Set class: ' + e);
		return -1;
	}
});
int cobdom_set_class(const char *variable_name, const char *class_name) {
	cobdom_string(variable_name);
	cobdom_string(class_name);
	return cd_set_class((intptr_t)variable_name,(intptr_t)class_name);
}
EM_JS(int, cd_style, (int variable_name,int style_key,int style_value), {
	try {
		let variableName = UTF8ToString(variable_name);
		let styleKey = UTF8ToString(style_key);
		let styleValue = UTF8ToString(style_value);
		window[variableName].style[styleKey]=styleValue;
		return 1;
	} catch (e) {
		console.log('CobDOMinate Error:');
		console.log('  Style: ' + e);
		return -1;
	}
});
int cobdom_style(const char *variable_name, const char *style_key, const char *style_value) { 
	cobdom_string(variable_name);
	cobdom_string(style_key);
	cobdom_string(style_value);
	return cd_style((intptr_t)variable_name,(intptr_t)style_key,(intptr_t)style_value);
}
EM_JS(int, cd_class_style, (int class_name,int style_key,int style_value), {
	try {
		let className = UTF8ToString(class_name);
		let styleKey = UTF8ToString(style_key);
		let styleValue = UTF8ToString(style_value);
		document.querySelectorAll('.' + className).forEach(el => {
			el.style[styleKey] = styleValue;
		});
		return 1;
	} catch (e) {
		console.log('CobDOMinate Error:');
		console.log('  Style: ' + e);
		return -1;
	}
});
int cobdom_class_style(const char *class_name, const char *style_key, const char *style_value) {
	cobdom_string(class_name);
	cobdom_string(style_key);
	cobdom_string(style_value);
	return cd_class_style((intptr_t)class_name,(intptr_t)style_key,(intptr_t)style_value);
}
EM_JS(int, cd_set_cookie, (int data,int cookie_name), {
	try {
		let cookieName = UTF8ToString(cookie_name);
		let content = UTF8ToString(data);
		document.cookie=cookieName + content;
		return 1;
	} catch (e) {
		console.log('CobDOMinate Error:');
		console.log('  Set cookie: ' + e);
		return -1;
	}
});
int cobdom_set_cookie(const char *data, const char *cookie_name) {
	cobdom_string(data);
	cobdom_string(cookie_name);
	return cd_set_cookie((intptr_t)data,(intptr_t)cookie_name);
}
EM_JS(int, cd_get_cookie, (int data,int cookie_name), {
	try {
		let cookieName = UTF8ToString(cookie_name);
		let content = document.cookie.split('; ').find(row => row.startsWith(cookieName + '='))?.split('=')[1] || '';
		console.log(cookieName);
		console.log(content);
		stringToUTF8(content, data, 1024);
		return 1;
	} catch (e) {
		console.log('CobDOMinate Error:');
		console.log('  Get cookie: ' + e);
		return -1;
	}
});
int cobdom_get_cookie(char *data, const char *cookie_name) {
	cobdom_string(data);
	cobdom_string(cookie_name);
	return cd_get_cookie((intptr_t)data,(intptr_t)cookie_name);
}
