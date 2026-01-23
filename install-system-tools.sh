#!/bin/bash
set -e

# Get the directory where this script resides
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}" 2>/dev/null)" && pwd 2>/dev/null)" || SCRIPT_DIR=""
COMMON_DIR="$SCRIPT_DIR/../../common/scripts"

# Bootstrap: If running standalone (curl | bash), clone repo first
if [[ -z "$SCRIPT_DIR" ]] || [[ ! -d "$COMMON_DIR" ]]; then
    echo "=========================================="
    echo "  Standalone mode detected"
    echo "  Cloning ForgejoResources repository..."
    echo "=========================================="

    REPO_URL="https://forge.blackleafdigital.com/BlackLeafDigital/ForgejoResources.git"
    REPO_DIR="/opt/forgejo-runner/resources"

    # Check for git
    if ! command -v git &>/dev/null; then
        echo "ERROR: git is required. Please install git first."
        exit 1
    fi

    # Clone or update repo
    if [[ -d "$REPO_DIR/.git" ]]; then
        echo "Repository exists, updating..."
        git -C "$REPO_DIR" pull --ff-only 2>/dev/null || echo "Update failed, using existing"
    else
        echo "Cloning repository..."
        mkdir -p "$(dirname "$REPO_DIR")"
        git clone --depth 1 "$REPO_URL" "$REPO_DIR"
    fi

    # Re-exec from cloned repo (use bash explicitly since git clone doesn't preserve execute perms)
    exec bash "$REPO_DIR/ForgejoRunner/scripts/install-system-tools.sh" "$@"
fi

# Running from within repo structure - source common functions
COMMON_DIR="$(cd "$SCRIPT_DIR/../../common/scripts" && pwd)"
source "$COMMON_DIR/lib/common-functions.sh"

# Tool categories available
ALL_TOOLS="core,docker,dev,cloud,k8s,db,testing,java,dotnet,flutter"
SELECTED_TOOLS=""
INSTALL_ALL=1

# Show help message
show_help() {
    echo ""
    echo "=========================================="
    echo "  Forgejo Runner System Tools Installer"
    echo "=========================================="
    echo ""
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --tools TOOLS    Comma-separated list of tool categories to install"
    echo "  -h, --help       Show this help message"
    echo ""
    echo "Available tool categories:"
    echo "  core     - Core development tools (git, jq, curl, make, etc.)"
    echo "  docker   - Docker, Podman, Buildah, and container tools"
    echo "  dev      - Language runtimes (Node, Go, Rust, Python, Ruby, PHP)"
    echo "  cloud    - Cloud CLIs (AWS, Azure, GCP, DigitalOcean, Fly.io)"
    echo "  k8s      - Kubernetes tools (kubectl, helm, kind, k9s)"
    echo "  db       - Database clients (MySQL, PostgreSQL, Redis, MongoDB)"
    echo "  testing  - Testing and security tools (shellcheck, trivy, browsers)"
    echo "  java     - Java JDK and Maven"
    echo "  dotnet   - .NET SDK"
    echo "  flutter  - Flutter SDK"
    echo ""
    echo "Examples:"
    echo "  $0                          # Install all tools (default)"
    echo "  $0 --tools core,docker,dev  # Install only core, docker, and dev tools"
    echo ""
}

# Parse command-line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --tools)
            if [[ -z "$2" ]]; then
                log_error "Missing value for --tools"
                show_help
                exit 1
            fi
            SELECTED_TOOLS="$2"
            INSTALL_ALL=0
            shift 2
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            log_error "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
done

# Function to check if a tool should be installed
should_install() {
    local tool=$1
    if [[ $INSTALL_ALL -eq 1 ]]; then
        return 0
    fi
    # Check if tool is in the comma-separated list
    echo "$SELECTED_TOOLS" | grep -qw "$tool"
}

# Print installation banner and plan
print_banner() {
    echo ""
    echo "=========================================="
    echo "  Forgejo Runner System Tools Installer"
    echo "  Using Modular Architecture"
    if [[ "$OS" == "macos" ]]; then
        echo "  Mode: macOS (current user)"
    else
        echo "  Mode: Linux (root)"
    fi
    echo "=========================================="
    echo ""

    if [[ $INSTALL_ALL -eq 1 ]]; then
        log_info "Installation plan: ALL TOOLS"
    else
        log_info "Installation plan: $SELECTED_TOOLS"
    fi
    echo ""
}

# Print installation summary
print_summary() {
    echo ""
    echo "=========================================="
    log_success "Installation Complete!"
    echo "=========================================="
    echo ""

    log_info "Summary of installed tools:"
    echo ""

    if should_install "core"; then
        echo "  Core Tools:"
        echo "    - git, git-lfs, gh (GitHub CLI)"
        echo "    - jq, yq, curl, wget"
        echo "    - Build tools: make, cmake, gcc"
        echo ""
    fi

    if should_install "docker"; then
        echo "  Container Tools:"
        command -v docker &>/dev/null && echo "    - Docker: $(docker --version 2>/dev/null | head -n1)"
        command -v podman &>/dev/null && echo "    - Podman: $(podman --version 2>/dev/null)"
        command -v buildah &>/dev/null && echo "    - Buildah: $(buildah --version 2>/dev/null)"
        echo ""
    fi

    if should_install "dev"; then
        echo "  Language Runtimes:"
        command -v node &>/dev/null && echo "    - Node.js: $(node --version 2>/dev/null)"
        command -v go &>/dev/null && echo "    - Go: $(go version 2>/dev/null | awk '{print $3}')"
        command -v rustc &>/dev/null && echo "    - Rust: $(rustc --version 2>/dev/null | awk '{print $2}')"
        command -v python3 &>/dev/null && echo "    - Python: $(python3 --version 2>/dev/null | awk '{print $2}')"
        command -v php &>/dev/null && echo "    - PHP: $(php --version 2>/dev/null | head -n1 | awk '{print $2}')"
        command -v ruby &>/dev/null && echo "    - Ruby: $(ruby --version 2>/dev/null | awk '{print $2}')"
        echo ""
    fi

    if should_install "cloud"; then
        echo "  Cloud CLIs:"
        command -v aws &>/dev/null && echo "    - AWS CLI"
        command -v gcloud &>/dev/null && echo "    - Google Cloud SDK"
        command -v az &>/dev/null && echo "    - Azure CLI"
        command -v doctl &>/dev/null && echo "    - DigitalOcean CLI"
        command -v flyctl &>/dev/null && echo "    - Fly.io CLI"
        echo ""
    fi

    if should_install "k8s"; then
        echo "  Kubernetes Tools:"
        command -v kubectl &>/dev/null && echo "    - kubectl"
        command -v helm &>/dev/null && echo "    - Helm"
        command -v kind &>/dev/null && echo "    - kind"
        command -v k9s &>/dev/null && echo "    - k9s"
        echo ""
    fi

    if should_install "db"; then
        echo "  Database Clients:"
        command -v mysql &>/dev/null && echo "    - MySQL client"
        command -v psql &>/dev/null && echo "    - PostgreSQL client"
        command -v redis-cli &>/dev/null && echo "    - Redis CLI"
        command -v mongosh &>/dev/null && echo "    - MongoDB shell"
        echo ""
    fi

    if should_install "testing"; then
        echo "  Testing & Security Tools:"
        command -v shellcheck &>/dev/null && echo "    - ShellCheck"
        command -v hadolint &>/dev/null && echo "    - Hadolint"
        command -v trivy &>/dev/null && echo "    - Trivy"
        command -v cosign &>/dev/null && echo "    - Cosign"
        echo ""
    fi

    if should_install "java" && command -v java &>/dev/null; then
        echo "  Java:"
        echo "    - Java: $(java -version 2>&1 | head -n1 | awk -F '"' '{print $2}')"
        command -v mvn &>/dev/null && echo "    - Maven"
        echo ""
    fi

    if should_install "dotnet" && command -v dotnet &>/dev/null; then
        echo "  .NET:"
        echo "    - .NET SDK: $(dotnet --version 2>/dev/null)"
        echo ""
    fi

    if should_install "flutter" && command -v flutter &>/dev/null; then
        echo "  Flutter:"
        echo "    - Flutter: $(flutter --version 2>/dev/null | head -n1 | awk '{print $2}')"
        echo ""
    fi

    # Platform-specific instructions
    if [[ "$OS" == "macos" ]]; then
        log_warn "macOS Instructions:"
        echo "  - If the forgejo-runner service is managed by launchd, restart it with:"
        echo "    launchctl stop com.forgejo.runner"
        echo "    launchctl start com.forgejo.runner"
        echo ""
    else
        log_warn "Post-Installation Steps:"
        echo "  1. If the forgejo-runner service is running, restart it:"
        echo "     sudo systemctl restart forgejo-runner"
        echo ""
        echo "  2. Verify the runner user has access to Docker:"
        echo "     sudo -u $RUNNER_USER docker ps"
        echo ""
        echo "  3. Check the environment file was created:"
        echo "     cat /etc/forgejo-runner/env"
        echo ""
        echo "  4. Verify Homebrew is working for the runner user:"
        echo "     sudo -u $RUNNER_USER /home/linuxbrew/.linuxbrew/bin/brew --version"
        echo ""
        echo "  5. Test SSH access (forgejo-runner to root@localhost):"
        echo "     sudo -u $RUNNER_USER ssh root@localhost whoami"
        echo ""
    fi

    log_success "All tools installed successfully!"
    log_info "Homebrew packages installed for user: $RUNNER_USER"
    if [[ "$OS" != "macos" ]]; then
        log_info "You may need to log out and back in for group changes to take effect"
    fi
    echo ""
}

# Main function
main() {
    # Initialize common variables and detect system
    init_common

    # Print banner
    print_banner

    # Check privileges (root on Linux, non-root on macOS)
    require_privileges

    log_info "Starting installation for $OS $VERSION on $ARCH..."
    echo ""

    # Always run setup (creates user, installs Homebrew)
    log_info "Running prerequisite setup..."
    bash "$COMMON_DIR/setup/setup-user.sh"
    bash "$COMMON_DIR/setup/setup-homebrew.sh"
    echo ""

    # Install selected tool categories
    if should_install "core"; then
        log_info "Installing core tools..."
        bash "$COMMON_DIR/tools/install-core.sh"
        echo ""
    fi

    if should_install "docker"; then
        log_info "Installing Docker and container tools..."
        bash "$COMMON_DIR/tools/install-docker.sh"
        echo ""
    fi

    if should_install "dev"; then
        log_info "Installing development tools..."
        bash "$COMMON_DIR/tools/install-dev.sh"
        echo ""
    fi

    if should_install "cloud"; then
        log_info "Installing cloud CLIs..."
        bash "$COMMON_DIR/tools/install-cloud.sh"
        echo ""
    fi

    if should_install "k8s"; then
        log_info "Installing Kubernetes tools..."
        bash "$COMMON_DIR/tools/install-k8s.sh"
        echo ""
    fi

    if should_install "db"; then
        log_info "Installing database clients..."
        bash "$COMMON_DIR/tools/install-db.sh"
        echo ""
    fi

    if should_install "testing"; then
        log_info "Installing testing and security tools..."
        bash "$COMMON_DIR/tools/install-testing.sh"
        echo ""
    fi

    if should_install "java"; then
        log_info "Installing Java and Maven..."
        bash "$COMMON_DIR/tools/install-java.sh"
        echo ""
    fi

    if should_install "dotnet"; then
        log_info "Installing .NET SDK..."
        bash "$COMMON_DIR/tools/install-dotnet.sh"
        echo ""
    fi

    if should_install "flutter"; then
        log_info "Installing Flutter SDK..."
        bash "$COMMON_DIR/tools/install-flutter.sh"
        echo ""
    fi

    # Print summary
    print_summary
}

# Run main function
main "$@"
