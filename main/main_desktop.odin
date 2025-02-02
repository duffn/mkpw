#+build !js
package main

import "core:crypto"
import "core:flags"
import "core:fmt"
import "core:log"
import "core:mem"
import "core:os"

_ :: mem

VERSION :: "v0.4.0"
LOG_LEVEL :: log.Level.Debug when ODIN_DEBUG else log.Level.Info

Options :: struct {
	length:         int `usage:"Length of the password to generate, default: 20."`,
	quantity:       int `usage:"Number of passwords to generate, default: 1."`,
	no_numbers:     bool `usage:"Do not include numbers in the password."`,
	no_symbols:     bool `usage:"Do not include symbols in the password."`,
	hex:            bool `usage:"Output the password in hexadecimal format. Note that this will double the length of the password."`,
	base64:         bool `usage:"Output the password in base64 format. Note that this will increase the length of the password."`,
	base64_urlsafe: bool `usage:"Output the password in base64 format that is URL safe. Note that this will increase the length of the password."`,
	version:        bool `usage:"Print the version and exit."`,
}

parse_and_validate_options :: proc(args: []string) -> Options {
	opt: Options
	style: flags.Parsing_Style = .Unix
	flags.parse_or_exit(&opt, args, style)

	if opt.version {
		fmt.printfln("mkpw %s", VERSION)
		os.exit(0)
	}

	if opt.hex && (opt.base64 || opt.base64_urlsafe) {
		fmt.println("ERROR: Cannot output both hex and base64 encoded passwords. Choose either hex or base64.")
		os.exit(1)
	}

	if opt.base64_urlsafe && opt.base64 {
		fmt.println("WARN: Selected both base64 && base64-urlsafe. Defaulting to base64-urlsafe.")
		opt.base64 = false
	}

	if opt.length <= 0 {
		opt.length = 20
	} else if opt.length > 1024 {
		fmt.println("INFO: Password length is greater than 1024. Using 1024 as the maximum size.")
		opt.length = 1024
	}

	if opt.quantity <= 0 {
		opt.quantity = 1
	} else if opt.quantity > 100 {
		fmt.println("INFO: Quantity is greater than 100. Using 100.")
		opt.quantity = 100
	}

	return opt
}

main :: proc() {
	when ODIN_DEBUG {
		track: mem.Tracking_Allocator
		mem.tracking_allocator_init(&track, context.allocator)
		context.allocator = mem.tracking_allocator(&track)

		defer {
			if len(track.allocation_map) > 0 {
				fmt.eprintf("=== %v allocations not freed: ===\n", len(track.allocation_map))
				for _, entry in track.allocation_map {
					fmt.eprintf("- %v bytes @ %v\n", entry.size, entry.location)
				}
			}
			if len(track.bad_free_array) > 0 {
				fmt.eprintf("=== %v incorrect frees: ===\n", len(track.bad_free_array))
				for entry in track.bad_free_array {
					fmt.eprintf("- %p @ %v\n", entry.memory, entry.location)
				}
			}
			mem.tracking_allocator_destroy(&track)
		}
	}

	context.logger = log.create_console_logger()
	context.logger.lowest_level = LOG_LEVEL
	defer log.destroy_console_logger(context.logger)

	opt := parse_and_validate_options(os.args)
	log.debugf("%#v", opt)

	if !crypto.HAS_RAND_BYTES {
		fmt.println(
			"ERROR: secure random bytes are not available on this platform. Refusing to generate an insecure password.",
		)
		os.exit(1)
	}

	allowed_chars := build_allowed_chars(opt.no_numbers, opt.no_symbols)
	defer delete(allowed_chars)

	output_length := opt.length
	if opt.hex {
		output_length *= 2
	} else if opt.base64 {
		bit := 3
		output_length = ((4 * output_length) / 3 + 3) & ~bit
	}
	if output_length < 16 {
		fmt.println("WARN: Password length is less than 16 characters. You should consider a longer password.")
	}
	log.debugf("Password result length is %d", output_length)
	for _ in 0 ..< opt.quantity {
		pass := generate_password(allowed_chars, opt.length, opt.hex, opt.base64, opt.base64_urlsafe)
		fmt.println(pass)
		delete(pass)
	}

	free_all(context.temp_allocator)
}
