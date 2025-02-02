"use strict";

const memInterface = new odin.WasmMemoryInterface();
let odinExports = null;

(async () => {
  await odin.runWasm("index.wasm", null, null, memInterface);
  odinExports = memInterface.exports;

  const button = document.getElementById("generate-button");
  const length = document.getElementById("length-range");
  const noSymbolsElem = document.getElementById("no-symbols");
  const noNumbersElem = document.getElementById("no-numbers");
  const passwordFormats = document.querySelectorAll(
    "input[type=radio][name=password-format]",
  );
  let selectedPasswordFormat = "standard";
  let noSymbols = noSymbolsElem.checked;
  let noNumbers = noNumbersElem.checked;

  button.addEventListener("click", () => {
    generatePassword(noNumbers, noSymbols, selectedPasswordFormat);
  });

  length.addEventListener("change", () => {
    generatePassword(noNumbers, noSymbols, selectedPasswordFormat);
  });

  noSymbolsElem.addEventListener("change", () => {
    noSymbols = noSymbolsElem.checked;
    generatePassword(noNumbers, noSymbols, selectedPasswordFormat);
  });

  noNumbersElem.addEventListener("change", () => {
    noNumbers = noNumbersElem.checked;
    generatePassword(noNumbers, noSymbols, selectedPasswordFormat);
  });

  passwordFormats.forEach((format) => {
    format.addEventListener("change", () => {
      if (format.id === "hex") {
        selectedPasswordFormat = "hex";
      } else if (format.id === "base64") {
        selectedPasswordFormat = "base64";
      } else if (format.id === "base64-urlsafe") {
        selectedPasswordFormat = "base64-urlsafe";
      } else {
        selectedPasswordFormat = "standard";
      }

      generatePassword(noNumbers, noSymbols, selectedPasswordFormat);
    });
  });

  generatePassword(noNumbers, noSymbols, selectedPasswordFormat);
})();

function generatePassword(noNumbers, noSymbols, selectedPasswordFormat) {
  let generateHex = false;
  let generateBase64 = false;
  let generateBase64UrlSafe = false;
  const output = document.getElementById("password");
  const length = document.getElementById("length-range");

  const parsedLength = parseInt(length.value);
  let resultLength;
  if (selectedPasswordFormat === "hex") {
    resultLength = parsedLength * 2;
    generateHex = true;
  } else if (selectedPasswordFormat === "base64") {
    resultLength = ((4 * parsedLength) / 3 + 3) & ~3;
    generateBase64 = true;
  } else if (selectedPasswordFormat === "base64-urlsafe") {
    resultLength = calculateBase64UrlSafeLength(parsedLength);
    generateBase64UrlSafe = true;
  } else {
    resultLength = parsedLength;
  }

  const password = odinExports.generate_password_web(
    parsedLength,
    noNumbers,
    noSymbols,
    generateHex,
    generateBase64,
    generateBase64UrlSafe,
  );

  output.innerText = memInterface.loadString(password, resultLength);
}

function calculateBase64UrlSafeLength(length) {
  let padding = 0;
  switch (length % 3) {
    case 1:
      padding = 2;
    case 2:
      padding = 1;
  }
  return (((4 * length) / 3 + 3) & ~3) - padding;
}
