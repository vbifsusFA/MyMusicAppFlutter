# Bottom Player Components

This directory contains the components for the bottom player control bar in the music application.

## Components

### 1. BottomPlayer
The main player widget that combines all components into a bottom navigation bar.

#### Props:
- `playButtonImageUrl`: URL for the play button image
- `pauseButtonImageUrl`: URL for the pause button image
- `nextButtonImageUrl`: URL for the next button image
- `prevButtonImageUrl`: URL for the previous button image
- `onPlayPressed`: Function called when play button is pressed
- `onPausePressed`: Function called when pause button is pressed
- `onNextPressed`: Function called when next button is pressed
- `onPrevPressed`: Function called when previous button is pressed
- `onPositionChanged`: Function called when timeline position changes
- `volume`: Current volume value (0.0 to 1.0)
- `onVolumeChanged`: Function called when volume changes
- `position`: Current playback position
- `duration`: Total duration of the track

### 2. PlayerButton
A customizable button that can display an image from a URL.

#### Props:
- `imageUrl`: URL for the button image
- `onPressed`: Function called when button is pressed
- `size`: Size of the button (default 40)

### 3. Timeline
A slider for controlling playback position with time labels.

#### Props:
- `position`: Current playback position
- `duration`: Total duration of the track
- `onChanged`: Function called when position changes

### 4. VolumeControl
A slider for controlling audio volume with a volume icon.

#### Props:
- `volume`: Current volume value (0.0 to 1.0)
- `onChanged`: Function called when volume changes

## Usage Example

```dart
BottomPlayer(
  playButtonImageUrl: 'https://example.com/play.png',
  pauseButtonImageUrl: 'https://example.com/pause.png',
  nextButtonImageUrl: 'https://example.com/next.png',
  prevButtonImageUrl: 'https://example.com/prev.png',
  onPlayPressed: () {
    // Handle play
  },
  onPausePressed: () {
    // Handle pause
  },
  onNextPressed: () {
    // Handle next
  },
  onPrevPressed: () {
    // Handle previous
  },
  position: 30.0,
  duration: 100.0,
  volume: 0.7,
  onVolumeChanged: (value) {
    // Handle volume change
  },
  onPositionChanged: (value) {
    // Handle position change
  },
)
```