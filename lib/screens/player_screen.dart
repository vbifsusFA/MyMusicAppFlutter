import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../models/track.dart';

class PlayerScreen extends StatefulWidget {
  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  final player = AudioPlayer();
  late List<Track> tracks;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _initTracks();
  }

  Future<void> _initTracks() async {
    tracks = [
      Track(
        title: 'Summer Vibes',
        artist: 'Chill Artist',
        url: 'https://example.com/song1.mp3', // ЗАМЕНИ на реальный URL
      ),
      Track(
        title: 'Night Drive',
        artist: 'LoFi Beats',
        url: 'https://example.com/song2.mp3',
      ),
      Track(
        title: 'My Song',
        artist: 'Local Artist',
        url: 'assets/audio/song1.mp3',
      ),
    ];
    await _loadTrack(0);
  }

  Future<void> _loadTrack(int index) async {
    try {
      await player.setUrl(tracks[index].url);
      setState(() => currentIndex = index);
    } catch (e) {
      print('Ошибка загрузки трека: $e');
    }
  }

  void _playPause() {
    if (player.playing) {
      player.pause();
    } else {
      player.play();
    }
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (tracks.isEmpty) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final currentTrack = tracks[currentIndex];

    return Scaffold(
      appBar: AppBar(title: Text('Музыкальный плеер')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(currentTrack.title, style: TextStyle(fontSize: 24)),
            Text(currentTrack.artist, style: TextStyle(fontSize: 18)),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.skip_previous),
                  onPressed: currentIndex > 0
                      ? () => _loadTrack(currentIndex - 1)
                      : null,
                ),
                IconButton(
                  icon: Icon(player.playing ? Icons.pause : Icons.play_arrow),
                  onPressed: _playPause,
                ),
                IconButton(
                  icon: Icon(Icons.skip_next),
                  onPressed: currentIndex < tracks.length - 1
                      ? () => _loadTrack(currentIndex + 1)
                      : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}