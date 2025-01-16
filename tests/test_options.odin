package tests

import "../main"
import "core:testing"

@(test)
test_parse_and_validate_options_length :: proc(t: ^testing.T) {
	args := []string{"prog", "--length=999"}
	opt := main.parse_and_validate_options(args)
	testing.expect(t, opt.length == 999, "Expected length of 999 to remain unchanged.")
}

@(test)
test_parse_and_validate_options_length_zero :: proc(t: ^testing.T) {
	args := []string{"prog", "--length=0"}
	opt := main.parse_and_validate_options(args)
	testing.expect(t, opt.length == 20, "Expected length to default to 20 when user passes 0 or negative.")
}


@(test)
test_parse_and_validate_options_length_too_large :: proc(t: ^testing.T) {
	args := []string{"prog", "--length=2000"}
	opt := main.parse_and_validate_options(args)
	testing.expect(t, opt.length == 1024, "Expected length to be capped at 1024.")
}

@(test)
test_parse_and_validate_options_quantity :: proc(t: ^testing.T) {
	args := []string{"prog", "--quantity=20"}
	opt := main.parse_and_validate_options(args)
	testing.expect(t, opt.quantity == 20, "Expected quantity of 20 to remain unchanged.")
}

@(test)
test_parse_and_validate_options_quantity_zero :: proc(t: ^testing.T) {
	args := []string{"prog", "--quantity=0"}
	opt := main.parse_and_validate_options(args)
	testing.expect(t, opt.quantity == 1, "Expected quantity of 0 to default to 1.")
}

@(test)
test_parse_and_validate_options_quantity_too_large :: proc(t: ^testing.T) {
	args := []string{"prog", "--quantity=10000"}
	opt := main.parse_and_validate_options(args)
	testing.expect(t, opt.quantity == 100, "Expected quantity to be capped at 100.")
}
