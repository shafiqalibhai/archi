

# Archi - ArchiMate Modelling Editor

Archi® is a free, open source, cross-platform tool and editor to create ArchiMate models.

The Archi® modelling tool is targeted toward all levels of Enterprise Architects and Modellers. It provides a low cost to entry solution to users who may be making their first steps in the ArchiMate modelling language, or who are looking for a free, cross-platform ArchiMate modelling tool for their company or institution and wish to engage with the language within a TOGAF® or other Enterprise Architecture framework.

ArchiMate® is an open and independent Enterprise Architecture modelling language that supports the description, analysis and visualization of architecture within and across business domains. ArchiMate is one of the open standards hosted by The Open Group and is fully aligned with TOGAF®.

Archi website:

[https://www.archimatetool.com](https://www.archimatetool.com)

## Table of Contents

- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Build Targets](#build-targets)
- [Building Products](#building-products)
- [Platform-Specific Builds](#platform-specific-builds)
- [Development Workflow](#development-workflow)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)

## Prerequisites

Before building Archi, ensure you have the following installed:

- **Java Development Kit (JDK)** 17 or later
- **Maven** 3.8 or later
- **Git** for version control

Verify your environment:

```bash
make verify-env
```

## Quick Start

### Using Makefile (Recommended)

```bash
# Build all modules
make

# Quick build without running tests
make quick

# Run tests
make test

# Clean build artifacts
make clean
```

### Using Maven Directly

```bash
# Build all modules
mvn clean package

# Build with tests
mvn clean test

# Skip tests for faster build
mvn clean package -DskipTests
```

## Build Targets

| Target | Description | Command |
|--------|-------------|---------|
| `all` | Build all modules (default) | `make` |
| `build` | Compile all modules | `make build` |
| `product` | Build distributable products for all platforms | `make product` |
| `test` | Run all tests | `make test` |
| `quick` | Fast build without tests | `make quick` |
| `clean` | Remove build artifacts | `make clean` |
| `deps` | Download all dependencies | `make deps` |
| `validate` | Validate project structure | `make validate` |
| `verify-env` | Check build environment | `make verify-env` |
| `help` | Display help information | `make help` |

## Building Products

All product builds include a **bundled JRE** (Eclipse Temurin 21) by default, creating self-contained bundles that can run without a system Java installation.

To create distributable binaries for Windows, Linux, and macOS:

```bash
make product
```

This invokes Maven with the `product` profile:

```bash
mvn clean package -P product
```

### Output Location

Products are exported to:

```
com.archimatetool.editor.product/target/products/com.archimatetool.editor.product/
```

Platform-specific bundles:

- **Windows**: `win32/win32/x86_64/Archi/`
- **Linux**: `linux/gtk/x86_64/Archi/`
- **macOS Intel**: `macos/cocoa/x86_64/Archi/Archi.app`
- **macOS Apple Silicon**: `macos/cocoa/aarch64/Archi/Archi.app`

Each platform bundle includes a `jre/` folder:

```
Archi/
├── Archi.app/
│   └── Contents/
│       └── jre/          # Embedded JRE (macOS)
└── jre/                  # Embedded JRE (Linux/Windows)
```

### Bundled JRE Details

The build script automatically downloads Eclipse Temurin JRE 21 for each platform:

| Platform | Architecture | JRE Source |
|----------|--------------|------------|
| macOS | ARM64 (Apple Silicon) | Adoptium Temurin 21 |
| macOS | x86_64 (Intel) | Adoptium Temurin 21 |
| Linux | x86_64 | Adoptium Temurin 21 |
| Windows | x86_64 | Adoptium Temurin 21 |

**Requirements:**
- `curl` for downloading JRE archives
- `tar` and `unzip` for extraction

### Platform-Specific Builds

Build for a specific platform only:

```bash
# Windows only
make product-win

# Linux only
make product-linux

# macOS only
make product-mac
```

### Important Caveats

> **Note**: The public build has the following limitations:
>
> - The generated `Info.plist` file for macOS differs from the shipping version
> - macOS bundles are **not signed or notarised**
> - Windows executables are **not signed**
> - Documentation and other artefacts are not generated
>
> For production releases, additional signing and packaging steps are required.

## Development Workflow

### First-Time Setup

```bash
# Verify environment
make verify-env

# Download dependencies
make deps

# Initial build
make build
```

### Daily Development

```bash
# Quick build for testing changes
make quick

# Run tests before committing
make test

# Clean and rebuild
make clean build
```

### Working with Modules

Archi uses a multi-module Maven project structure. To build a specific module:

```bash
cd com.archimatetool.editor
mvn clean package
```

### Continuous Integration

For CI/CD pipelines:

```bash
# Non-interactive build with tests
mvn -B -V clean package -P tests

# Product build for all platforms
mvn -B -V clean package -P product
```

## Troubleshooting

### Common Issues

**Build fails with dependency errors:**

```bash
make clean deps build
```

**Out of memory during build:**

Increase Maven heap size:

```bash
export MAVEN_OPTS="-Xmx2g -XX:MaxMetaspaceSize=512m"
make build
```

**Tycho/Eclipse repository issues:**

Ensure you have internet connectivity. The build downloads Eclipse dependencies from:

```
https://download.eclipse.org/releases/2024-06
```

### Getting Help

- Check the [Developer Documentation](https://github.com/archimatetool/archi/wiki/Developer-Documentation)
- Review existing [GitHub Issues](https://github.com/archimatetool/archi/issues)
- Visit the [Archi Forum](https://forum.archimatetool.com)

## Contributing

### Contributing Code to Archi

Please see [How can I contribute code to Archi?](https://github.com/Phillipus/archi/wiki/How-can-I-contribute-code-to-Archi%3F)

### Development Guidelines

1. **Fork** the repository
2. **Create a branch** for your feature or bugfix
3. **Write tests** for new functionality
4. **Ensure all tests pass**: `make test`
5. **Build successfully**: `make build`
6. **Submit a Pull Request**

### Code Style

- Follow existing code conventions in the project
- Use Java code formatting standards
- Add meaningful commit messages

## License

Archi is released under an open source license. See the `License.txt` file for details.

## Acknowledgments

- ArchiMate® is a registered trademark of The Open Group
- TOGAF® is a registered trademark of The Open Group
- Eclipse® is a registered trademark of the Eclipse Foundation