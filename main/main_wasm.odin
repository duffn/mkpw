#+build js
package main

import "base:runtime"
import "core:crypto"
import "core:fmt"
import "core:strings"

main :: proc() {}

default_context :: proc "contextless" () -> runtime.Context {
	context = runtime.default_context()
	context.allocator = runtime.default_wasm_allocator()
	context.random_generator = crypto.random_generator()
	return context
}

@(export)
generate_password_web :: proc(
	length: int,
	no_numbers: bool,
	no_symbols: bool,
	generate_hex: bool,
	generate_base64: bool,
) -> cstring {
	context = default_context()

	if !crypto.HAS_RAND_BYTES {
		fmt.println(
			"ERROR: secure random bytes are not available on this platform. Refusing to generate an insecure password.",
		)
		return(
			"ERROR: secure random bytes are not available on this platform. Refusing to generate an insecure password." \
		)
	}

	generate_length := length
	if length <= 0 {
		generate_length = 20
	}

	random_bytes := make([]u8, generate_length)
	defer delete(random_bytes)

	crypto.rand_bytes(random_bytes)

	allowed_chars := build_allowed_chars(no_numbers, no_symbols)
	defer delete(allowed_chars)

	if generate_hex && generate_base64 {
		fmt.println("ERROR: cannot generate a password that is both hex and base64.")
		return "ERROR: cannot generate a password that is both hex and base64."
	}

	password := generate_password(allowed_chars, generate_length, generate_hex, generate_base64)
	defer delete(password)

	return strings.clone_to_cstring(password)
}
