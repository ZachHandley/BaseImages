# BaseImages

Custom CI/CD base images built on Ubuntu 22.04, published to GitHub Container Registry.

## Available Images

| Profile | Image | Description |
|---------|-------|-------------|
| `base` | `ghcr.io/zachhandley/baseimages/base` | Ubuntu 22.04 + sudo, git, curl, build-essential |
| `node` | `ghcr.io/zachhandley/baseimages/node` | base + Node.js 22 LTS, pnpm, yarn |
| `rust` | `ghcr.io/zachhandley/baseimages/rust` | base + Rust stable, cargo-binstall, common tools |
| `node-rust` | `ghcr.io/zachhandley/baseimages/node-rust` | base + Node.js + Rust |
| `ci-full` | `ghcr.io/zachhandley/baseimages/ci-full` | base + Node.js + Rust + Python + Go |

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

### Docker

```bash
docker pull ghcr.io/zachhandley/baseimages/node:latest
docker run -it ghcr.io/zachhandley/baseimages/node:latest
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

## Image Tags

Each image is tagged with:
- `latest` - Most recent build
- `YYYY-MM-DD` - Date-based tag (e.g., `2025-01-18`)
- `sha-XXXXXXX` - Git commit SHA

## What's Included

### Base Image
- Ubuntu 22.04 LTS
- `sudo`, `git`, `git-lfs`, `curl`, `wget`
- `ca-certificates`, `gnupg`
- `build-essential`, `pkg-config`, `libssl-dev`
- `jq`, `unzip`, `zip`, `xz-utils`
- Non-root `runner` user with passwordless sudo

### Node Profile
Base image plus:
- Node.js 22 LTS (via NodeSource)
- npm, pnpm, yarn

### Rust Profile
Base image plus:
- Rust stable (via rustup)
- rustfmt, clippy
- cargo-binstall, cargo-watch, cargo-edit, cargo-audit

### Node-Rust Profile
Combination of Node and Rust profiles.

### CI-Full Profile
All tools:
- Node.js 22 LTS
- Rust stable
- Python 3 with pip, uv, poetry
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
