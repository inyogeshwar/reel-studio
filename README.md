# Reel Studio

Turn a folder of clips or photos into ready-to-post **vertical reels** — all on your own
machine. Reel Studio is a free, local-first video editing plugin for
[Google Antigravity](https://antigravity.google/docs/plugins/).

No account, no licence key, no online check, and nothing is uploaded: ffmpeg does the
editing and small local AI models handle captions, background removal and face detection.

## Features

- **One-command reels** — a folder in, a finished 9:16 / 1:1 / 4:5 / 16:9 MP4 out.
- **Auto captions** — local speech-to-text (faster-whisper), burned in with a styled look.
- **Beat-sync** — cuts clips on the actual beats/onsets of a music track.
- **Faceless voice-over** — transcribes your narration, cuts b-roll on each sentence,
  ducks a music bed underneath, and burns captions.
- **Background removal** — cut out a subject with `rembg`.
- **Face-aware framing** — detect faces and frame around the subject.
- **Styles** — built-in presets (`clean`, `punchy`, `documentary`, `beatsync`, `faceless`)
  plus your own JSON styles.
- **Fully offline** — transcription and effects run locally.

## Requirements

- [Antigravity IDE](https://antigravity.google/docs/ide/overview/) (or the Antigravity app/CLI).
- Python 3.9+ on your `PATH` (the installer creates a private virtual environment).
- Internet for the first install (downloads ffmpeg plus optional models).
- ~2 GB free disk space.

## Install

Ask the agent in Antigravity to run the **setup** skill (e.g. *"set up reel studio"*), or
run the installer yourself:
```powershell
# Windows (PowerShell)
# Ab log ise Antigravity me install kar sakte hain:

agy plugin install https://github.com/inyogeshwar/reel-studio
```
```powershell
# Windows (PowerShell)
powershell -NoProfile -ExecutionPolicy Bypass -File ".\setup\install.ps1"
```

```bash
# macOS / Linux
bash ./setup/install.sh
```

The installer is idempotent — run it again to finish anything that failed. Add `-Update`
(PowerShell) or `--update` (Bash) to repair/upgrade without touching your custom styles.

Everything is installed into one folder:

- Windows: `%USERPROFILE%\ReelStudio`
- macOS / Linux: `~/ReelStudio`

Override it any time with the `REELSTUDIO_HOME` environment variable.

Check readiness:

```powershell
& "<plugin root>\bin\reelstudio.cmd" doctor
```

## Usage

Just talk to the agent: *"make a reel from my `C:\clips` folder with `song.mp3`"*. The
plugin's skills pick the right commands. Under the hood everything goes through one CLI:

```text
reelstudio make --clips <folder> [options]
```

Common options:

| Option | Meaning |
| --- | --- |
| `--style <name>` | `clean`, `punchy`, `documentary`, `beatsync`, `faceless` |
| `--music <file>` | music bed / main track |
| `--voice <file>` | narration audio → faceless voice-over reel |
| `--beat-sync` / `--no-beat-sync` | cut clips on the music beat |
| `--beats-per-clip <n>` | beats per b-roll shot (beat-sync) |
| `--per-clip <s>` | seconds per clip (fixed pace) |
| `--keep-audio` | keep the original clip audio |
| `--captions` / `--no-captions` | burn (or skip) captions |
| `--aspect <9:16\|1:1\|4:5\|16:9>` | output aspect ratio |
| `--fps <n>` | output frame rate |
| `--out <file>` | output path |

Examples:

```bash
# Beat-synced music reel
reelstudio make --clips "C:\clips" --style beatsync --music "C:\song.mp3"

# Faceless voice-over over b-roll, with a quiet music bed
reelstudio make --clips "C:\broll" --voice "C:\narration.mp3" --music "C:\bed.mp3" --style faceless

# Slow cinematic reel with crossfade transitions
reelstudio make --clips "C:\clips" --style documentary
```

Other commands: `doctor`, `paths`, `styles`, `beats`, `transcribe`, `remove-bg`, `faces`,
`version`. Run `reelstudio --help` for details.

## Skills

The plugin ships Antigravity skills that wrap the engine:

`setup`, `reel`, `playbook`, `transcribe`, `remove-bg`, `beat-sync`, `voice-over`.

## Notes

- The engine works with **ffmpeg only**. Optional packages unlock extras: `faster-whisper`
  (captions, voice-over), `rembg` + `onnxruntime` (background removal), `opencv-python`
  (face detection), `librosa` (more accurate beat-sync — beat-sync also works without it via
  a built-in detector). Missing an optional package never breaks the rest.
- Reel Studio only **reads** your source clips; it never edits or moves them.
- Exports land in `REELSTUDIO_HOME/output` unless you pass `--out`.

## Uninstall

Delete the `REELSTUDIO_HOME` folder and remove the plugin folder from your Antigravity
plugins directory.

## License

MIT — see [LICENSE](LICENSE).
