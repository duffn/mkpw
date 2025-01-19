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
odin build main -out:mkpw -vet -strict-style -vet-tabs -disallow-do -warnings-as-errors
```

#### Windows

```bash
odin build main -out:mkpw.exe -vet -strict-style -vet-tabs -disallow-do -warnings-as-errors
```

### Binaries

- Download your platform's binary from the most current [release](https://github.com/duffn/mkpw/releases).
- Note that on macOS, you'll be informed that the binary cannot be run because it cannot be verified. You can [allow the binary to be run](https://apple.stackexchange.com/questions/436674/how-to-unblock-binary-from-use-because-mac-says-it-is-not-from-identified-develo) anyway, or if that makes you uncomfortable, you can build the application from source.

### Homebrew

If you are on macOS or Linux and use [Homebrew](https://brew.sh), you can install from the [repository's custom tap](https://github.com/duffn/homebrew-mkpw).

```bash
brew install duffn/mkpw/mkpw
```

### Web

You can also build and run this in the browser.

- Build for the web.

```bash
odin build main -target:js_wasm32 -out:web/index.wasm -vet -strict-style -vet-tabs -disallow-do -warnings-as-errors
```

- If you are going to update the CSS, you need to [install the Tailwind CSS CLI](https://tailwindcss.com/blog/standalone-cli) and compile the CSS.

```bash
tailwindcss -i web/mkpw-in.css -o web/mkpw.css --watch
```

- Run a local webserver in the `web` directory. While you can do this with many languages, it is easy if you have Python.

```bash
python -m http.server
```

- Navigate to http://localhost:8000

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

## Is this secure?

- If your concern is, is this program storing your passwords somewhere, the answer is no. If you're a software developer, you can take a look at the code yourself to confirm. There's no server anywhere to even store your passwords. This is running completely as a static site on GitHub.
- If your concern is, is it using a secure method to generate random passwords, the answer is yes. It is using the [Odin cryptographic random bytes generator](https://github.com/odin-lang/Odin/blob/47030501abbdb9b09baf34f1ea1ed15f513ccd6d/core/crypto/crypto.odin#L49-L61), which generates random bytes suitable for password generation.

## License

MIT
