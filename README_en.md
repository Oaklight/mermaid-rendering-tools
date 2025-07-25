# Mermaid Rendering Tools

[中文版](README_zh.md) | [English version](README_en.md)

A collection of shell script tools for rendering and converting Mermaid diagrams.

## Table of Contents

- [Available Scripts](#available-scripts)
  - [render_mermaid.sh](#render_mermaidsh)
  - [svg2pdf.sh](#svg2pdfsh)
- [Installation](#installation)
- [Workflow Example](#workflow-example)
- [License](#license)
- [Author](#author)
- [Contributing](#contributing)

## Available Scripts

| Script | Description | Input | Output | Dependencies |
|--------|-------------|-------|--------|--------------|
| [`render_mermaid.sh`](render_mermaid.sh) | Render Mermaid diagram files to PNG or SVG format | `.mmd` files | PNG/SVG images | `curl`, Mermaid rendering server |
| [`svg2pdf.sh`](svg2pdf.sh) | Convert SVG files to PDF format using headless Chrome | SVG files | PDF files | Google Chrome/Chromium |

## render_mermaid.sh

A script to render Mermaid diagram files to PNG or SVG format.

### Features

- Render Mermaid diagram files (.mmd) to PNG or SVG format
- Support for custom output directories and filenames
- Configurable server URL for rendering service

### Usage

```bash
./render_mermaid.sh [options] MMD_FILE
```

### Arguments

- `MMD_FILE` - Path to the Mermaid script file

### Options

- `-t, --type TYPE` - Output type (png or svg) [default: png]
- `-o, --output-dir DIR` - Output directory [default: current directory]
- `-n, --name NAME` - Output filename (without extension)
- `-s, --server URL` - Server URL [default: http://localhost:80]
- `-h, --help` - Show help information

### Examples

```bash
# Basic usage
./render_mermaid.sh diagram.mmd

# Output SVG format to specified directory
./render_mermaid.sh -t svg -o output/ diagram.mmd

# Custom output filename
./render_mermaid.sh --name my_diagram --type png diagram.mmd
```

### Dependencies

- `curl` - For HTTP requests
- Running Mermaid rendering server

## svg2pdf.sh

A script to convert SVG files to PDF format using headless Chrome.

### Features

- Convert SVG files to PDF format
- High-quality PDF conversion using headless Chrome
- Support for custom Chrome/Chromium binary path

### Usage

```bash
./svg2pdf.sh input.svg output.pdf
```

### Arguments

- `input.svg` - Path to the input SVG file
- `output.pdf` - Path to the output PDF file

### Environment Variables

- `CHROME_BIN` - Optional, specify Chrome/Chromium binary path

### Examples

```bash
# Basic conversion
./svg2pdf.sh diagram.svg diagram.pdf

# Using custom Chrome path
CHROME_BIN=/usr/bin/google-chrome ./svg2pdf.sh diagram.svg diagram.pdf
```

### Dependencies

- Google Chrome or Chromium browser
- POSIX shell support

## Installation

1. Clone this repository:

```bash
git clone <repository-url>
cd mermaid-rendering-tools
```

2. Make the scripts executable:

```bash
chmod +x render_mermaid.sh svg2pdf.sh
```

## Workflow Example

Complete workflow from Mermaid to PDF conversion:

```bash
# 1. Render Mermaid file to SVG
./render_mermaid.sh -t svg diagram.mmd

# 2. Convert SVG to PDF
./svg2pdf.sh diagram.svg diagram.pdf
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Author

Peng Ding

## Contributing

Issues and Pull Requests are welcome to improve these tools.
