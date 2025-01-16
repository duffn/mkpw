package tests

import "core:fmt"
import "core:strings"
import "core:testing"

import "../main"

@(test)
test_build_allowed_chars_default :: proc(t: ^testing.T) {
	res := main.build_allowed_chars(false, false)
	defer delete(res)

	testing.expect(t, strings.contains(res, main.ALPHA), "Expected to find ALPHA in the generated string.")
	testing.expect(t, strings.contains(res, main.NUMBERS), "Expected to find NUMBERS in the generated string.")
	testing.expect(t, strings.contains(res, main.SYMBOLS), "Expected to find SYMBOLS in the generated string.")

	total_expected := len(main.ALPHA) + len(main.NUMBERS) + len(main.SYMBOLS)
	testing.expect(
		t,
		len(res) == total_expected,
		fmt.tprintf("Expected length %d, got %d", total_expected, len(res)),
	)
}

@(test)
test_build_allowed_chars_no_numbers :: proc(t: ^testing.T) {
	res := main.build_allowed_chars(true, false)
	defer delete(res)

	testing.expect(t, strings.contains(res, main.ALPHA), "Expected to find ALPHA in the generated string.")
	testing.expect(
		t,
		!strings.contains(res, main.NUMBERS),
		"Expected not to find NUMBERS in the generated string.",
	)
	testing.expect(t, strings.contains(res, main.SYMBOLS), "Expected to find SYMBOLS in the generated string.")

	total_expected := len(main.ALPHA) + len(main.SYMBOLS)
	testing.expect(
		t,
		len(res) == total_expected,
		fmt.tprintf("Expected length %d, got %d", total_expected, len(res)),
	)
}

@(test)
test_build_allowed_chars_no_symbols :: proc(t: ^testing.T) {
	res := main.build_allowed_chars(false, true)
	defer delete(res)

	testing.expect(t, strings.contains(res, main.ALPHA), "Expected to find ALPHA in the generated string.")
	testing.expect(t, strings.contains(res, main.NUMBERS), "Expected to find NUMBERS in the generated string.")
	testing.expect(
		t,
		!strings.contains(res, main.SYMBOLS),
		"Expected not to find SYMBOLS in the generated string.",
	)

	total_expected := len(main.ALPHA) + len(main.NUMBERS)
	testing.expect(
		t,
		len(res) == total_expected,
		fmt.tprintf("Expected length %d, got %d", total_expected, len(res)),
	)
}

@(test)
test_build_allowed_chars_no_symbols_no_numbers :: proc(t: ^testing.T) {
	res := main.build_allowed_chars(true, true)
	defer delete(res)

	testing.expect(t, strings.contains(res, main.ALPHA), "Expected to find ALPHA in the generated string.")
	testing.expect(
		t,
		!strings.contains(res, main.NUMBERS),
		"Expected not to find NUMBERS in the generated string.",
	)
	testing.expect(
		t,
		!strings.contains(res, main.SYMBOLS),
		"Expected not to find SYMBOLS in the generated string.",
	)

	total_expected := len(main.ALPHA)
	testing.expect(
		t,
		len(res) == total_expected,
		fmt.tprintf("Expected length %d, got %d", total_expected, len(res)),
	)
}
