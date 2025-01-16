package tests

import "core:fmt"
import "core:strings"
import "core:testing"

import "../main"

@(test)
test_generate_password_length :: proc(t: ^testing.T) {
	allowed_chars := "ABCDEF"
	pass_len := 16
	generate_hex := false
	generate_base64 := false
	pw := main.generate_password(allowed_chars, pass_len, generate_hex, generate_base64)
	defer delete(pw)

	testing.expect(t, len(pw) == pass_len, fmt.tprintf("Expected password length %d, got %d", pass_len, len(pw)))
}

@(test)
test_generate_password_length_hex :: proc(t: ^testing.T) {
	allowed_chars := "ABCDEF"
	pass_len := 16
	hex_len := pass_len * 2
	generate_hex := true
	generate_base64 := false
	pw := main.generate_password(allowed_chars, pass_len, generate_hex, generate_base64)
	defer delete(pw)

	testing.expect(t, len(pw) == hex_len, fmt.tprintf("Expected password length %d, got %d", hex_len, len(pw)))
}

@(test)
test_generate_password_length_base64 :: proc(t: ^testing.T) {
	allowed_chars := "ABCDEF"
	pass_len := 16
	base64_len := 24
	generate_hex := false
	generate_base64 := true
	pw := main.generate_password(allowed_chars, pass_len, generate_hex, generate_base64)
	defer delete(pw)

	testing.expect(
		t,
		len(pw) == base64_len,
		fmt.tprintf("Expected password length %d, got %d", base64_len, len(pw)),
	)
	testing.expect(t, strings.ends_with(pw, "="), fmt.tprint("Expected password to end with \"=\""))
}

@(test)
test_generate_password_randomness :: proc(t: ^testing.T) {
	allowed_chars := "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
	pass_len := 16
	generate_hex := false
	generate_base64 := false

	pw1 := main.generate_password(allowed_chars, pass_len, generate_hex, generate_base64)
	defer delete(pw1)
	pw2 := main.generate_password(allowed_chars, pass_len, generate_hex, generate_base64)
	defer delete(pw2)

	// This is a weak test for randomness, but it's better than nothing.
	// I suppose this could fail is there's a collision, but that's unlikely.
	testing.expect(t, pw1 != pw2, "Expected different passwords across multiple calls.")
}
