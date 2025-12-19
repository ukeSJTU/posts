> **Purpose:** Complete reference for building a Code Radio client in any language (especially Neovim/Lua)  
> **Source:** Reverse-engineered from code-radio-cli Rust implementation  
> **Date:** December 18, 2025

---

## Table of Contents

1. [Quick Start](#quick-start)
2. [API Endpoints](#api-endpoints)
3. [Data Structures](#data-structures)
4. [Implementation Flow](#implementation-flow)
5. [Audio Streaming](#audio-streaming)
6. [Real-time Updates](#real-time-updates)
7. [Example Code (Multiple Languages)](#example-code)

---

## Quick Start

**What is Code Radio?**  
A 24/7 music radio by freeCodeCamp, playing coding-friendly instrumental music. Built on AzuraCast platform.

**Three Core Components:**

1. **REST API** - Get current song/station info (one-time fetch)
2. **SSE Stream** - Receive real-time updates when songs change
3. **MP3 Stream** - Actual audio stream (standard HTTP streaming)

**No authentication required!** All APIs are public.

---

## API Endpoints

### 1. REST API (Now Playing)

```
URL: https://coderadio-admin-v2.freecodecamp.org/api/nowplaying_static/coderadio.json
Method: GET
Content-Type: application/json
```

**Purpose:** Get current station state, now playing song, and metadata.

**When to use:**

- Initial app startup
- Quick status check
- Fallback if SSE fails

**Response time:** ~200-500ms

**Example request:**

```bash
curl https://coderadio-admin-v2.freecodecamp.org/api/nowplaying_static/coderadio.json
```

---

### 2. Server-Sent Events (Real-time Updates)

```
URL: https://coderadio-admin-v2.freecodecamp.org/api/live/nowplaying/sse?cf_connect=%7B%22subs%22%3A%7B%22station%3Acoderadio%22%3A%7B%7D%7D%7D
Method: GET (streaming)
Content-Type: text/event-stream
```

**Purpose:** Receive push notifications when songs change.

**When to use:**

- Keep UI in sync with radio
- Automatic song info updates
- Listener count updates

**Connection behavior:**

- Long-lived HTTP connection
- Server pushes events as they occur
- Reconnect automatically if disconnected
- Recommended reconnect delay: 1-20 seconds with exponential backoff

**Example request:**

```bash
curl -N 'https://coderadio-admin-v2.freecodecamp.org/api/live/nowplaying/sse?cf_connect=%7B%22subs%22%3A%7B%22station%3Acoderadio%22%3A%7B%7D%7D%7D'
```

**SSE Message Format:**

```
data: {"channel":"station:coderadio","pub":{"data":{"np":{...}}}}

data: {}
```

The actual song data is nested at: `message.pub.data.np` (same structure as REST API response)

---

### 3. Audio Stream (MP3)

```
Default: https://coderadio-admin-v2.freecodecamp.org/listen/coderadio/radio.mp3
Alternative (Low): https://coderadio-admin-v2.freecodecamp.org/listen/coderadio/low.mp3

Format: MP3
Bitrate: 128kbps (default) or 64kbps (low)
Method: GET (streaming)
```

**Purpose:** The actual audio to play.

**How to play:**

- Use any audio player that supports HTTP streaming
- Examples: mpv, ffplay, VLC, rodio, howler.js
- Just open the URL as if it's a regular MP3 file

**Example players:**

```bash
# MPV (recommended - lightweight)
mpv --no-video https://coderadio-admin-v2.freecodecamp.org/listen/coderadio/radio.mp3

# ffplay (part of ffmpeg)
ffplay -nodisp -autoexit https://coderadio-admin-v2.freecodecamp.org/listen/coderadio/radio.mp3

# VLC (command line)
vlc --intf dummy https://coderadio-admin-v2.freecodecamp.org/listen/coderadio/radio.mp3
```

---

## Data Structures

### Response Schema (REST API & SSE)

Both REST and SSE return the same data structure:

```json
{
  "station": {
    "id": 2,
    "name": "freeCodeCamp.org Code Radio",
    "shortcode": "coderadio",
    "listen_url": "https://coderadio-admin-v2.freecodecamp.org/listen/coderadio/radio.mp3",
    "url": "https://coderadio.freecodecamp.org",
    "mounts": [...],
    "remotes": [...]
  },
  "listeners": {
    "total": 48,
    "unique": 48,
    "current": 48
  },
  "now_playing": {
    "sh_id": 429609,
    "played_at": 1692248797,
    "duration": 258,
    "elapsed": 149,
    "remaining": 109,
    "song": {
      "id": "ec8eac58ccf43fcbd92a9164b69191c9",
      "text": "saib. - West Lake",
      "artist": "saib.",
      "title": "West Lake",
      "album": "Chillhop Essentials - Fall 2017",
      "art": "https://coderadio-admin-v2.freecodecamp.org/api/station/2/art/536571950758c84d3c25e259-1586028052.jpg"
    }
  },
  "playing_next": {
    "song": {...},
    "duration": 201,
    "played_at": 1692249047
  },
  "song_history": [...]
}
```

### Key Fields Reference

| Field Path                | Type    | Description                 | Example                         |
| ------------------------- | ------- | --------------------------- | ------------------------------- |
| `station.listen_url`      | string  | MP3 stream URL              | `https://...radio.mp3`          |
| `station.name`            | string  | Station name                | `"freeCodeCamp.org Code Radio"` |
| `listeners.current`       | integer | Current listener count      | `48`                            |
| `now_playing.song.title`  | string  | Song title                  | `"West Lake"`                   |
| `now_playing.song.artist` | string  | Artist name                 | `"saib."`                       |
| `now_playing.song.album`  | string  | Album name                  | `"Chillhop Essentials"`         |
| `now_playing.song.art`    | string  | Album art URL               | `https://...jpg`                |
| `now_playing.song.id`     | string  | Unique song identifier      | `"ec8eac58..."`                 |
| `now_playing.duration`    | integer | Total song length (seconds) | `258`                           |
| `now_playing.elapsed`     | integer | Time elapsed (seconds)      | `149`                           |
| `now_playing.remaining`   | integer | Time remaining (seconds)    | `109`                           |
| `now_playing.played_at`   | integer | Unix timestamp when started | `1692248797`                    |
| `playing_next.song.*`     | object  | Next song info              | Same as current song            |

**Important Notes:**

- `duration` might be `0` if unknown (rare)
- `song.id` changes with each song - use this to detect song changes
- `elapsed` + `remaining` = `duration`
- Timestamps are Unix epoch (seconds since 1970-01-01)

---

## Implementation Flow

### Basic Client Flow

```
┌─────────────────────────────────────────────────────────┐
│ 1. Initialize Application                               │
└────────────────┬────────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────────────┐
│ 2. Fetch Initial Data (REST API)                        │
│    GET /api/nowplaying_static/coderadio.json            │
│    Parse JSON → Extract song info                       │
└────────────────┬────────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────────────┐
│ 3. Start Audio Player                                   │
│    Play: station.listen_url                             │
│    (Background process/thread)                          │
└────────────────┬────────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────────────┐
│ 4. Display Song Info                                    │
│    Show: Title, Artist, Album, Progress                 │
└────────────────┬────────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────────────┐
│ 5. Connect to SSE Stream                                │
│    Open: /api/live/nowplaying/sse?...                   │
│    Keep connection alive                                │
└────────────────┬────────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────────────┐
│ 6. Listen for Events                                    │
│    ┌───────────────────────────────────────┐            │
│    │ On SSE Message Received:              │            │
│    │  - Parse JSON from "data: {...}"      │            │
│    │  - Check if song.id changed           │            │
│    │  - If changed: Update display         │            │
│    │  - Update elapsed time                │            │
│    └───────────────────────────────────────┘            │
└────────────────┬────────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────────────┐
│ 7. Update Progress (Timer)                              │
│    Every 1 second:                                      │
│    - Increment elapsed time                             │
│    - Update progress bar                                │
│    (Local timer between SSE updates)                    │
└─────────────────────────────────────────────────────────┘
```

### State Management

**Store these values:**

```javascript
state = {
  is_playing: false,
  current_song: {
    id: "",
    title: "",
    artist: "",
    album: "",
    art_url: "",
    duration: 0,
    elapsed: 0,
  },
  listeners: 0,
  volume: 9, // 0-9 scale (optional)
};
```

**Update strategy:**

1. **On initial load:** Fetch REST API → populate state
2. **On SSE message:**
   - If `song.id` changed → new song → reset progress
   - Update `elapsed` from server
   - Update `listeners`
3. **Every second (timer):**
   - Increment `elapsed` locally
   - Update progress bar
   - (Server will sync via SSE every ~30 seconds)

---

## Audio Streaming

### How Rust CLI Does It

```rust
// 1. Download MP3 stream over HTTP
let response = reqwest::blocking::get(listen_url)?;

// 2. Decode MP3 on-the-fly (streaming decoder)
let decoder = Mp3StreamDecoder::new(response)?;

// 3. Play audio (rodio library)
let sink = Sink::try_new(&stream_handle)?;
sink.append(decoder);
sink.set_volume(volume);
```

**Key insight:** The MP3 stream is infinite/continuous. You don't download the whole file - you stream and decode chunks as they arrive.

### Recommended Approaches by Language

#### **Neovim/Lua:**

```lua
-- Use system audio player (easiest)
vim.fn.jobstart({
  'mpv',
  '--no-video',
  '--volume=90',
  'https://coderadio-admin-v2.freecodecamp.org/listen/coderadio/radio.mp3'
})
```

#### **JavaScript/Node.js:**

```javascript
// Use speaker + lame decoder
const lame = require("lame");
const Speaker = require("speaker");
const https = require("https");

https.get(streamUrl, (res) => {
  res.pipe(new lame.Decoder()).pipe(new Speaker());
});
```

#### **Python:**

```python
# Use pygame or vlc
import vlc
player = vlc.MediaPlayer(stream_url)
player.play()
```

#### **Browser/JavaScript:**

```javascript
// Use HTML5 Audio
const audio = new Audio(streamUrl);
audio.play();
```

**Volume control:**

- Rust CLI: 0-9 scale (mapped to 0.0-1.0 internally)
- Most players: 0-100 or 0.0-1.0
- mpv: `--volume=90` (0-100)

---

## Real-time Updates

### SSE Message Parsing

**Raw SSE format:**

```
data: {"channel":"station:coderadio","pub":{"data":{"np":{...actual data...}}}}

data: {}

data: {"channel":"station:coderadio","pub":{"data":{"np":{...}}}}
```

**Parsing steps:**

1. Split stream by `\n\n` (double newline = message boundary)
2. Each message starts with `data: `
3. Some messages are empty: `data: {}`
4. Real messages have nested structure: `.pub.data.np`
5. The `np` object contains same data as REST API response

**Rust implementation:**

```rust
// Filter and extract real messages
sse_stream
  .try_filter_map(|response| async move {
    if let Event(event) = response {
      if let Ok(message) = serde_json::from_str::<SSEMessage>(&event.data) {
        return Ok(Some(message.pub.data.np));  // Extract nested data
      }
    }
    Ok(None)  // Skip empty/invalid messages
  })
```

### Detecting Song Changes

**Method:** Compare `now_playing.song.id`

```rust
let mut last_song_id = String::new();

fn update(message) {
  if message.now_playing.song.id != last_song_id {
    // NEW SONG!
    last_song_id = message.now_playing.song.id;
    display_new_song_info();
    reset_progress_bar();
  } else {
    // Same song, just update progress
    update_progress_bar();
  }
}
```

### Connection Resilience

**SSE connection can drop!** Implement reconnection:

```rust
// Rust CLI configuration
ReconnectOptions::reconnect(true)
  .retry_initial(false)        // Don't retry immediately
  .delay(Duration::from_secs(1))     // Start with 1 second
  .backoff_factor(2)                 // Double each time
  .delay_max(Duration::from_secs(20)) // Cap at 20 seconds
```

**Reconnection strategy:**

- Attempt 1: Wait 1 second
- Attempt 2: Wait 2 seconds
- Attempt 3: Wait 4 seconds
- Attempt 4+: Wait 20 seconds (max)

---

## Example Code

### Complete Minimal Example (Python)

```python
#!/usr/bin/env python3
import requests
import json
import subprocess
import threading
import time
from sseclient import SSEClient

# Configuration
REST_API = "https://coderadio-admin-v2.freecodecamp.org/api/nowplaying_static/coderadio.json"
SSE_API = "https://coderadio-admin-v2.freecodecamp.org/api/live/nowplaying/sse?cf_connect=%7B%22subs%22%3A%7B%22station%3Acoderadio%22%3A%7B%7D%7D%7D"

# State
current_song_id = None
player_process = None

def fetch_initial_data():
    """Get current song from REST API"""
    response = requests.get(REST_API)
    data = response.json()
    return data

def display_song_info(data):
    """Print current song information"""
    song = data['now_playing']['song']
    elapsed = data['now_playing']['elapsed']
    duration = data['now_playing']['duration']
    listeners = data['listeners']['current']

    print(f"\n♫ Now Playing:")
    print(f"  Title:  {song['title']}")
    print(f"  Artist: {song['artist']}")
    print(f"  Album:  {song['album']}")
    print(f"  Progress: {elapsed}s / {duration}s")
    print(f"  Listeners: {listeners}")

def start_audio_player():
    """Start mpv to play the audio stream"""
    global player_process
    stream_url = "https://coderadio-admin-v2.freecodecamp.org/listen/coderadio/radio.mp3"
    player_process = subprocess.Popen(
        ['mpv', '--no-video', '--volume=90', stream_url],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL
    )
    print("🎵 Audio player started")

def listen_for_updates():
    """Listen to SSE stream for real-time updates"""
    global current_song_id

    messages = SSEClient(SSE_API)
    for msg in messages:
        if msg.data and msg.data != '{}':
            try:
                data = json.loads(msg.data)
                # Extract nested data
                if 'pub' in data and 'data' in data['pub']:
                    np_data = data['pub']['data']['np']

                    # Check if song changed
                    song_id = np_data['now_playing']['song']['id']
                    if song_id != current_song_id:
                        current_song_id = song_id
                        display_song_info(np_data)
            except Exception as e:
                print(f"Error parsing SSE: {e}")

def main():
    global current_song_id

    print("Code Radio CLI")
    print("=" * 50)

    # 1. Fetch initial data
    print("Fetching current song...")
    data = fetch_initial_data()
    current_song_id = data['now_playing']['song']['id']
    display_song_info(data)

    # 2. Start audio player
    start_audio_player()

    # 3. Listen for updates in background
    print("\nListening for updates (Ctrl+C to exit)...")
    threading.Thread(target=listen_for_updates, daemon=True).start()

    # 4. Keep running
    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        print("\n\nStopping...")
        if player_process:
            player_process.terminate()

if __name__ == '__main__':
    main()
```

**Dependencies:**

```bash
pip install requests sseclient-py
# Also requires mpv installed: brew install mpv
```

---

### Minimal Example (Bash)

```bash
#!/bin/bash

# Fetch current song
echo "Fetching current song..."
curl -s "https://coderadio-admin-v2.freecodecamp.org/api/nowplaying_static/coderadio.json" | \
  jq -r '"Title: " + .now_playing.song.title + "\nArtist: " + .now_playing.song.artist'

# Start playing
echo -e "\nStarting audio player..."
mpv --no-video "https://coderadio-admin-v2.freecodecamp.org/listen/coderadio/radio.mp3" &

# Listen for updates
echo "Listening for updates..."
curl -N "https://coderadio-admin-v2.freecodecamp.org/api/live/nowplaying/sse?cf_connect=%7B%22subs%22%3A%7B%22station%3Acoderadio%22%3A%7B%7D%7D%7D" | \
  while IFS= read -r line; do
    if [[ $line == data:* ]]; then
      echo "$line" | sed 's/^data: //' | jq -r 'select(.pub) | .pub.data.np.now_playing.song.title' 2>/dev/null
    fi
  done
```

---

## Neovim Plugin Skeleton

```lua
-- lua/code-radio/init.lua

local M = {}
local api = require('code-radio.api')
local player = require('code-radio.player')

local state = {
  is_playing = false,
  current_song = nil,
  job_id = nil,
}

function M.play()
  if state.is_playing then return end

  -- Fetch initial song data
  api.get_now_playing(function(data)
    state.current_song = data.now_playing.song
    M.show_info()
  end)

  -- Start audio
  player.start()
  state.is_playing = true

  -- Start SSE listener
  api.start_sse_listener(function(data)
    local new_id = data.now_playing.song.id
    if new_id ~= state.current_song.id then
      state.current_song = data.now_playing.song
      M.show_info()
    end
  end)
end

function M.pause()
  if not state.is_playing then return end
  player.stop()
  state.is_playing = false
end

function M.toggle()
  if state.is_playing then M.pause() else M.play() end
end

function M.show_info()
  if not state.current_song then return end

  local lines = {
    "♫ Code Radio - Now Playing",
    "",
    "Title:  " .. state.current_song.title,
    "Artist: " .. state.current_song.artist,
    "Album:  " .. state.current_song.album,
  }

  -- Create floating window
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  local width = 60
  local height = 6
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  vim.api.nvim_open_win(buf, false, {
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
    style = 'minimal',
    border = 'rounded',
  })
end

function M.setup()
  vim.api.nvim_create_user_command('CodeRadioPlay', M.play, {})
  vim.api.nvim_create_user_command('CodeRadioPause', M.pause, {})
  vim.api.nvim_create_user_command('CodeRadioToggle', M.toggle, {})
  vim.api.nvim_create_user_command('CodeRadioInfo', M.show_info, {})
end

return M
```

```lua
-- lua/code-radio/player.lua

local M = {}
local job_id = nil

function M.start()
  if job_id then return end

  job_id = vim.fn.jobstart({
    'mpv',
    '--no-video',
    '--volume=90',
    'https://coderadio-admin-v2.freecodecamp.org/listen/coderadio/radio.mp3'
  }, {
    on_exit = function() job_id = nil end
  })
end

function M.stop()
  if job_id then
    vim.fn.jobstop(job_id)
    job_id = nil
  end
end

return M
```

```lua
-- lua/code-radio/api.lua

local curl = require('plenary.curl')
local M = {}

local REST_API = "https://coderadio-admin-v2.freecodecamp.org/api/nowplaying_static/coderadio.json"
local SSE_API = "https://coderadio-admin-v2.freecodecamp.org/api/live/nowplaying/sse?cf_connect=%7B%22subs%22%3A%7B%22station%3Acoderadio%22%3A%7B%7D%7D%7D"

function M.get_now_playing(callback)
  curl.get(REST_API, {
    callback = vim.schedule_wrap(function(response)
      local data = vim.json.decode(response.body)
      callback(data)
    end)
  })
end

function M.start_sse_listener(callback)
  vim.fn.jobstart({
    'curl', '-N', SSE_API
  }, {
    on_stdout = vim.schedule_wrap(function(_, data)
      for _, line in ipairs(data) do
        if line:match('^data:') then
          local json_str = line:sub(6)  -- Remove "data: "
          local ok, parsed = pcall(vim.json.decode, json_str)
          if ok and parsed.pub and parsed.pub.data then
            callback(parsed.pub.data.np)
          end
        end
      end
    end)
  })
end

return M
```

---

## Testing Checklist

- [ ] REST API returns valid JSON
- [ ] Can parse `now_playing.song.*` fields
- [ ] SSE connection stays alive for 1+ minute
- [ ] SSE messages parse correctly
- [ ] Audio stream plays continuously
- [ ] Song change detected via `song.id`
- [ ] Progress bar updates every second
- [ ] Listener count updates
- [ ] Reconnection works after network drop

---

## Troubleshooting

### Common Issues

**Problem:** SSE connection drops frequently  
**Solution:** Implement exponential backoff reconnection (see "Connection Resilience")

**Problem:** Audio stutters or buffers  
**Solution:** Use quality=low stream, or adjust player buffer settings (`mpv --cache=yes`)

**Problem:** `duration` is 0  
**Solution:** Handle this edge case - show elapsed time without total

**Problem:** SSE messages are empty `{}`  
**Solution:** These are keepalive pings - filter them out

**Problem:** Progress bar drifts from actual time  
**Solution:** Sync with server's `elapsed` value when SSE message arrives

---

## Additional Resources

- **AzuraCast API Docs:** https://docs.azuracast.com/en/developers/apis/now-playing-data
- **Code Radio Website:** https://coderadio.freecodecamp.org
- **About Code Radio:** https://www.freecodecamp.org/news/code-radio-24-7/
- **Original Rust CLI:** https://github.com/JasonWei512/code-radio-cli

---

## Summary

**You now have everything needed to build a Code Radio client:**

1. ✅ REST API for initial data
2. ✅ SSE API for real-time updates
3. ✅ MP3 stream URL for audio playback
4. ✅ Data structure reference
5. ✅ Implementation flow and patterns
6. ✅ Example code in multiple languages
7. ✅ Neovim plugin skeleton

**Core logic in 3 steps:**

1. Fetch song data (REST API)
2. Play audio stream (mpv/ffplay/etc)
3. Listen for updates (SSE)

**That's it!** No complex authentication, no WebSockets configuration, no audio codec compilation. Just HTTP requests and a system audio player.

Good luck building your Neovim plugin! 🎵
