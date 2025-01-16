# mkpw

This is a simple and secure password generator written in [Odin](https://odin-lang.org/).

## Motivation

I want to write more Odin, that's all. I've been generating passwords for some time with Ruby or Python core libraries, which is fine, but it seemed a good opportunity to build my own password generator with my new favorite language, write tests, build and deploy an Odin binary in GitHub Actions, and so on.

## Installation

### Build from source

Recommended.

- Clone this repository.
- Ensure the [Odin](https://odin-lang.org/docs/install/) compiler is installed on your system.
- Build from the root directory.

#### macOS & Linux

```bash
odin build main -out:mkpw
```

#### Windows

```bash
odin build main -out:mkpw.exe
```

### Binaries

- Download your platform's binary from the most current [release](https://github.com/duffn/mkpw/releases).
- Note that on macOS, you'll be informed that the binary cannot be run because it cannot be verified. You can [allow the binary to be run](https://apple.stackexchange.com/questions/436674/how-to-unblock-binary-from-use-because-mac-says-it-is-not-from-identified-develo) anyway, or if that makes you uncomfortable, you can build the application from source.

## Usage

If on Windows, replease `mkpw` with `mkpw.exe` in all the examples below.

- Get help.

```
mkpw --help
```

- Generate a password with secure defaults.

```
mkpw
```

- Generate 16 passwords, 100 characters each, and don't use numbers or symbols.

```
mkpw --length=100 --quantity=16 --no-numbers --no-symbols
```

- Output the password in hex.

```
mkpw --length=20 --hex
```

- Output the password in base64.

```
mkpw --length=20 --base64
```

## License

MIT
