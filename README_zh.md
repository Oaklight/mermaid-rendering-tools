# Mermaid Rendering Tools

[中文版](README_zh.md) | [English version](README_en.md)

一套用于渲染和转换Mermaid图表的Shell脚本工具集。

## 功能特性

- 将Mermaid图表文件（.mmd）渲染为PNG或SVG格式
- 将SVG文件转换为PDF格式
- 支持自定义输出目录和文件名
- 使用无头Chrome进行高质量的PDF转换

## 工具列表

### 1. render_mermaid.sh

将Mermaid图表文件渲染为PNG或SVG格式的脚本。

#### 使用方法

```bash
./render_mermaid.sh [选项] MMD_FILE
```

#### 参数

- `MMD_FILE` - Mermaid脚本文件路径

#### 选项

- `-t, --type TYPE` - 输出类型（png或svg）[默认: png]
- `-o, --output-dir DIR` - 输出目录 [默认: 当前目录]
- `-n, --name NAME` - 输出文件名（不含扩展名）
- `-s, --server URL` - 服务器URL [默认: http://localhost:80]
- `-h, --help` - 显示帮助信息

#### 示例

```bash
# 基本用法
./render_mermaid.sh diagram.mmd

# 输出SVG格式到指定目录
./render_mermaid.sh -t svg -o output/ diagram.mmd

# 自定义输出文件名
./render_mermaid.sh --name my_diagram --type png diagram.mmd
```

### 2. svg2pdf.sh

使用无头Chrome将SVG文件转换为PDF格式的脚本。

#### 使用方法

```bash
./svg2pdf.sh input.svg output.pdf
```

#### 参数

- `input.svg` - 输入的SVG文件路径
- `output.pdf` - 输出的PDF文件路径

#### 环境变量

- `CHROME_BIN` - 可选，指定Chrome/Chromium二进制文件路径

#### 示例

```bash
# 基本转换
./svg2pdf.sh diagram.svg diagram.pdf

# 使用自定义Chrome路径
CHROME_BIN=/usr/bin/google-chrome ./svg2pdf.sh diagram.svg diagram.pdf
```

## 依赖要求

### render_mermaid.sh

- `curl` - 用于HTTP请求
- 运行中的Mermaid渲染服务器

### svg2pdf.sh

- Google Chrome 或 Chromium 浏览器
- 支持POSIX shell

## 安装

1. 克隆此仓库：

```bash
git clone <repository-url>
cd mermaid-rendering-tools
```

2. 给脚本添加执行权限：

```bash
chmod +x render_mermaid.sh svg2pdf.sh
```

## 工作流程示例

完整的从Mermaid到PDF的转换流程：

```bash
# 1. 将Mermaid文件渲染为SVG
./render_mermaid.sh -t svg diagram.mmd

# 2. 将SVG转换为PDF
./svg2pdf.sh diagram.svg diagram.pdf
```

## 许可证

本项目采用MIT许可证 - 详见 [LICENSE](LICENSE) 文件。

## 作者

Peng Ding

## 贡献

欢迎提交Issue和Pull Request来改进这些工具。
