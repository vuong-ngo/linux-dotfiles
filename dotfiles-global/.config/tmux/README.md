# 🗺️ Tmux Configuration (Vim-Mode & Pure Graphite Style)

A high-performance, minimalist Tmux configuration heavily optimized for **Neovim** integration and keyboard-driven workflows. It features a responsive dynamic status bar, seamless Vim navigation, and immediate keystroke execution.

---

## 🚀 Core Concept

To optimize ergonomics during long coding sessions, the default activation key (**Prefix**) has been remapped:
* **Default Prefix:** `Ctrl + b` ❌ (Disabled)
* **New Prefix:** `Ctrl + a`  (Much easier to reach, matches standard terminal layouts)

> 💡 **How to read shortcuts:** `Prefix, [Key]` means press `Ctrl + a`, release both keys, and then immediately press the next `[Key]`.

---

## ⌨️ Keybindings Manual (Comprehensive Guide)

### 1. Window & Session Management
Designed for large-scale workspace organization. Window indexing starts at `1` instead of `0` for direct layout alignment with your keyboard's number row.

| Keybinding | Action | Description |
| :--- | :--- | :--- |
| `Prefix, b` | Create New Window | Automatically opens the new window in the Current Working Directory (`cwd`). |
| `Prefix, B` | Create New Session | Instantly initializes a blank independent Tmux session. |
| `Prefix, (` | Previous Session | Switches to the previous active session. |
| `Prefix, )` | Next Session | Switches to the next active session. |

---

### 2. Pane Splitting, Navigation & Resizing
Divide and conquer your terminal real estate using standard Vim **H, J, K, L** layouts.

#### 🔸 Splitting Panes
* `Prefix, v` : Split pane **Vertically** (Side-by-side). Inherits the current workspace path.
* `Prefix, s` : Split pane **Horizontally** (Top-and-bottom). Inherits the current workspace path.
* `Prefix, |` : Split pane using the alternate layout switch.
* `Prefix, c` : Close/Kill the currently focused pane.

#### 🔸 Pane Navigation
You can switch focus between active panes using two methods. The `Alt` method bypasses the Prefix entirely for instant movement:

* **Method 1 (Alt-driven — No Prefix Required):**
    * `Alt + h` : Move to the Left pane
    * `Alt + l` : Move to the Right pane
    * `Alt + k` : Move to the Upper pane
    * `Alt + j` : Move to the Lower pane
* **Method 2 (Prefix-driven):**
    * Press `Prefix, h` / `j` / `k` / `l` to navigate in the corresponding directions.

#### 🔸 Pane Resizing
Press `Prefix` once, then press and hold **Shift + [H/J/K/L]**. The `-r` repeatable flag is enabled, allowing you to fine-tune the sizes by tapping the directions continuously without hitting the Prefix again.
* `Prefix, H` : Resize pane boundary to the Left (by 5 cells)
* `Prefix, L` : Resize pane boundary to the Right (by 5 cells)
* `Prefix, K` : Resize pane boundary Upward (by 5 cells)
* `Prefix, J` : Resize pane boundary Downward (by 5 cells)

---

### 3. Vim-Style Copy Mode & Clipboard
Full integration with system clipboards utilizing standard Vim navigation controls.

* **Enter Copy Mode:** Press `Prefix, v` (or the default `Prefix, [`).

Once the status bar at the top changes to the Purple **VISUAL** banner, use the following keys to browse buffer history and copy data:

| Keybinding | Action |
| :--- | :--- |
| `h`, `j`, `k`, `l` | Standard character-by-character navigation (Left, Down, Up, Right). |
| `u` / `d` | Scroll Up / Scroll Down by half a page (Fast history review). |
| `w` / `b` | Skip Forward / Backward by a full word. |
| `e` | Jump directly to the end of the current word. |
| `v` | Begin text selection (Behaves exactly like `v` in Vim Visual Mode). |
| `V` | Begin line selection (Behaves exactly like `V` in Vim Visual Line Mode). |
| `Ctrl + v` | Toggle rectangular block selection (Visual Block Mode). |
| `y` | **Yank (Copy)** selected text to the system clipboard and exit Copy Mode. |

---

### 4. System & Core Utilities
* `Prefix, r` : Hot-reload the `tmux.conf` configuration file without destroying active sessions. Triggers a transient `"Reloaded tmux config!"` notification message.
* **Full Mouse Support:** Enabled (`on`). You can natively scroll through log buffers, click to shift pane focus, or drag pane borders to resize layouts.
* **Instant Escape Response:** The key escape delay is bound directly to `0ms`, resolving lagging inputs when handling keystrokes in Neovim.

---

## 🎨 Dynamic Top Status Bar UI (Synchronized with Neovim Bufferline & Lualine)

The status bar is locked to the **Top** edge to avoid visual collision with Neovim’s bottom statuslines, styled 1-to-1 with Neovim’s **Bufferline (VS Code Flat Square Tabs)** and **Lualine Graphite Theme**:

* ⬜ **NORMAL:** Pure graphite white island (`NORMAL`, matching Neovim `normal.a` `#e4e4e7`).
* 🟨 **PREFIX:** Amber yellow alert island (`PREFIX`, matching Neovim `insert.a` `#f59e0b`).
* 🟪 **VISUAL:** Purple copy/visual mode island (`VISUAL`, matching Neovim `visual.a` `#c084fc`).
* 🖥️ **Session Badge:** Charcoal zinc island (`#S`, matching Neovim `section b` `#27272a`).
* 🗂️ **Bufferline-Synced Window Tabs:**
  * **Active:** Charcoal zinc surface (`#27272a`) with a Graphite White left accent indicator (`▎` `#e4e4e7`), bold stark white title (`#f4f4f5`), and a status dot (`●`) when the pane is zoomed.
  * **Inactive:** Pure terminal transparency (`bg=default`), subtle ash gray index (`#71717a`), and muted silver title (`#a1a1aa`).
* 🕒 **High-Contrast Connected Date & Time:** Seamless dual-tone monochrome block anchored at the top-right corner:
  * **Date:** Charcoal zinc block (`#27272a`) with bold white text (`%d/%m/%Y`).
  * **Clock:** Stark Graphite White block (`#e4e4e7`) with bold dark charcoal digits (`%H:%M`), creating a clean mirrored balance with the left-hand NORMAL badge.
