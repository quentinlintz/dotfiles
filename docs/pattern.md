# The pattern

Three ideas. Everything else is a detail you can look up.

---

## 1. Space is the leader everywhere

| Scope | Key | Governs |
|---|---|---|
| Inside the file | `Space` | text, LSP, git hunks |
| Around the file | `C-b Space` | panes, windows, sessions, agents |
| The system itself | `C-b ?` | this page |

One instinct, three scopes. Outside Neovim you prefix Space with `C-b`.

The two lowest scopes already rhyme, so don't learn them twice:

| | Neovim | tmux |
|---|---|---|
| split right | `<leader>\|` | `C-b \|` |
| split down | `<leader>-` | `C-b -` |
| lazygit | `<leader>gg` | `C-b g` |

---

## 2. Panes are for things you watch; popups are for things you do

A project window is **always** two panes and never grows a third:

```
┌──────────────────┬────────────┐
│       nvim       │   claude   │
└──────────────────┴────────────┘
```

`C-b G` builds it. Everything else floats on top and vanishes:

| Key | Popup |
|---|---|
| `C-b g` | lazygit |
| `C-b y` | yazi |
| `C-b t` | scratch shell: **builds, tests, one-off commands** |
| `C-b o` | session picker (sesh) |
| `C-b A` | worktree picker |
| `C-b ?` | this page |

If you catch yourself making a third pane for a test run, that's the habit this
is replacing. Use `C-b t`.

---

## 3. One agent, one worktree, one window

The claude in the right-hand pane is for the code in front of you. Anything
long-running gets its own checkout so the two can never fight over a file.

```
C-b a          name it, and a new window opens running
               claude --worktree <name>
C-b A          fuzzy-jump between the worktrees you have open
```

The worktree lands in `.claude/worktrees/<name>/` on branch `worktree-<name>`.
Claude cleans it up when you exit, and asks first if there's work in it.

A worktree is a fresh checkout, so **gitignored files are not in it**. A
missing `.env` is the first thing that will bite you. Put a `.worktreeinclude`
in the project root, `.gitignore` syntax, and Claude copies those files into
every worktree it makes:

```
.env
.env.local
```

`push.autoSetupRemote` is set in `config/git/config` so the first push from a
worktree branch doesn't stop to ask about `--set-upstream`.

---

## The front row

The ten keys that carry a normal day. Everything else is discoverable by
pressing `Space` and reading.

### Neovim

| Key | Does |
|---|---|
| `<leader><space>` | find file |
| `<leader>/` | grep the project |
| `<leader>,` | switch buffer |
| `<leader>e` | file explorer |
| `<leader>gg` | lazygit |
| `<leader>ca` | code action |
| `<leader>cr` | rename symbol |
| `gd` `gr` `K` | definition, references, hover |
| `<leader>as` | **send selection to claude** (visual mode) |
| `<leader>aa` / `<leader>ad` | accept / reject claude's diff |
| `<leader>um` | markdown: rendered ⇄ raw |
| `<leader>uz` | zen: reading mode |

`C-b G` starts the right-hand pane with `claude --ide` for you, so this just
works. Two things break it: starting claude by hand without `--ide`, or having
two Neovim instances open, since `--ide` only auto-connects when exactly one
editor is offering. In the second case run `/ide` in the claude pane and pick.

### tmux

| Key | Does |
|---|---|
| `C-b Space` | the menu, for when you've forgotten one of these |
| `C-b G` | build the workbench |
| `C-b h/j/k/l` | move between panes |
| `C-b z` | zoom a pane full-window, and back |
| `C-b Tab` | last window |
| `C-b c` | new window |
| `C-b d` | detach: the run keeps going without you |
| `C-b r` | reload this config |

### Shell

| Key | Does |
|---|---|
| `Ctrl-R` | atuin: search history, this directory first |
| `Up` | atuin: previous command from this directory |
| `Ctrl-o` | session picker, same as `C-b o` |
| `y` | yazi, and the shell follows you to wherever you quit |
| `git dt` | difftastic: diff by syntax, so a reformat shows as nothing |

---

## Adding a language

The base is deliberately language-neutral. When you want one:

**If LazyVim has an extra for it**, one line in `config/nvim/lazyvim.json`:

```json
{ "extras": ["lazyvim.plugins.extras.lang.python"] }
```

**If it doesn't**, a file in `config/nvim/lua/plugins/`, an `lspconfig` server
entry and a treesitter grammar:

```lua
return {
  { "neovim/nvim-lspconfig", opts = { servers = { svls = {} } } },
  { "nvim-treesitter/nvim-treesitter", opts = { ensure_installed = { "verilog" } } },
}
```

`config/nvim/lua/plugins/go.lua` is the worked example, and shows the one extra
thing worth knowing: when a tool's version has to match CI, mise pins it and
mason is told to skip it. Everything else, mason owns.
