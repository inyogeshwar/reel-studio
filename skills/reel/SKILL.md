---
name: reel
description: Builds a ready-to-post vertical reel (9:16) from a folder of clips or photos. Auto-cuts to a music track, burns in captions from speech, and applies a chosen style. Use when the user asks to make, edit, assemble or export a reel, short, short-video, TikTok, Instagram Reel or YouTube Short.
argument-hint: "<clips-folder> [--style <name>] [--music <file>]"
---

# reel

Turns a folder of clips/photos into one finished vertical reel using the Reel Studio
engine. All work happens locally. The plugin root is two folders above this skill's base
directory; run the engine through its wrapper by full path (PowerShell
`& "<plugin root>\bin\reelstudio.cmd" <args>`, Bash `bash "<plugin root>/bin/reelstudio" <args>`).

## Decide the style first

If the user did not name a style, ask once which of the built-in styles to use (see
`reelstudio styles list`): **clean** (editorial talking-head), **punchy** (fast faceless
music reels), **documentary** (slow cinematic), **beatsync** (cuts on the music beat) or
**faceless** (voice-over over b-roll). If they want, use **playbook** to create a custom
style. Never start a long render before the style is chosen.

## Special modes

- Music reel cut on the beat: use the **beat-sync** skill (pass `--music`).
- Faceless voice-over over b-roll: use the **voice-over** skill (pass `--voice`).

## Steps

1. Confirm the clips folder path and that it exists. Confirm the engine is ready with
   `reelstudio doctor`; if `"ready"` is false, run the **setup** skill first.
2. Ask for (all optional): a music file (`--music`), a voice-over (`--voice`), whether to
   keep the original audio (`--keep-audio`), and any per-clip length in seconds (`--per-clip`).
3. Run:
   `reelstudio make --clips "<folder>" --style <name>` plus `--music "<file>"`,
   `--voice "<file>"`, `--keep-audio`, `--per-clip <s>`, `--beat-sync`,
   `--beats-per-clip <n>`, `--aspect <9:16|1:1|4:5|16:9>` as needed.
   The command prints JSON with `"out"` (the finished file), `"beat_sync"`, `"voice_over"`
   and `"steps"`.
4. Tell the user the output path in plain words and how long it took. Offer one next step:
   re-render with a different style, add captions if they were skipped, or change the music.

## Rules

- Never invent a style name: check with `reelstudio styles list`.
- Captions need speech audio and the `faster-whisper` package. If captions were skipped,
  say exactly why (package missing, or no audio: pass `--voice` or `--keep-audio`).
- Beat-sync and voice-over need their inputs (`--music`, `--voice`); without them the reel
  uses the style's fixed pace.
- The engine re-encodes each clip; a 60-second reel of 10 clips takes roughly 1–3 minutes.
- The **documentary** style joins clips with true crossfade transitions (ffmpeg `xfade`).
- Any b-roll clip shorter than its slot is looped automatically to fill the time.
- Do not edit, rename or move the user's source clips. The engine only reads them.
- If `make` fails, report the `error` in one sentence and the likely cause (usually a
  corrupt or unsupported clip); suggest removing that clip and retrying.
