# BaseImages

Custom CI/CD base images built on Ubuntu 22.04 and Alpine Linux, published to GitHub Container Registry.

## Available Images

| Profile | Image | Description |
|---------|-------|-------------|
| `base` | `ghcr.io/zachhandley/baseimages/base` | Ubuntu 22.04 + build tools, LLVM, Python 3, uv, db clients |
| `alpine` | `ghcr.io/zachhandley/baseimages/alpine` | Alpine Linux + build tools, Python 3, uv, db clients |
| `go-alpine` | `ghcr.io/zachhandley/baseimages/go-alpine` | alpine + Go 1.23 |
| `node-alpine` | `ghcr.io/zachhandley/baseimages/node-alpine` | alpine + Node.js 22 LTS, pnpm, yarn |
| `python-alpine` | `ghcr.io/zachhandley/baseimages/python-alpine` | alpine + poetry, black, ruff, mypy, pytest |
| `ruby-alpine` | `ghcr.io/zachhandley/baseimages/ruby-alpine` | alpine + Ruby 3.3, rbenv, bundler, ruby-lsp |
| `rust-alpine` | `ghcr.io/zachhandley/baseimages/rust-alpine` | alpine + Rust stable, cargo-binstall |
| `node` | `ghcr.io/zachhandley/baseimages/node` | base + Node.js 22 LTS, pnpm, yarn |
| `rust` | `ghcr.io/zachhandley/baseimages/rust` | base + Rust stable, cargo-binstall |
| `ruby` | `ghcr.io/zachhandley/baseimages/ruby` | base + Ruby 3.3, rbenv, bundler, ruby-lsp |
| `python` | `ghcr.io/zachhandley/baseimages/python` | base + poetry, black, ruff, mypy, pytest |
| `go` | `ghcr.io/zachhandley/baseimages/go` | base + Go 1.23 |
| `node-rust` | `ghcr.io/zachhandley/baseimages/node-rust` | base + Node.js + Rust |
| `dotnet` | `ghcr.io/zachhandley/baseimages/dotnet` | base + .NET 8 SDK |
| `node-dotnet` | `ghcr.io/zachhandley/baseimages/node-dotnet` | base + Node.js + .NET 8 |
| `cpp` | `ghcr.io/zachhandley/baseimages/cpp` | base + GCC, Clang, CMake, Ninja |
| `java` | `ghcr.io/zachhandley/baseimages/java` | base + OpenJDK 21, Maven, Gradle |
| `ci-full` | `ghcr.io/zachhandley/baseimages/ci-full` | base + Node + Rust + Python + Go |
| `db-clients` | `ghcr.io/zachhandley/baseimages/db-clients` | base + PostgreSQL, MySQL/MariaDB, Redis, SQLite, MongoDB shell |

## Usage

### GitHub Actions

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    container:
      image: ghcr.io/zachhandley/baseimages/node-rust:latest
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
docker pull ghcr.io/zachhandley/baseimages/node:latest
docker run -it ghcr.io/zachhandley/baseimages/node:latest
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
docker pull ghcr.io/zachhandley/baseimages/node-alpine:latest
docker run -it ghcr.io/zachhandley/baseimages/node-alpine:latest
```

## Add-Tools Action

Need additional packages? Use the `add-tools` action:

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    container:
      image: ghcr.io/zachhandley/baseimages/node-rust:latest
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
- **Utilities**: `jq`, `unzip`, `zip`, `xz-utils`, `zstd`
- **DB clients**: `postgresql-client`, `redis-tools`
- Non-root `runner` user with passwordless sudo

### Alpine Profile
Alpine Linux plus:
- Same tool categories as Ubuntu base (build tools, Python, DB clients)
- Uses `apk` package manager
- Smaller image size
- Better for minimal containers

**Alpine variants** are available for Go, Node.js, Python, Ruby, and Rust (e.g., `go-alpine`, `node-alpine`, `python-alpine`, `ruby-alpine`, `rust-alpine`). These provide the same language tooling as their Ubuntu-based counterparts but with significantly smaller image sizes.

### Node Profile
Base image plus:
- Node.js 22 LTS (via NodeSource)
- npm, pnpm, yarn

### Rust Profile
Base image plus:
- Rust stable (via rustup)
- rustfmt, clippy
- cargo-binstall

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

## Architecture Support

All images are built for:
- `linux/amd64` (x86_64)
- `linux/arm64` (aarch64)

## Building Locally

```bash
# Build a specific profile
docker build -f profiles/node/Dockerfile -t baseimages/node .

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
