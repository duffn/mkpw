package main

import "core:crypto"
import "core:encoding/base64"
import "core:encoding/hex"
import "core:fmt"
import "core:strings"

ALPHA :: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
NUMBERS :: "0123456789"
SYMBOLS :: "!@#$%^&*()-_=+[]{};:'\",.<>?/"

build_allowed_chars :: proc(no_numbers: bool, no_symbols: bool) -> string {
	allowed_chars := strings.concatenate({ALPHA, NUMBERS, SYMBOLS})
	defer delete(allowed_chars)

	if no_numbers {
		old := allowed_chars
		new_string, removed_something := strings.remove(old, NUMBERS, -1)
		if removed_something {
			allowed_chars = new_string
			delete(old)
		}
	}

	if no_symbols {
		old := allowed_chars
		new_string, removed_something := strings.remove(old, SYMBOLS, -1)
		if removed_something {
			allowed_chars = new_string
			delete(old)
		}
	}

	return strings.clone(allowed_chars)
}

generate_password :: proc(allowed_chars: string, length: int, generate_hex: bool, generate_base64: bool) -> string {
	random_bytes := make([]u8, length)
	defer delete(random_bytes)

	crypto.rand_bytes(random_bytes)

	if generate_hex {
		return strings.clone(string(hex.encode(random_bytes, context.temp_allocator)))
	}

	if generate_base64 {
		return strings.clone(string(base64.encode(random_bytes, base64.ENC_TABLE, context.temp_allocator)))
	}

	alphabet_len := len(allowed_chars)

	result_chars := make([]u8, length)
	defer delete(result_chars)
	for j in 0 ..< length {
		idx := random_bytes[j] % u8(alphabet_len)
		result_chars[j] = allowed_chars[idx]
	}

	result := string(result_chars)

	return strings.clone(result)
}
