-- 1. Copy to your Hyprland config
cp input.lua ~/.config/hypr/input.lua

-- 2. Reload Hyprland
hyprctl reload

-- 3. Test gestures:
--    - 3-finger swipe left/right: change workspace
--    - 3-finger swipe up: fullscreen window
--    - 3-finger swipe down: close window
--    - 2-finger pinch in: toggle float
--    - 4-finger swipe up: open terminal




----




-- ═══════════════════════════════════════════════════════════════════════════
-- HYPRLAND INPUT CONFIGURATION (input.lua)
-- ═══════════════════════════════════════════════════════════════════════════
-- Complete input setup: keyboard layouts, mouse/touchpad settings, and
-- gesture bindings for Hyprland on a laptop with touchpad.
-- ═══════════════════════════════════════════════════════════════════════════

-- ───────────────────────────────────────────────────────────────────────────
-- KEYBOARD CONFIGURATION
-- ───────────────────────────────────────────────────────────────────────────

hl.config({
  input = {
    -- Multiple keyboard layouts: US, Danish, EU
    -- Switch with: Left Alt + Right Alt (or the configured grp option)
    kb_layout = "us,dk,eu",

    -- Keyboard options:
    -- compose:caps        = Use Caps Lock as Compose key
    -- shift:both_capslock_cancel = Both shifts cancel Caps Lock
    -- grp:alts_toggle     = Alt+Alt to switch layout
    kb_options = "compose:caps,shift:both_capslock_cancel,grp:alts_toggle",

    -- Keyboard variant (intl = international, supports accents)
    kb_variant = "intl",

    -- Keyboard repeat: how fast keys repeat when held
    repeat_rate = 50,     -- Characters per second (default: 25)
    repeat_delay = 550,   -- Milliseconds before repeat starts (default: 600)

    -- Numlock state on startup
    numlock_by_default = true,

    -- ───────────────────────────────────────────────────────────────────────
    -- MOUSE CONFIGURATION
    -- ───────────────────────────────────────────────────────────────────────

    -- Mouse sensitivity (-1.0 to 1.0, default: 0)
    -- Positive = faster, negative = slower
    sensitivity = 0.5,

    -- Acceleration profile:
    -- "adaptive" (default) = Curves speed based on movement
    -- "flat" = Linear, no acceleration
    accel_profile = "flat",

    -- Force mouse button order (if needed)
    -- Uncomment if your mouse buttons feel wrong
    -- force_no_accel = false,

    -- ───────────────────────────────────────────────────────────────────────
    -- TOUCHPAD CONFIGURATION
    -- ───────────────────────────────────────────────────────────────────────

    touchpad = {
      -- Natural (inverse) scrolling — swipe down scrolls down (like macOS)
      natural_scroll = true,

      -- Two-finger click for right-click (instead of lower-right corner)
      clickfinger_behavior = true,

      -- Scroll speed factor (0.1 to 5.0)
      -- Lower = slower, higher = faster
      scroll_factor = 0.4,

      -- Disable touchpad while typing to prevent accidental touches
      disable_while_typing = false,

      -- Three-finger drag (1 = enabled, 0 = disabled)
      -- Hold 3 fingers on touchpad to drag windows
      drag_3fg = 1,
    },
  },
})

-- ───────────────────────────────────────────────────────────────────────────
-- TOUCHPAD GESTURES
-- ═════════════════════════════════════════════════════════════════════════════
--
-- Gesture structure:
--   hl.gesture({ fingers = N, direction = "...", mods = "MOD", action = "..." })
--
-- Directions: up, down, left, right, pinchin, pinchout
-- Mods: SHIFT, CTRL, ALT, SUPER (alone or combined like "CTRL+ALT")
-- ─────────────────────────────────────────────────────────────────────────────

-- ── WORKSPACE NAVIGATION ───────────────────────────────────────────────────
-- 3-finger horizontal swipe: switch workspaces left/right
hl.gesture({
  fingers = 3,
  direction = "horizontal",
  action = "workspace",
})

-- ── WINDOW MANAGEMENT ──────────────────────────────────────────────────────
-- 3-finger swipe up: fullscreen active window
hl.gesture({
  fingers = 3,
  direction = "up",
  action = "fullscreen",
})

-- 3-finger swipe down: close active window
hl.gesture({
  fingers = 3,
  direction = "down",
  action = "close",
})

-- 2-finger pinch in: toggle floating mode
hl.gesture({
  fingers = 2,
  direction = "pinchin",
  action = "float",
})

-- 2-finger pinch out: zoom cursor (useful for visibility)
hl.gesture({
  fingers = 2,
  direction = "pinchout",
  action = "cursor_zoom",
  zoom_level = 1.5,
  mode = "mult",
})

-- ── MODIFIED GESTURES (with ALT key) ───────────────────────────────────────
-- These are alternatives that don't conflict with plain gestures above

-- Alt + 3-finger swipe up: toggle scratchpad (special workspace)
hl.gesture({
  fingers = 3,
  direction = "up",
  mods = "ALT",
  action = "special",
  workspace_name = "scratchpad",
})

-- Alt + 3-finger swipe down: float the active window
hl.gesture({
  fingers = 3,
  direction = "down",
  mods = "ALT",
  action = "float",
})

-- ── FOUR-FINGER GESTURES (custom actions) ──────────────────────────────────
-- 4-finger swipe up: launch terminal (kitty)
-- Change "kitty" to your terminal: "alacritty", "foot", "gnome-terminal", etc.
hl.gesture({
  fingers = 4,
  direction = "up",
  action = function()
    hl.exec_cmd("kitty")
  end,
})

-- 4-finger swipe down: launch rofi (app launcher)
hl.gesture({
  fingers = 4,
  direction = "down",
  action = function()
    hl.exec_cmd("rofi -show drun")
  end,
})

-- 4-finger swipe left: screenshot with flameshot
hl.gesture({
  fingers = 4,
  direction = "left",
  action = function()
    hl.exec_cmd("flameshot gui")
  end,
})

-- 4-finger swipe right: show notification
hl.gesture({
  fingers = 4,
  direction = "right",
  action = function()
    hl.notification.create({
      text = "4-finger right swipe",
      timeout = 2000,
      icon = "info",
    })
  end,
})

-- ═══════════════════════════════════════════════════════════════════════════
-- APP-SPECIFIC SETTINGS (optional, uncomment to use)
-- ═══════════════════════════════════════════════════════════════════════════

-- Different scroll speeds for different apps
-- o.window("(Alacritty|kitty|foot)", { scroll_touchpad = 1.5 })
-- o.window("firefox", { scroll_touchpad = 0.8 })
-- o.window("(nvim|Neovide)", { scroll_touchpad = 1.2 })

-- ═══════════════════════════════════════════════════════════════════════════
-- NOTES
-- ═══════════════════════════════════════════════════════════════════════════
--
-- 1. KEYBOARD LAYOUTS:
--    Switch between kb_layout options using Left Alt + Right Alt (grp:alts_toggle)
--    Current: US (QWERTY), Danish (QWERTY), EU (varies by country)
--
-- 2. TOUCHPAD GESTURES:
--    - Plain gestures (3-finger up/down, 2-finger pinch) are base actions
--    - Alt + gesture modifies behavior without conflicts
--    - 4-finger swipes are custom — edit hl.exec_cmd() for your preferred apps
--
-- 3. GESTURE DIRECTION:
--    - "horizontal" covers both left and right swipes
--    - Swipe in the direction: "up", "down", "left", "right"
--
-- 4. CUSTOM ACTIONS:
--    hl.exec_cmd("command")        = Run a shell command
--    hl.notification.create({...}) = Show a notification
--    Built-in actions: "workspace", "fullscreen", "close", "float", "special"
--
-- 5. TOUCHPAD OPTIONS (valid for Omarchy/Hyprland):
--    - natural_scroll = true/false       (inverse scrolling)
--    - clickfinger_behavior = true/false (2-finger click = right-click)
--    - scroll_factor = 0.1-5.0           (scroll speed)
--    - disable_while_typing = true/false (prevent accidental touches while typing)
--    - drag_3fg = 0/1                    (3-finger drag to move windows)
--
-- 6. TROUBLESHOOTING:
--    - If gestures don't work, check your touchpad driver is installed:
--      sudo pacman -S libinput
--    - If config errors appear, remove unsupported keys (this config uses only common ones)
--    - Test gestures with: hyprctl list-clients
--    - Check logs: journalctl -xe | grep -i hypr
--
-- ═══════════════════════════════════════════════════════════════════════════