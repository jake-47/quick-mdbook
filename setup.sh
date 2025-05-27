#!/bin/bash

echo "🚀 Setting up mdBook documentation environment..."
echo ""

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install git based on OS
install_git() {
    echo "📦 Installing Git..."
    
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        if command_exists apt-get; then
            sudo apt-get update && sudo apt-get install -y git
        elif command_exists yum; then
            sudo yum install -y git
        elif command_exists dnf; then
            sudo dnf install -y git
        elif command_exists pacman; then
            sudo pacman -S --noconfirm git
        else
            echo "❌ Could not detect package manager. Please install git manually."
            exit 1
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        if command_exists brew; then
            brew install git
        else
            echo "❌ Homebrew not found. Installing Homebrew first..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            brew install git
        fi
    else
        echo "❌ Unsupported OS. Please install git manually."
        exit 1
    fi
}

# Check and install Git
if ! command_exists git; then
    echo "⚠️  Git not found."
    install_git
    echo "✅ Git installed successfully!"
else
    echo "✅ Git is already installed."
fi

# Check and install Rust
if ! command_exists cargo; then
    echo "⚠️  Rust/Cargo not found. Installing Rust..."
    curl https://sh.rustup.rs -sSf | sh -s -- -y
    
    # Source the cargo environment
    source ~/.cargo/env
    
    echo "✅ Rust installed successfully!"
else
    echo "✅ Rust is already installed."
fi

# Verify Rust installation
if ! command_exists cargo; then
    echo "❌ Rust installation failed. Please install manually from https://rustup.rs/"
    exit 1
fi

# Git configuration
echo ""
echo "🔧 Configuring Git..."

# Check if git is already configured
if ! git config --global user.name >/dev/null 2>&1; then
    echo "Git username not set."
    read -p "👤 Enter your Git username: " git_username
    git config --global user.name "$git_username"
fi

if ! git config --global user.email >/dev/null 2>&1; then
    echo "Git email not set."
    read -p "📧 Enter your Git email: " git_email
    git config --global user.email "$git_email"
fi

echo "✅ Git configured with:"
echo "   Username: $(git config --global user.name)"
echo "   Email: $(git config --global user.email)"

# Install mdBook itself
echo ""
echo "📚 Installing mdBook..."
if ! command_exists mdbook; then
    cargo install mdbook
    echo "✅ mdBook installed successfully!"
else
    echo "✅ mdBook is already installed."
fi

# Install mdBook plugins
echo ""
echo "🔌 Installing mdBook plugins..."
echo "   This may take several minutes..."

plugins=("mdbook-katex" "mdbook-admonish" "mdbook-mermaid" "mdbook-linkcheck")

for plugin in "${plugins[@]}"; do
    if ! command_exists "$plugin"; then
        echo "   Installing $plugin..."
        cargo install "$plugin"
    else
        echo "   ✅ $plugin already installed"
    fi
done

echo "✅ All plugins installed!"

# Initialize plugin assets (only if book.toml exists)
echo ""
if [ -f "book.toml" ]; then
    echo "🎨 Initializing plugin assets..."
    mdbook-admonish install .
    
    echo "🔨 Building documentation..."
    mdbook build
    
    echo "✅ Setup complete!"
    echo ""
    echo "🚀 Next steps:"
    echo "   mdbook serve                    # Start local server"
    echo "   mdbook build                    # Build static files"
    echo "   mdbook-linkcheck                # Validate links"
    echo ""
    echo "📖 Visit http://localhost:3000 after running 'mdbook serve'"
else
    echo "⚠️  No book.toml found in current directory."
    echo "   If you cloned a repository, cd into it first."
    echo "   If you're starting fresh, run: mdbook init"
    echo ""
    echo "✅ Environment setup complete!"
    echo "🔧 All tools installed and ready to use."
fi

# Set up git workflow scripts
echo ""
echo "⚙️  Setting up git workflow..."
if [ -d "scripts" ]; then
    # Make scripts executable
    chmod +x scripts/*.sh
    
    # Set up git aliases for daily workflow
    git config --local alias.daily '!./scripts/daily.sh'
    
    echo "✅ Git workflow configured!"
    echo "   Use: git daily"
else
    echo "⚠️  No scripts/ directory found - skipping workflow setup"
fi

echo "✅ Setup complete!"



echo "🚀 Setting up mdBook documentation environment..."
echo ""

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install git based on OS
install_git() {
    echo "📦 Installing Git..."
    
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        if command_exists apt-get; then
            sudo apt-get update && sudo apt-get install -y git
        elif command_exists yum; then
            sudo yum install -y git
        elif command_exists dnf; then
            sudo dnf install -y git
        elif command_exists pacman; then
            sudo pacman -S --noconfirm git
        else
            echo "❌ Could not detect package manager. Please install git manually."
            exit 1
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        if command_exists brew; then
            brew install git
        else
            echo "❌ Homebrew not found. Installing Homebrew first..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            brew install git
        fi
    else
        echo "❌ Unsupported OS. Please install git manually."
        exit 1
    fi
}

# Check and install Git
if ! command_exists git; then
    echo "⚠️  Git not found."
    install_git
    echo "✅ Git installed successfully!"
else
    echo "✅ Git is already installed."
fi

# Check and install Rust
if ! command_exists cargo; then
    echo "⚠️  Rust/Cargo not found. Installing Rust..."
    curl https://sh.rustup.rs -sSf | sh -s -- -y
    
    # Source the cargo environment
    source ~/.cargo/env
    
    echo "✅ Rust installed successfully!"
else
    echo "✅ Rust is already installed."
fi

# Verify Rust installation
if ! command_exists cargo; then
    echo "❌ Rust installation failed. Please install manually from https://rustup.rs/"
    exit 1
fi

# Git configuration
echo ""
echo "🔧 Configuring Git..."

# Check if git is already configured
if ! git config --global user.name >/dev/null 2>&1; then
    echo "Git username not set."
    read -p "👤 Enter your Git username: " git_username
    git config --global user.name "$git_username"
fi

if ! git config --global user.email >/dev/null 2>&1; then
    echo "Git email not set."
    read -p "📧 Enter your Git email: " git_email
    git config --global user.email "$git_email"
fi

echo "✅ Git configured with:"
echo "   Username: $(git config --global user.name)"
echo "   Email: $(git config --global user.email)"

# Install mdBook itself
echo ""
echo "📚 Installing mdBook..."
cargo install mdbook --force
echo "✅ mdBook installed successfully!"

# Install mdBook plugins
echo ""
echo "🔌 Installing mdBook plugins..."
echo "   This may take several minutes..."

plugins=("mdbook-katex" "mdbook-admonish" "mdbook-mermaid" "mdbook-linkcheck")

for plugin in "${plugins[@]}"; do
    if ! command_exists "$plugin"; then
        echo "   Installing $plugin..."
        cargo install "$plugin"
    else
        echo "   ✅ $plugin already installed"
    fi
done

echo "✅ All plugins installed!"

# Initialize plugin assets (only if book.toml exists)
echo ""
if [ -f "book.toml" ]; then
    echo "🎨 Initializing plugin assets..."
    mdbook-admonish install .
    
    echo "🔨 Building documentation..."
    mdbook build
    
    # Set up git workflow scripts
    echo ""
    echo "⚙️  Setting up git workflow..."
    if [ ! -d "scripts" ]; then
        mkdir -p scripts
        
        # Create daily.sh
        cat > scripts/daily.sh << 'EOFSCRIPT'
#!/bin/bash
DATE=$(date +%Y-%m-%d)

# Check if we're in a git repo
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo "❌ Not in a git repository"
    exit 1
fi

# Check if there are changes to commit
if git diff --quiet && git diff --staged --quiet; then
    echo "📭 No changes to commit today"
    exit 0
fi

# Stage all changes
git add .

# Get the last commit message
LAST_COMMIT_MSG=$(git log -1 --pretty=format:"%s" 2>/dev/null)

# Check if last commit is from today
if [[ "$LAST_COMMIT_MSG" == "$DATE"* ]]; then
    # Amend the existing commit (squash into today's commit)
    git commit --amend --no-edit
    echo "🔄 Updated today's commit: $DATE"
else
    # Create new commit for today
    git commit -m "$DATE"
    echo "✅ New daily commit created: $DATE"
fi
EOFSCRIPT

        # Create save.sh
        cat > scripts/save.sh << 'EOFSCRIPT'
#!/bin/bash
DATE=$(date +%Y-%m-%d)
git add .

if [ "$1" ]; then
    MSG="$DATE: $1"
else
    MSG="$DATE: Daily save"
fi

# Check if last commit is from today and is a daily commit
LAST_COMMIT_MSG=$(git log -1 --pretty=format:"%s" 2>/dev/null)

if [[ "$LAST_COMMIT_MSG" == "$DATE" ]] || [[ "$LAST_COMMIT_MSG" == "$DATE (session"* ]]; then
    # Replace today's basic daily commit with descriptive one
    git commit --amend -m "$MSG"
    echo "🔄 Updated today's commit: $MSG"
else
    # Create new commit
    git commit -m "$MSG"
    echo "✅ Commit created: $MSG"
fi
EOFSCRIPT

        # Create weekly.sh
        cat > scripts/weekly.sh << 'EOFSCRIPT'
#!/bin/bash
echo "📊 This week's commits:"
git log --oneline --since="1 week ago"
echo ""
echo "🚀 Pushing to remote..."
git push origin main
echo "✅ Weekly push complete!"
EOFSCRIPT

        echo "✅ Git workflow scripts created!"
    fi
    
    # Make scripts executable
    chmod +x scripts/*.sh
    
    # Set up git aliases for daily workflow
    git config --local alias.daily '!./scripts/daily.sh'
    git config --local alias.save '!./scripts/save.sh'
    git config --local alias.weekly '!./scripts/weekly.sh'
    
    echo "✅ Git workflow configured!"
    echo "   Use: git daily, git save 'message', git weekly"
    
    echo "✅ Setup complete!"
    echo ""
    echo "🚀 Next steps:"
    echo "   git daily                       # Quick daily commit"
    echo "   git save 'Added new section'    # Commit with message"
    echo "   git weekly                      # Review and push"
    echo "   mdbook serve                    # Start local server"
    echo "   mdbook build                    # Build static files"
    echo "   mdbook-linkcheck                # Validate links"
    echo ""
    echo "📖 Visit http://localhost:3000 after running 'mdbook serve'"
else
    echo "⚠️  No book.toml found in current directory."
    echo "   If you cloned a repository, cd into it first."
    echo "   If you're starting fresh, run: mdbook init"
    echo ""
    echo "✅ Environment setup complete!"
    echo "🔧 All tools installed and ready to use."
fi