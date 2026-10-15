---
name: transcribe
description: Transcribes speech in a video or audio file to an SRT subtitle file, fully offline. Use when the user asks to transcribe, caption, or get subtitles/text from spoken media.
argument-hint: "<media-file> [--out <file.srt>]"
---

# transcribe

Runs the local speech-to-text model (faster-whisper) and writes an SRT file. The plugin root
is two folders above this skill's base directory; run the engine through its wrapper by full
path (PowerShell `& "<plugin root>\bin\reelstudio.cmd" <args>`, Bash
`bash "<plugin root>/bin/reelstudio" <args>`).

## Steps

1. Confirm the file path exists.
2. Run `reelstudio transcribe "<media>"` (add `--out "<file>.srt"` if the user wants a
   specific location; add `--model small` for better accuracy on a slow machine, or
   `--model tiny` to go faster).
3. Report the SRT path and the number of lines. Offer to burn these captions into a reel
   (use the **reel** skill).

## Rules

- Requires the `faster-whisper` package. If the command says it is missing, run the
  **setup** skill first.
- The first run downloads the model once (about 75 MB for `base`) and needs internet; later
  runs are offline.
- Never upload the media anywhere: transcription is local.
