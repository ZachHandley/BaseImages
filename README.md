# BaseImages

Custom CI/CD base images built on Ubuntu 22.04 and Alpine Linux, published to GitHub Container Registry.

## Available Images

| Profile | Image | Description |
|---------|-------|-------------|
| `base` | `ghcr.io/zachhandley/baseimages/base` | Ubuntu 22.04 + build tools, LLVM, Node.js 22, Bun, Python 3, uv, db clients |
| `alpine` | `ghcr.io/zachhandley/baseimages/alpine` | Alpine Linux + build tools, Node.js 22, Bun, Python 3, uv, db clients |
| `bun-ubuntu` | `ghcr.io/zachhandley/baseimages/bun-ubuntu` | base + Bun |
| `bun-alpine` | `ghcr.io/zachhandley/baseimages/bun-alpine` | alpine + Bun |
| `rust` | `ghcr.io/zachhandley/baseimages/rust` | base + Rust stable |
| `ruby` | `ghcr.io/zachhandley/baseimages/ruby` | base + Ruby 3.3, rbenv, bundler, ruby-lsp |
| `python` | `ghcr.io/zachhandley/baseimages/python` | base + poetry, black, ruff, mypy, pytest |
| `go` | `ghcr.io/zachhandley/baseimages/go` | base + Go 1.23 |
| `dotnet` | `ghcr.io/zachhandley/baseimages/dotnet` | base + .NET 8 SDK |
| `cpp` | `ghcr.io/zachhandley/baseimages/cpp` | base + GCC, Clang, CMake, Ninja |
| `java` | `ghcr.io/zachhandley/baseimages/java` | base + OpenJDK 21, Maven, Gradle |
| `ci-full` | `ghcr.io/zachhandley/baseimages/ci-full` | base + Node + Rust + Python + Go |
| `rust-uv` | `ghcr.io/zachhandley/baseimages/rust-uv` | base + Rust + Python dev headers + maturin |
| `flutter` | `ghcr.io/zachhandley/baseimages/flutter` | base + Flutter SDK |
| `rust-uv-flutter` | `ghcr.io/zachhandley/baseimages/rust-uv-flutter` | base + Rust + uv + Flutter |
| `db-clients` | `ghcr.io/zachhandley/baseimages/db-clients` | base + PostgreSQL, MySQL/MariaDB, Redis, SQLite, MongoDB shell |
| `go-alpine` | `ghcr.io/zachhandley/baseimages/go-alpine` | alpine + Go 1.23 |
| `python-alpine` | `ghcr.io/zachhandley/baseimages/python-alpine` | alpine + poetry, black, ruff, mypy, pytest |
| `ruby-alpine` | `ghcr.io/zachhandley/baseimages/ruby-alpine` | alpine + Ruby, bundler, ruby-lsp |
| `rust-alpine` | `ghcr.io/zachhandley/baseimages/rust-alpine` | alpine + Rust stable |

## Usage

### GitHub Actions

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    container:
      image: ghcr.io/zachhandley/baseimages/ci-full:latest
    steps:
      - uses: actions/checkout@v4
      - run: node --version
      - run: cargo --version
```

### Forgejo/Gitea Actions

```yaml
jobs:
  build:
    runs-on: docker
    container:
      image: ghcr.io/zachhandley/baseimages/ci-full:latest
    steps:
      - uses: actions/checkout@v4
      - run: |
          node --version
          cargo --version
          python3 --version
          go version
```

### Docker

```bash
docker pull ghcr.io/zachhandley/baseimages/base:latest
docker run -it ghcr.io/zachhandley/baseimages/base:latest
```

### Alpine Variants

Alpine-based images are smaller and use the `apk` package manager:

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    container:
      image: ghcr.io/zachhandley/baseimages/go-alpine:latest
    steps:
      - uses: actions/checkout@v4
      - run: go version
      - run: apk list  # View installed packages
```

```bash
docker pull ghcr.io/zachhandley/baseimages/alpine:latest
docker run -it ghcr.io/zachhandley/baseimages/alpine:latest
```

## Add-Tools Action

Need additional packages? Use the `add-tools` action:

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    container:
      image: ghcr.io/zachhandley/baseimages/ci-full:latest
    steps:
      - uses: actions/checkout@v4

      - uses: ZachHandley/BaseImages/add-tools@main
        with:
          apt: libfoo-dev libbar-dev    # apt packages (Ubuntu-based images)
          apk: libfoo-dev               # apk packages (Alpine-based images)
          npm: typescript eslint        # npm global packages
          cargo: cargo-watch tokei      # cargo packages
          pip: httpie pytest            # pip packages
          go: golang.org/x/tools/gopls@latest  # go packages
          dotnet: dotnet-ef             # dotnet global tools
```

## Image Tags

Each image is tagged with:
- `latest` - Most recent build
- `YYYY-MM-DD` - Date-based tag (e.g., `2025-01-18`)
- `sha-XXXXXXX` - Git commit SHA

## What's Included

### Ubuntu Base Image (Ubuntu profiles)
- Ubuntu 22.04 LTS
- `sudo`, `git`, `git-lfs`, `curl`, `wget`
- `ca-certificates`, `gnupg`, `lsb-release`
- **Build tools**: `build-essential`, `pkg-config`, `cmake`, `ninja-build`, `autoconf`, `automake`, `libtool`
- **LLVM toolchain**: `llvm`, `lld`, `clang`, `libclang-dev` (fast linking, bindgen support)
- **Libraries**: `libssl-dev`, `libsqlite3-dev`, `libffi-dev`, `libreadline-dev`, `libncurses-dev`, `libxml2-dev`, `libyaml-dev`
- **Python**: `python3`, `python3-pip`, `python3-venv`, `pipx`, `uv` (astral)
- **Node.js**: Node.js 22 LTS, npm, pnpm, yarn, bun
- **Utilities**: `jq`, `unzip`, `zip`, `xz-utils`, `zstd`
- **DB clients**: `postgresql-client`, `redis-tools`
- Non-root `runner` user with passwordless sudo

### Alpine Profile
Alpine Linux plus:
- Same tool categories as Ubuntu base (build tools, Python, DB clients)
- Node.js 22 LTS, npm, pnpm, yarn, bun
- Uses `apk` package manager
- Smaller image size
- Better for minimal containers

**Alpine variants** are available for Go, Python, Ruby, Rust, and Bun (e.g., `go-alpine`, `python-alpine`, `ruby-alpine`, `rust-alpine`, `bun-alpine`). These provide the same language tooling as their Ubuntu-based counterparts but with significantly smaller image sizes.

### Rust Profile
Base image plus:
- Rust stable (via system packages)
- rustfmt, clippy

### .NET Profile
Base image plus:
- .NET 8 SDK (LTS)
- dotnet CLI tools support

### C++ Profile
Base image plus:
- GCC, G++, GDB
- Clang, clang-format, clang-tidy
- CMake, Ninja, Meson
- ccache

### Java Profile
Base image plus:
- OpenJDK 21 (LTS)
- Maven
- Gradle 8.x

### Python Profile
Base image plus:
- `python3-dev` (for native extensions)
- Poetry (via pipx)
- Dev tools: black, ruff, mypy, pytest

### Ruby Profile
Base image plus:
- Ruby 3.3 (via rbenv)
- rbenv for version management
- Bundler and rake
- Dev tools: rspec, rubocop, pry, solargraph, ruby-lsp

### CI-Full Profile
All tools:
- Node.js 22 LTS
- Rust stable
- Python 3 with poetry, black, ruff, mypy
- Go 1.23

### Bun Profile
Base image plus:
- Bun runtime and package manager

### Rust + uv Profile
Base image plus:
- Rust stable (via system packages)
- `python3-dev` and `maturin` for pyo3 builds

### Flutter Profile
Base image plus:
- Flutter SDK (stable)

### Rust + uv + Flutter Profile
Base image plus:
- Rust stable (via system packages)
- `python3-dev` and `maturin`
- Flutter SDK (stable)


## Architecture Support

All images are built for:
- `linux/amd64` (x86_64)
- `linux/arm64` (aarch64)

## Building Locally

```bash
# Build a specific profile
docker build -f profiles/base/Dockerfile -t baseimages/base .

# Build with buildx for multi-arch
docker buildx build -f profiles/rust/Dockerfile \
  --platform linux/amd64,linux/arm64 \
  -t baseimages/rust .
```

## Triggering Builds

Builds are triggered automatically on:
- Push to `main` branch (when profiles/, scripts/, or workflow changes)
- Manual workflow dispatch (with optional profile selection)

## License

MIT License - See [LICENSE](LICENSE) for details.
