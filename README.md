# CobDOMinate
COBOL Library for interacting with the HTML DOM

Dependencies include:
 - Emscripten SDK
 - GnuCOBOL compiler
 - WASM GMP Library for use with Emscripten
 - WASM GnuCOBOL Library for use with Emscripten
 - Make

To build, setup your EMSDK environemnt and verify it has its own GMP and GnuCOBOL libraries. Then run `make`.

To install the library, veryfy the Makefile has the correct `LIB_INSTALL_DIR` and run `make install`.

Alternatively use my [Ancient Wasm](https://github.com/BalakeKarbon/ancientwasm) container for an easy ready-to-go environment.

Bellow is all currently available procedures for the library. You will note they all return an integer type reflecting the success of the call. `1` for success and `-1` for fail.
```
cobdom_add_event_listener int cobdom_add_event_listener(char *variable_name, char *event_type, char *cobol_func) {
cobdom_append_child int cobdom_append_child(char *variable_name, char *parent_name) {
cobdom_class_style int cobdom_class_style(char *class_name, char *style_key, char *style_value) {
cobdom_clear_interval int cobdom_clear_interval(char *variable_name) {
cobdom_clear_timeout int cobdom_clear_timeout(char *variable_name) {
cobdom_create_element int cobdom_create_element(char *variable_name,char *element_type) {
cobdom_eval int cobdom_eval(char *data_size,char *data,char *jscode) {
cobdom_fetch int cobdom_fetch(char *func, char *url, char *method, char *body) {
cobdom_font_face int cobdom_font_face(char *font_family, char *font_source,char *cobol_func) {
cobdom_get_cookie int cobdom_get_cookie(char *data, char *cookie_name) {
cobdom_href int cobdom_href(char *variable_name, char *href) {
cobdom_inner_html int cobdom_inner_html(char *variable_name, char *html_content) {
cobdom_open_tab int cobdom_open_tab(char *location_url) {
cobdom_remove_child int cobdom_remove_child(char *variable_name, char *parent_name) {
cobdom_remove_event_listener int cobdom_remove_event_listener(char *variable_name, char *event_type) {
cobdom_scroll_into_view int cobdom_scroll_into_view(char *variable_name) {
cobdom_set_class int cobdom_set_class(char *variable_name, char *class_name) {
cobdom_set_cookie int cobdom_set_cookie(char *data, char *cookie_name) {
cobdom_set_interval int cobdom_set_interval(char *variable_name,char *func, char *time) {
cobdom_set_timeout int cobdom_set_timeout(char *variable_name,char *func, char *time) {
cobdom_src int cobdom_src(char *variable_name, char *src) {
cobdom_string void cobdom_string(char* cobol_string) {
cobdom_style int cobdom_style(char *variable_name, char *style_key, char *style_value) {
cobdom_test_string int cobdom_test_string(char* my_string) {
```
