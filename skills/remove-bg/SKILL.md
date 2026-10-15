---
name: remove-bg
description: Removes the background from an image (creating a transparent PNG) and detects faces for smart framing. Use when the user asks to cut out a subject, make a sticker, or check where faces are in a photo.
argument-hint: "<image-file> | faces <image-file>"
---

# remove-bg

Two local tools that need optional packages. The plugin root is two folders above this
skill's base directory; run the engine through its wrapper by full path (PowerShell
`& "<plugin root>\bin\reelstudio.cmd" <args>`, Bash `bash "<plugin root>/bin/reelstudio" <args>`).

## Remove the background

1. Confirm the image path exists.
2. Run `reelstudio remove-bg "<image>"` (add `--out "<file>.png"` for a specific location).
3. Report the transparent PNG path. Requires the `rembg` package; if missing, run **setup**.

## Detect faces

1. Run `reelstudio faces "<image>"`.
2. Report how many faces were found and, from the JSON, the suggested `crop_center` — the
   point the **reel** engine would use to keep faces in frame when cropping to 9:16.
3. Requires the `opencv-python` package; if missing, run **setup**.

## Rules

- The first `remove-bg` run downloads a model once (about 180 MB) and needs internet.
- Everything is local; never upload the image.
