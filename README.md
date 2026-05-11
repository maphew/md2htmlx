# 📝 md2htmlx — Markdown to HTML5 Converter (with optional live watch)

`md2htmlx` is a small, fast command-line tool written in Rust that converts
Markdown files into HTML.

By default it produces a complete, **HTML5-compliant** document styled with
[simple.css](https://simplecss.org/) (vendored at build time — no network
access at runtime). An optional **watch mode** keeps re-rendering the output
whenever the Markdown source is edited.

---

## 🚀 Features

- ✅ Converts `.md` files to standalone HTML5 documents
- 🎨 Pretty default styling via embedded [simple.css](https://simplecss.org/)
- 📄 `--bare` flag emits a raw HTML fragment (no `<html>`/`<head>`/`<body>`/CSS)
- 👀 `--watch` flag enables auto-rerender on file change (with debouncing)
- ⚡ Fast and self-contained — single binary, no runtime assets
- 🧩 Built on `pulldown-cmark`, `clap`, and `notify`

---

## 📦 Installation

### From crates.io

```bash
cargo install md2htmlx
```

### Build from source

```bash
git clone https://github.com/maphew/md2htmlx.git
cd md2htmlx
cargo build --release
./target/release/md2htmlx input.md output.html
```

---

## 📦 Usage

```text
Usage: md2htmlx [OPTIONS] <INPUT> <OUTPUT>

Arguments:
  <INPUT>   Input Markdown file
  <OUTPUT>  Output HTML file

Options:
  -w, --watch    Watch the input file and re-render on every change
  -b, --bare     Emit only the raw HTML fragment (no <html>, <head>, <body>, no CSS)
  -h, --help     Print help
  -V, --version  Print version
```

### Examples

Convert once and exit (default — produces a styled, standalone HTML5 page):

```bash
md2htmlx input.md output.html
```

Emit a bare HTML fragment (useful for embedding in another template):

```bash
md2htmlx --bare input.md output.html
```

Watch for changes and re-render on every save:

```bash
md2htmlx --watch input.md output.html
```

---

## 🎨 Default output

The default (non-`--bare`) output is a complete HTML5 document:

- `<!DOCTYPE html>` + `<html lang="en">`
- UTF-8 charset and responsive viewport meta
- `<title>` derived from the first `# Heading` in the source (falls back to the
  input filename)
- An inlined copy of [simple.css](https://simplecss.org/) inside `<style>`,
  giving you sensible typography and automatic light/dark mode out of the box
- Body content wrapped in `<main>`

Markdown extensions enabled: tables, footnotes, task lists, strikethrough.

---

## 🙏 Credits

This project is a grateful fork of
**[rust-md2html](https://github.com/haffizaliraza/rust-md2html)** by
[Hafiz Ali Raza](https://github.com/haffizaliraza), which provided the original
Markdown-to-HTML CLI and watch-mode skeleton. Thank you for the head start!

This fork adds:

- Convert-and-exit as the default; watch mode is now opt-in (`--watch`)
- Standalone HTML5 output with embedded [simple.css](https://simplecss.org/)
- A `--bare` flag that preserves the original fragment-only behavior
- Title auto-derived from the first heading
- Debounced file-change events (no more duplicate renders per save)
- Surfaced watcher errors instead of swallowing them
- Markdown extensions: tables, footnotes, task lists (in addition to strikethrough)

The bundled [simple.css](https://simplecss.org/) is © 2020
[Kev Quirk](https://kevquirk.com/) and distributed under the MIT License — see
[`assets/simple.css.LICENSE`](assets/simple.css.LICENSE).

---

## 📄 License

This project is dual-licensed under either of:

- MIT License ([LICENSE-MIT](https://opensource.org/licenses/MIT))
- Apache License, Version 2.0 ([LICENSE-APACHE](https://www.apache.org/licenses/LICENSE-2.0.html))

at your option, matching the licensing of the upstream project.
