---
name: beat-sync
description: Cuts a reel so the clip changes land exactly on the beats of a music track. Use when the user wants a video "on beat", "synced to the music", a music reel, or a lyrics/lyricless music video from clips.
argument-hint: "<clips-folder> --music <file>"
---

# beat-sync

Detects the beats in a music track, then cuts the clips so every cut lands on a beat.
It works with ffmpeg alone (built-in onset detector); if `librosa` is installed the
detection is more precise. The plugin root is two folders above this skill's base
directory; run the engine through its wrapper by full path (PowerShell
`& "<plugin root>\bin\reelstudio.cmd" <args>`, Bash `bash "<plugin root>/bin/reelstudio" <args>`).

## Steps

1. Confirm the clips folder and the music file both exist.
2. Optionally preview the beats: `reelstudio beats "<music>"` prints beat times and the
   detected `tempo` (BPM) and `method`. Tell the user the BPM in plain words.
3. Render with the **beatsync** style:
   `reelstudio make --clips "<folder>" --music "<music>" --style beatsync`
   Add `--beats-per-clip 1` for a cut on every beat (faster), or `4` for one change every
   four beats (calmer). Default is `2`.
4. Report the output path and the number of segments. Offer `--beats-per-clip` tweaks.

## Notes

- Beat-sync needs a `--music` file; without one it falls back to the style's fixed pace.
- Clips are cycled if there are fewer clips than beats, so a short folder still fills the
  whole track. The reel ends when the music ends.
- No speech is involved, so captions are off in this style by default; add
  `--captions --keep-audio` if the clips have speech worth showing.
