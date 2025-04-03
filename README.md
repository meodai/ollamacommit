# Ollama Git Commit

![Ollama Git Commit terminal demo](terminal.gif)

A smart Git hook that uses Ollama to automatically generate meaningful commit messages based on your staged changes.

## Features

- Automatically generates commit messages using Ollama's AI capabilities
- Works with any Ollama model (defaults to gemma3)
- Provides options to accept, edit, or reject the generated message
- Easy to install and configure
- Lightweight with minimal dependencies

## Requirements

- [Git](https://git-scm.com/)
- [Ollama](https://ollama.com/) - Make sure it's installed and working on your system
- Bash shell environment

## Installation

### Step 1: Clone or download this repository

```bash
git clone https://github.com/yourusername/ollama-git-commit.git
cd ollama-git-commit
```

### Step 2: Make the scripts executable

```bash
chmod +x ollamacommit.sh
chmod +x pre-commit.sh
```

### Step 3: Install the hook in your Git repository

There are two ways to install the hook:

#### Option A: Manual installation per repository

1. Copy the scripts to your Git repository:
   ```bash
   cp ollamacommit.sh /path/to/your/repo/
   cp pre-commit.sh /path/to/your/repo/.git/hooks/pre-commit
   ```

2. Make sure the hook is executable:
   ```bash
   chmod +x /path/to/your/repo/.git/hooks/pre-commit
   ```

#### Option B: Global installation for all repositories

1. Set up a global Git hooks directory:
   ```bash
   git config --global core.hooksPath ~/.git-hooks
   ```

2. Create the directory if it doesn't exist:
   ```bash
   mkdir -p ~/.git-hooks
   ```

3. Copy the scripts:
   ```bash
   cp ollamacommit.sh ~/.git-hooks/
   cp pre-commit.sh ~/.git-hooks/pre-commit
   ```

4. Make sure the hook is executable:
   ```bash
   chmod +x ~/.git-hooks/pre-commit
   ```

## Usage

1. Make changes to your code
2. Stage your changes with `git add .` (or stage specific files)
3. Start a commit with the special keyword "ollama":
   ```bash
   git commit -m "ollama"
   ```

4. The hook will:
   - Detect the "ollama" keyword
   - Generate a commit message based on your staged changes
   - Ask if you want to accept it (y), reject it (n), or edit it (e)

5. If you:
   - Accept it: The generated message will be used for your commit
   - Edit it: You can modify the suggested message
   - Reject it: You'll be prompted to enter your own message

### Generating a Short Commit Message

If you want a more concise commit message, add the word "short" after "ollama":

```bash
git commit -m "ollama short"
```

This will instruct Ollama to generate a briefer commit message.

### Customizing the AI Model

You can choose which Ollama model to use in three ways:

1. **Environment Variable (recommended)**: 
   Set the `OLLAMACOMMITMODEL` environment variable:
   ```bash
   export OLLAMACOMMITMODEL="llama3"
   ```
   Add this to your `.bashrc` or `.zshrc` for a permanent setting.

2. **Edit the Script**:
   Open `ollamacommit.sh` and modify the model setting near the top:
   ```bash
   # This line will use the environment variable if set, or fall back to "gemma3"
   OLLAMA_MODEL="${OLLAMACOMMITMODEL:-gemma3}"
   ```

3. **Temporary Override**:
   For a one-time use with a different model:
   ```bash
   OLLAMACOMMITMODEL="codellama" git commit -m "ollama"
   ```

## How It Works

1. The pre-commit hook checks if your commit message starts with "ollama"
2. If it does, it runs the ollamacommit.sh script
3. The script:
   - Verifies Ollama is installed
   - Gets your staged changes with `git diff --staged`
   - Sends those changes to Ollama with a prompt to generate a commit message
   - Returns the generated message
4. You decide whether to use, edit, or reject the message

## Troubleshooting

- **"Error: ollama is not installed"**: Make sure Ollama is installed and in your PATH
- **"No staged changes found"**: Run `git add` to stage your changes before committing
- **"Not inside a git repository"**: Make sure you're running the command from within a Git repository
- **"ollamacommit.sh script not found"**: Check the path to the script in your pre-commit hook

## Tips for Better Results

- Stage only related changes in a single commit for more focused commit messages
- For larger changes, consider making multiple smaller commits
- Different Ollama models may produce different quality messages; experiment to find what works best for your codebase
- The "short" option is great for simple changes or when you need concise messages

## License

[MIT License](LICENSE)

## Contributing

Contributions are welcome! Feel free to open issues or submit pull requests to improve this tool.