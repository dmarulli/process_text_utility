# Process Text

A macOS right-click menu utility that processes selected text using a local LLM (Ollama). Select text anywhere, describe how you want it transformed, and get the result in your clipboard.

![Process Text Demo](https://img.shields.io/badge/macOS-Service-blue)

## Features

- Appears in right-click menu when text is selected
- Natural language prompts (e.g., "make this formal", "fix grammar", "translate to Spanish")
- Runs locally with Ollama - no API keys or costs
- Results copied to clipboard

## Prerequisites

- macOS
- [Homebrew](https://brew.sh)
- [Ollama](https://ollama.ai)

## Installation

1. **Install Ollama and pull a model:**
   ```bash
   brew install ollama
   brew services start ollama
   ollama pull llama3.2
   ```

2. **Clone and install:**
   ```bash
   git clone https://github.com/dmarulli/process_text_utility.git
   cd process_text_utility
   ./install.sh
   ```

3. **Refresh the Services menu:**
   ```bash
   /System/Library/CoreServices/pbs -flush
   ```
   Or log out and back in.

## Usage

1. Select text in any application
2. Right-click → **Services** → **Process Text**
3. Enter your instruction (e.g., "summarize this", "make it shorter")
4. Result is copied to clipboard - just paste

## Keyboard Shortcut

You can assign a keyboard shortcut for faster access:

1. Open **System Settings** → **Keyboard** → **Keyboard Shortcuts**
2. Click **Services** in the sidebar
3. Scroll to **Text** → **Process Text**
4. Click "Add Shortcut" and press your desired keys

Suggested shortcuts:
- `⌃⌥P` (Ctrl+Option+P)
- `⌃⌥T` (Ctrl+Option+T)
- `⇧⌘P` (Shift+Cmd+P)

## Example Use Cases

| Prompt | Input | Output |
|--------|-------|--------|
| "add quotes" | `hello world` | `"hello world"` |
| "remove quotes" | `"hello world"` | `hello world` |
| "remove excess whitespace" | `hello    world` | `hello world` |
| "put in a tuple" | `foo`<br>`bar`<br>`baz` | `("foo", "bar", "baz")` |
| "fix grammar" | `their going to the store` | `they're going to the store` |
| "make formal" | `hey can u help me out` | `Hello, could you please assist me?` |
| "translate to Spanish" | `good morning` | `buenos días` |

## Troubleshooting

**"Ollama Not Running" error:**
```bash
brew services start ollama
```

**Service not appearing in menu:**
```bash
/System/Library/CoreServices/pbs -flush
```

**First-time permissions:**
macOS may ask for Automator/System Events permissions. Allow these in System Settings → Privacy & Security.

## Using a Different Model

Edit `~/Library/Scripts/ProcessText/process_text.sh` and change the model name:
```python
"model": "llama3.2",  # Change to gemma2:2b, phi3:mini, etc.
```

Smaller models (gemma2:2b, phi3:mini) are faster but less accurate.

## Uninstall

```bash
./uninstall.sh
```

## License

MIT
