---
name: voice-over
description: Builds a faceless voice-over reel from a narration audio file and a folder of b-roll clips or photos. The b-roll changes on each spoken sentence, the narration is the main audio, music sits low behind it, and captions are burned in. Use for faceless reels, voice-over videos, narration, documentaries or storytelling from clips.
argument-hint: "<b-roll-folder> --voice <narration-audio> [--music <file>]"
---

# voice-over

Creates a faceless reel: a folder of clips/photos becomes b-roll behind a spoken narration.
The engine transcribes the narration, cuts the b-roll on each spoken sentence, keeps the
voice at full volume and ducks any music underneath. Requires the `faster-whisper` package
(the setup skill installs it) so sentences and captions can be found. The plugin root is two
folders above this skill's base directory; run the engine through its wrapper by full path.

## Steps

1. Confirm the narration file and the b-roll folder both exist.
2. Check the engine: `reelstudio doctor`. If `"voice_over"` is false, run the **setup**
   skill first (it needs faster-whisper).
3. Render:
   `reelstudio make --clips "<b-roll-folder>" --voice "<narration>" --style faceless`
   Add `--music "<file>"` for a quiet music bed behind the voice.
4. Report the output path, how many b-roll changes were made, and that captions were burned
   from the narration. Offer to re-run with a different b-roll order or a louder/quieter bed.

## Notes

- The b-roll is cycled through the folder; give the folder enough clips for the narration
  length for more variety.
- Cut points follow sentence boundaries (whisper). Long merged sentences are split further
  (around punctuation, then by a ~3.5s budget) so b-roll changes roughly every sentence
  (a minimum of 1 second per shot is enforced).
- A b-roll clip shorter than the sentence it fills is automatically looped so the narration
  is never cut short.
- The final reel is bounded by the narration length; trailing silence is trimmed.
- The voice file can be any audio or video with speech; `.mp3`, `.wav`, `.m4a` all work.
- Never upload the narration: transcription is local.
