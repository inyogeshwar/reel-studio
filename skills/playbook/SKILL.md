---
name: playbook
description: Creates, edits and lists reusable reel "styles" (playbooks) that control aspect ratio, pace, transitions and caption look. Use when the user wants to define their own look, tweak an existing style, or list available styles.
argument-hint: "[list | new <name>]"
---

# playbook

A **style** (playbook) is a small JSON file the engine reads when it renders a reel. Three
styles ship with the plugin (`clean`, `punchy`, `documentary`); the user's own styles live in
`REELSTUDIO_HOME/styles` and override a preset with the same name. The plugin root is two
folders above this skill's base directory; run the engine through its wrapper by full path.

## List

Run `reelstudio styles list` and show the names with their one-line `description` and
`source` (preset or user). To see every field of one style: `reelstudio styles show <name>`.

## Create or edit

1. Ask what the user wants: pace (`per_clip_seconds`), transition (`none`, `hard`,
   `crossfade`), caption font/size/colour, and music `music_volume`.
2. Start from a preset: read it with `reelstudio styles show <preset>` and change only the
   fields the user asked about.
3. Write the JSON file to `REELSTUDIO_HOME/styles/<name>.json`. Use the Write tool; do not
   hand-edit anything inside `REELSTUDIO_HOME` other than `styles/`.
4. Confirm with `reelstudio styles show <name>` and offer to render a reel with **reel**.

## Field reference

| Field | Meaning |
| --- | --- |
| `aspect` | `9:16`, `1:1`, `4:5` or `16:9` |
| `fps` | Frame rate (30 is a safe default) |
| `per_clip_seconds` | Trim every clip to this many seconds (`0` keeps the whole clip) |
| `transition` | `none`, `hard`, or `crossfade` (fade in/out per clip) |
| `crossfade_seconds` | Fade length when `transition` is `crossfade` |
| `captions` | Whether to burn captions by default |
| `beat_sync` | Cut clips on music beats (needs a `--music` file) |
| `beats_per_clip` | How many beats each clip lasts when `beat_sync` is on |
| `caption_style` | `font`, `font_size`, `primary_color`, `outline_color`, `outline`, `margin_v`, `bold` |
| `music_volume` | `0.0`–`1.0+`, relative music loudness |
