import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../models/track.dart';
import '../ui/player/player.dart';
import '../ui/player/add_track_button.dart';
import '../ui/track_list.dart';

class PlayerScreen extends StatefulWidget {
  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late AudioPlayer player;
  List<Track> tracks = [];
  int currentIndex = -1;

  // Example image URLs for buttons
  static const String playButtonUrl =
      'https://cdn-icons-png.flaticon.com/512/864/864839.png';
  static const String pauseButtonUrl =
      'https://cdn-icons-png.flaticon.com/512/767/767631.png';
  static const String nextButtonUrl =
      'https://cdn-icons-png.flaticon.com/512/864/864807.png';
  static const String prevButtonUrl =
      'https://cdn-icons-png.flaticon.com/512/864/864825.png';

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();

    // Add player state listeners for better UX
    player.playerStateStream.listen((playerState) {
      // Update UI when player state changes
      setState(() {});

      // Handle track completion to play next track automatically
      if (playerState.processingState == ProcessingState.completed) {
        // Move to next track when current track finishes
        if (currentIndex < tracks.length - 1) {
          _loadTrack(currentIndex + 1);
          player.play();
        }
      }
    });

    // Listen to position changes for timeline updates
    player.positionStream.listen((position) {
      // The position is already accessible via player.position
      // setState is called when needed by the UI components
    });

    _initTracks();
  }

  Future<void> _initTracks() async {
    tracks = [];
    currentIndex = -1;
  }

  Future<void> _loadTrack(int index) async {
    if (index >= 0 && index < tracks.length) {
      try {
        // Stop current playback before loading new track
        await player.stop();
        await player.setUrl(tracks[index].url);
        setState(() {
          currentIndex = index;
        });
      } catch (e) {
        print('Ошибка загрузки трека: $e');
      }
    }
  }


  void _addTracks(List<Track> newTracks) {
    int previousTracksCount = tracks.length;
    setState(() {
      tracks.addAll(newTracks);
    });

    // If this is the first track added, automatically load and play it
    if (tracks.isNotEmpty && currentIndex == -1) {
      _loadTrack(0);
      // Auto-play the first track added
      Future.delayed(Duration(milliseconds: 100), () {
        player.play();
      });
    } else if (previousTracksCount > 0) {
      // If tracks already existed, play the newly added track (the last one in the list)
      int newTrackIndex = tracks.length - 1;
      _loadTrack(newTrackIndex);
      // Auto-play the newly added track
      Future.delayed(Duration(milliseconds: 100), () {
        player.play();
      });
    }
  }

  void _selectTrack(int index) {
    _loadTrack(index);
    // Auto-play the selected track
    Future.delayed(Duration(milliseconds: 100), () {
      player.play();
    });
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Музыкальный плеер')),
      body: Column(
        children: [
          Expanded(
            child: TrackList(
              tracks: tracks,
              currentTrackIndex: currentIndex,
              onTrackSelected: _selectTrack,
              showAddButton: tracks.isEmpty,
            ),
          ),
        ],
      ),
      // Add the bottom player with image URLs and functions
      bottomNavigationBar: BottomPlayer(
        playButtonImageUrl: playButtonUrl,
        pauseButtonImageUrl: pauseButtonUrl,
        nextButtonImageUrl: nextButtonUrl,
        prevButtonImageUrl: prevButtonUrl,
        onPlayPressed: () {
          player.play();
        },
        onPausePressed: () {
          player.pause();
        },
        onNextPressed: () {
          if (currentIndex < tracks.length - 1) {
            _loadTrack(currentIndex + 1);
          }
        },
        onPrevPressed: () {
          if (currentIndex > 0) {
            _loadTrack(currentIndex - 1);
          }
        },
        position: player.position.inSeconds.toDouble(),
        duration: player.duration?.inSeconds.toDouble() ?? 0.0,
        volume: player.volume,
        onVolumeChanged: (value) {
          player.setVolume(value);
        },
        onPositionChanged: (value) {
          player.seek(Duration(seconds: value.toInt()));
        },
      ),
      // Add the floating add track button
      floatingActionButton: AddTrackButton(
        onTracksAdded: _addTracks,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}