```
 ██████╗ ██████╗ ██████╗ ███████╗
██╔════╝██╔═══██╗██╔══██╗██╔════╝
██║     ██║   ██║██║  ██║█████╗
██║     ██║   ██║██║  ██║██╔══╝
╚██████╗╚██████╔╝██████╔╝███████╗
 ╚═════╝ ╚═════╝ ╚═════╝ ╚══════╝
██████╗ ███████╗██╗   ██╗██╗███████╗██╗    ██╗
██╔══██╗██╔════╝██║   ██║██║██╔════╝██║    ██║
██████╔╝█████╗  ██║   ██║██║█████╗  ██║ █╗ ██║
██╔══██╗██╔══╝  ╚██╗ ██╔╝██║██╔══╝  ██║███╗██║
██║  ██║███████╗ ╚████╔╝ ██║███████╗╚███╔███╔╝
╚═╝  ╚═╝╚══════╝  ╚═══╝  ╚═╝╚══════╝ ╚══╝╚══╝
```

# harbor.nvim

## Review pull requests and merge requests without leaving Neovim

https://github.com/user-attachments/assets/e805a264-edf7-47ab-ab4d-5a2361826131

> **Note: This project is in active development.** Core features are operational, but some areas are still being refined.

## Features

- **GitHub + GitLab** — auto-detects provider from git remote

## Installation

### lazy.nvim

```lua
{
  "neio-dev/harbor.nvim",
  opts = {},
}
```

### packer.nvim

```lua
use {
  "afewyards/codereview.nvim",
  requires = { "nvim-lua/plenary.nvim" },
  config = function()
    require("codereview").setup()
  end,
}
```

## Quick Start

-- keybinds 

## Plugin Configuration

```lua
require("harbor").setup({
  -- Provider settings (all auto-detected from git remote)
  base_url = nil,       -- API base URL override
  project  = nil,       -- "owner/repo" override
  platform = nil,       -- "github" | "gitlab" | nil (auto-detect)
  github_token = nil,   -- GitHub personal access token
  gitlab_token = nil,   -- GitLab personal access token

  -- Picker: "telescope", "fzf", or "snacks" (auto-detected)
  picker = nil,

  -- Diff viewer
  diff = {
    context          = 8,   -- lines of context (0-20)
    scroll_threshold = 50,  -- use scroll mode when file count <= threshold
  },

  -- AI review (requires Claude CLI)
  ai = {
    enabled   = true,
    claude_cmd = "claude",
    agent      = "code-review",
  },

  -- Override or disable keybindings
  keymaps = {
    -- quit = "q",          -- remap quit to q
    -- toggle_resolve = false,  -- disable toggle resolve
  },
})
```

## Default Keymaps

### Navigation

| Key | Action |
|-----|--------|
| `]f` / `[f` | Next / previous file |
| `]c` / `[c` | Next / previous comment |
| `]s` / `[s` | Next / previous AI suggestion |

### Comments & Discussions

| Key | Action |
|-----|--------|
| `cc` | New comment (normal mode) |
| `cc` | Range comment (visual mode) |
| `r` | Reply to thread |
| `gt` | Toggle resolve / unresolve |

### Comments & Notes

| Key | Action |
|-----|--------|
| `<Tab>` / `<S-Tab>` | Select next / previous note |
| `e` | Edit selected note |
| `x` | Delete selected note |

### AI Suggestions

| Key | Action |
|-----|--------|
| `A` | Start / cancel AI review |
| `a` | Accept suggestion |
| `x` | Dismiss suggestion |
| `e` | Edit suggestion |
| `ds` | Dismiss all suggestions |

### View Controls

| Key | Action |
|-----|--------|
| `+` / `-` | Increase / decrease context lines |
| `<C-f>` | Toggle full file view |
| `<C-a>` | Toggle scroll / per-file mode |

### Actions

| Key | Action |
|-----|--------|
| `S` | Submit draft comments |
| `a` | Approve MR/PR |
| `m` | Merge |
| `o` | Open in browser |
| `p` | Show pipeline status |
| `R` | Refresh |
| `Q` | Quit |

All keymaps can be remapped or disabled via the `keymaps` option in `setup()`.

## Commands

| Command | Description |
|---------|-------------|
| `:CodeReview` | Open review picker |
| `:CodeReviewAI` | Run AI review on current diff |
| `:CodeReviewStart` | Start manual review session (comments become drafts) |
| `:CodeReviewSubmit` | Submit draft comments |
| `:CodeReviewApprove` | Approve current MR/PR |
| `:CodeReviewOpen` | Create new MR/PR |

## Supported Providers

| Provider | Reviews | Comments | Resolve | AI Review | Create MR/PR |
|----------|---------|----------|---------|-----------|-------------|
| GitLab | Yes | Yes | Yes | Yes | Yes |
| GitHub | Yes | Yes | Yes | Yes | Yes |

Provider is auto-detected from the git remote URL. Use `platform = "github"` or `platform = "gitlab"` to override.

## License

MIT

