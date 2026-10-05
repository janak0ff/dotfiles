# omarchy-ascii

A self-contained command-line tool that renders any text as ASCII art in
**Delta Corps Priest 1** — the exact FIGlet font Omarchy uses for its own
wordmark — and writes it straight into the files Omarchy reads for your
screensaver, About window, and terminal welcome banner.

It exists to fill a gap: `omarchy ascii "text"` ships on Omarchy's newer
`quattro` branch but isn't on every release channel yet. This script gives
you the same result today, on any channel, with the font embedded so it
works offline.

---

## The three surfaces you can brand

Omarchy shows your logo in three separate places. They are **not** all
controlled the same way — this is the single most important thing to
understand before you start:

| Surface | Controlled by | How to change it |
|---|---|---|
| Screensaver | `~/.config/omarchy/branding/screensaver.txt` | `omarchy-ascii "TEXT" --to screensaver` |
| About window **and** terminal banner (fastfetch) | `~/.config/omarchy/branding/about.txt` | `omarchy-ascii "TEXT" --to about` |
| Boot splash **and** SDDM login screen | A PNG image, via Plymouth | `omarchy plymouth set ...` (built-in, not this script) |

Two things that trip people up:

- **The About window and your terminal banner are the same file.** Omarchy's
  fastfetch setup already points at `about.txt`. You do **not** need a
  `~/.config/fastfetch/config.jsonc`, and you do **not** need a
  `~/.config/fastfetch/logos/` folder. Writing to `about.txt` is the whole job.
- **The boot splash is an image, not text.** No amount of ASCII art will
  change it. It needs a PNG and Omarchy's own `omarchy plymouth` commands.

---

## Included: a ready-made JANAK logo

`janak-logo.png` in this download is a clean, transparent-background
rendering of "JANAK", sized and colored for use with `omarchy plymouth`.
Use it for the boot splash step below, or make your own.

---

## Requirements

- `figlet` — install it up front:
  ```bash
  sudo pacman -S figlet
  ```
  (The script will also try to install it automatically on first run.)
- An Omarchy installation, for the `--to screensaver` / `--to about`
  destinations. The script works standalone otherwise.

---

## Installation

1. **Install figlet** (see above).

2. **Create a personal bin folder:**
   ```bash
   mkdir -p ~/bin
   ```

3. **Move the script in and make it executable:**
   ```bash
   mv ~/Downloads/omarchy-ascii ~/bin/
   chmod +x ~/bin/omarchy-ascii
   ```
   If you're upgrading from an older copy, this overwrites it — that's
   intended.

4. **Put `~/bin` at the front of your `PATH`.** Check which shell you're
   actually running first, because the config file depends on it:
   ```bash
   echo $SHELL
   ```
   - Prints `.../zsh`:
     ```bash
     echo 'export PATH="$HOME/bin:$PATH"' >> ~/.zshrc
     ```
   - Prints `.../bash`:
     ```bash
     echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
     ```

   Optionally add the same line to `~/.config/uwsm/env` so it applies to
   things launched from the Omarchy menu too.

5. **Start a clean shell:**
   ```bash
   exec $SHELL
   ```
   Don't use `source` — sourcing `~/.bashrc` while running zsh throws a wall
   of `command not found: shopt` / `complete` / `bind` errors, because bash
   and zsh don't share builtins. `exec $SHELL` restarts the shell you're
   actually in.

6. **Verify:**
   ```bash
   which omarchy-ascii
   ```
   Should print a path ending in `/bin/omarchy-ascii`.

7. **Confirm you have the current version** (has the corrected fastfetch
   handling):
   ```bash
   omarchy-ascii --help | grep -c "SAME file"
   ```
   Should print `1`. If it prints `0`, you're still on an older copy —
   redo step 3.

---

## Usage

```
omarchy-ascii "TEXT" [--to screensaver|about|fastfetch|PATH] [--preview]
omarchy-ascii -h | --help
```

### Print to terminal

```bash
omarchy-ascii "JANAK"
```

Renders to stdout. Nothing is saved.

### Set your terminal banner + About window

```bash
omarchy-ascii "JANAK" --to about
fastfetch
```

Writes `~/.config/omarchy/branding/about.txt`. Run `fastfetch` or open a new
terminal to see it. `--to fastfetch` is an alias for this and does exactly
the same thing.

### Set your screensaver

```bash
omarchy-ascii "JANAK" --to screensaver
```

Writes `~/.config/omarchy/branding/screensaver.txt`. This is a separate file
from the About/banner one, so the two can differ — run both commands if you
want them to match.

### Write to a custom file

```bash
omarchy-ascii "JANAK" --to ~/art.txt
```

Parent directories are created automatically.

### Multi-word text

```bash
omarchy-ascii "BACK IN FIVE" --to screensaver
```

---

## Options reference

| Flag | Description |
|---|---|
| `TEXT` | Text to render. Required, positional. Quote it if it has spaces. |
| `--to screensaver` | Write to the screensaver file. |
| `--to about` | Write to the About / fastfetch banner file. |
| `--to fastfetch` | Alias for `--to about` — same file. |
| `--to PATH` | Write to any custom path. |
| `--preview` | After writing, attempt to launch the screensaver. |
| `-h`, `--help` | Show usage and exit. |

---

## Boot splash & login screen (Plymouth)

This is **not** handled by `omarchy-ascii` — it's image-based and Omarchy
has built-in commands for it.

1. **Preview first**, with your own colors and logo. Note the argument
   order: background hex, text hex, input logo, output preview path.
   ```bash
   omarchy plymouth preview '#1d2021' '#ebdbb2' ~/Downloads/janak-logo.png ~/plymouth-preview.png
   ```
   Write the preview into your **home folder**, not `/tmp`. Using a `/tmp`
   path produces a harmless but confusing
   `gio: Trashing on system internal mounts is not supported` message,
   because the preview step tries to clear the old file via the trash and
   tmpfs doesn't support that.

   Run this as yourself, not under `sudo`. Root has no access to your
   desktop session's X11/Wayland display authority, so the preview window
   can't open — you'll see `Authorization required, but no authorization
   protocol specified` and `Failed to create window`.

2. **Look at it:**
   ```bash
   xdg-open ~/plymouth-preview.png
   ```

3. **Apply it** once you're happy:
   ```bash
   omarchy plymouth set '#1d2021' '#ebdbb2' ~/Downloads/janak-logo.png
   ```
   This asks for your sudo password and then rebuilds your unified kernel
   image and bootloader entry — you'll see `mkinitcpio` output, hook lines,
   and finally something like `Updated: /boot/limine.conf`. That output is
   normal and means it worked. Any `Possibly missing firmware for module`
   warnings are unrelated to this change and safe to ignore.

   One command updates **both** the boot splash and the SDDM login screen.

   Run this as yourself too — never prefix it with `sudo`, and never wrap
   it inside a broader `sudo bash << EOF ... EOF` block along with other
   commands. It elevates internally exactly when it needs to; running the
   whole thing as root instead makes it refuse with
   `Error: run omarchy-plymouth-set as your user, not under sudo.`

4. **Reboot to see it:**
   ```bash
   reboot
   ```
   The change is staged into the boot image, so it will not appear until
   you actually reboot.

5. **Revert any time:**
   ```bash
   omarchy plymouth reset
   ```

Swap `#1d2021` (background) and `#ebdbb2` (logo/text) for whatever colors
you want — those are just the values from Omarchy's own example.

### Generating your own PNG logo (optional)

`janak-logo.png` is ready to use as-is. If you'd rather render a different
word or tweak the colors, Pillow can do it in a few lines:

```bash
sudo pacman -S python-pillow ttf-dejavu
fc-list | grep -i dejavu   # confirm the real path on your system first
```

```bash
python3 << 'PYTHON'
from PIL import Image, ImageDraw, ImageFont
import os

text = "JANAK"
font_path = "/usr/share/fonts/TTF/DejaVuSans-Bold.ttf"  # from fc-list above
bg = (13, 11, 12, 255)
fg = (192, 202, 245, 255)
font_size = 400
font = ImageFont.truetype(font_path, font_size)

tmp = Image.new("RGBA", (10, 10))
bbox = ImageDraw.Draw(tmp).textbbox((0, 0), text, font=font)
w, h = bbox[2] - bbox[0], bbox[3] - bbox[1]
pad = int(font_size * 0.3)

canvas = Image.new("RGBA", (w + pad * 2, h + pad * 2), bg)
ImageDraw.Draw(canvas).text((pad - bbox[0], pad - bbox[1]), text, font=font, fill=fg)
canvas.save(os.path.expanduser("~/my-logo.png"))
print("Saved: ~/my-logo.png")
PYTHON
```


```bash
sudo bash << 'EOF'
# Generate solid-background logo with matching colors
python3 << 'PYTHON'
from PIL import Image, ImageDraw, ImageFont
import os

text = "JANAK"
font_path = "/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf"
bg = (13, 11, 12, 255)      # dark #0c0b0c (matches your Limine theme)
fg = (192, 202, 245, 255)   # light #c0caf5

font_size = 400
font = ImageFont.truetype(font_path, font_size)

tmp_img = Image.new("RGBA", (10, 10))
tmp_draw = ImageDraw.Draw(tmp_img)
bbox = tmp_draw.textbbox((0, 0), text, font=font)
w = bbox[2] - bbox[0]
h = bbox[3] - bbox[1]

pad = int(font_size * 0.3)
canvas = Image.new("RGBA", (w + pad * 2, h + pad * 2), bg)
draw = ImageDraw.Draw(canvas)
draw.text((pad - bbox[0], pad - bbox[1]), text, font=font, fill=fg)

path = os.path.expanduser("~/janak-solid.png")
canvas.save(path)
print(f"Saved: {path}")
PYTHON

# Apply it to Plymouth
omarchy plymouth set '#0c0b0c' '#c0caf5' ~/janak-solid.png

# Update Limine bootloader menu text
sed -i 's/interface_branding: Omarchy Bootloader/interface_branding: JANAK Bootloader/' /boot/limine.conf

# Update system name in fastfetch
sed -i 's/^NAME="Omarchy"/NAME="JANAK"/' /etc/os-release

echo "=== Done. All three places updated ==="
echo "Reboot to see the changes take effect:"
echo "  reboot"
EOF
```


Two Arch-specific gotchas: plain `pip install pillow` hits an "externally
managed environment" error — use `pacman` instead. And DejaVu's font path
on Arch (`/usr/share/fonts/TTF/...`) is not the same as on Debian/Ubuntu
(`/usr/share/fonts/truetype/dejavu/...`) — always confirm with `fc-list`
rather than assuming the path. Run this block as yourself, same as the
`omarchy plymouth` commands above.

---

## How it works

- On first run, the script extracts its embedded, base64-encoded copy of the
  `Delta Corps Priest 1` FIGlet font to
  `~/.cache/omarchy-ascii/delta-corps-priest-1.flf` and reuses it thereafter.
- It runs `figlet -f <cached-font> -- "TEXT"` and prints or writes the result.
- If `figlet` is missing it tries `omarchy-pkg-install`, then `pacman`, then
  `yay`.

Nothing here touches the network at runtime.

---

## Troubleshooting

**Pasting the ASCII art into the terminal gives `command not found: ███`**
You pasted the *output* instead of running a command. The shell tried to
execute each line. Run the `omarchy-ascii` command itself — it generates the
art for you.

**`fastfetch` still shows the default Omarchy logo**
Make sure you wrote to the right file — it's `about.txt`, not a fastfetch
config:
```bash
omarchy-ascii "JANAK" --to about
cat ~/.config/omarchy/branding/about.txt
fastfetch
```
If `about.txt` has your art but fastfetch doesn't show it, you may have a
custom `~/.config/fastfetch/config.jsonc` overriding Omarchy's default —
check its `logo` block.

**`--to fastfetch` created a file literally named `fastfetch` in my home folder**
You're on an old version of the script where that destination wasn't
recognized, so it was treated as a filename. Delete it (`rm ~/fastfetch`),
reinstall the current script, and re-run. Verify with step 7 of Installation.

**`fastfetch --gen-config` says "Config generation canceled"**
It prompts for confirmation and defaults to no. You almost certainly don't
need a config at all on Omarchy — see the fastfetch note above.

**`omarchy plymouth preview` just prints usage**
It needs all four arguments. Run it with background hex, text hex, logo
path, and output path — see the Plymouth section.

**`gio: Trashing on system internal mounts is not supported`**
Harmless. Write your preview output to your home folder instead of `/tmp`.

**`Error: run omarchy-plymouth-set as your user, not under sudo.`**
You ran the command (or a whole block containing it) through `sudo`. This
happens easily if you wrap several commands in `sudo bash << EOF ... EOF` —
that puts *everything* inside under root, including the `omarchy plymouth`
calls, which explicitly refuse to run that way. Run `omarchy plymouth
preview`/`set` as yourself; put only the specific lines that truly need
root (like editing files under `/boot` or `/etc`) in their own separate
`sudo` command.

**`Authorization required, but no authorization protocol specified` / `Failed to create window`**
Same root cause as above — `omarchy plymouth preview` was run under `sudo`.
Root has no access to your desktop session's X11/Wayland display
authority, so it can't open the preview window. Drop the `sudo`.

**Pasting a multi-line block gives `zsh: command not found: #`**
Interactive zsh doesn't treat `#` as a comment character by default (unlike
bash or a script file), so pasting text that includes comment lines
straight into the prompt makes it try to run each one as a command. It's
harmless noise — the real commands on the other lines still execute — but
to avoid it, strip the comment lines before pasting, save the block as a
`.sh` file and run that instead, or run `setopt interactive_comments` once
in your shell.

**Boot splash didn't change**
It only takes effect after a reboot. If you've rebooted and still see the
old one, re-run `omarchy plymouth set` and confirm it ends with an
`Updated: /boot/...` line.

**"figlet is not installed" and auto-install fails**
```bash
sudo pacman -S figlet
```

**`command not found: omarchy-ascii`**
Your `PATH` change hasn't applied. Run `exec $SHELL`, then
`which omarchy-ascii`. Confirm you added the export line to the file
matching your actual shell (`echo $SHELL`) — `~/.bashrc` and `~/.zshrc`
are not interchangeable.

**Accented or non-Latin characters render wrong**
`Delta Corps Priest 1` only defines standard Latin letters, digits, and
basic punctuation.

---

## Uninstalling

```bash
rm ~/bin/omarchy-ascii
rm -rf ~/.cache/omarchy-ascii
```

Restore default branding:
```bash
omarchy plymouth reset
```
and use Style > Screensaver / Style > About in the Omarchy menu ("Restore
Default") to put the original ASCII logos back.

---

## Migrating to native `omarchy ascii` later

Once your channel ships the built-in command, switch over:

```bash
# this script
omarchy-ascii "TEXT" --to about

# native equivalent
omarchy ascii "TEXT" > ~/.config/omarchy/branding/about.txt
```

Then delete `~/bin/omarchy-ascii` and `~/.cache/omarchy-ascii`.
