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

  // Локальные переменные для плавной работы ползунков
  double? _dragPosition;
  double _volume = 0.5;

  static const String playButtonUrl = 'https://cdn-icons-png.flaticon.com/512/864/864839.png';
  static const String pauseButtonUrl = 'https://cdn-icons-png.flaticon.com/512/767/767631.png';
  static const String nextButtonUrl = 'https://cdn-icons-png.flaticon.com/512/864/864807.png';
  static const String prevButtonUrl = 'https://cdn-icons-png.flaticon.com/512/864/864825.png';

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
    player.setVolume(_volume);

    // Слушаем изменение состояния (для кнопки Пауза/Плей)
    player.playerStateStream.listen((state) {
      if (mounted) setState(() {});
      if (state.processingState == ProcessingState.completed) {
        _nextTrack();
      }
    });

    // Слушаем позицию трека
    player.positionStream.listen((pos) {
      if (mounted) setState(() {});
    });

    // Слушаем длительность
    player.durationStream.listen((dur) {
      if (mounted) setState(() {});
    });
  }

  Future<void> _loadTrack(int index) async {
    if (index >= 0 && index < tracks.length) {
      try {
        await player.stop();
        await player.setUrl(tracks[index].url);
        setState(() {
          currentIndex = index;
        });
        player.play();
      } catch (e) {
        debugPrint('Ошибка загрузки: $e');
      }
    }
  }

  void _nextTrack() {
    if (currentIndex < tracks.length - 1) {
      _loadTrack(currentIndex + 1);
    }
  }

  void _prevTrack() {
    if (currentIndex > 0) {
      _loadTrack(currentIndex - 1);
    }
  }

  void _addTracks(List<Track> newTracks) {
    setState(() {
      tracks.addAll(newTracks);
    });
    if (tracks.isNotEmpty && currentIndex == -1) {
      _loadTrack(0);
    }
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Вычисляем, какую позицию показывать: ту, что тянет палец, или реальную из плеера
    final duration = player.duration?.inSeconds.toDouble() ?? 0.0;
    final position = _dragPosition ?? player.position.inSeconds.toDouble();
    return Scaffold(
      appBar: AppBar(title: const Text('Музыкальный плеер')),
      body: Column(
        children: [
          Expanded(
            child: TrackList(
              tracks: tracks,
              currentTrackIndex: currentIndex,
              onTrackSelected: (index) => _loadTrack(index),
              showAddButton: tracks.isEmpty,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomPlayer(
        // Иконка меняется мгновенно в зависимости от состояния player.playing
        playButtonImageUrl: player.playing ? pauseButtonUrl : playButtonUrl,
        pauseButtonImageUrl: pauseButtonUrl,
        nextButtonImageUrl: nextButtonUrl,
        prevButtonImageUrl: prevButtonUrl,
        
        onPlayPressed: () {
          if (currentIndex == -1 && tracks.isNotEmpty) {
             _loadTrack(0);
             return;
          }
          if (player.playing) {
            player.pause();
          } else {
            player.play();
          }
          setState(() {}); // Перерисовать кнопку
        },
        
        onPausePressed: () {
          player.pause();
          setState(() {});
        },
        
        onNextPressed: _nextTrack,
        onPrevPressed: _prevTrack,
        
        // ПОЛЗУНОК ТРЕКА
        position: position,
        duration: duration,
        onPositionChanged: (value) {
          setState(() {
            _dragPosition = value; // Запоминаем, куда тянет палец
          });
          player.seek(Duration(seconds: value.toInt()));
          // Сбрасываем drag через мгновение после перехода
          Future.delayed(const Duration(milliseconds: 500), () {
            _dragPosition = null;
          });
        },
        
        // ПОЛЗУНОК ГРОМКОСТИ
        volume: _volume,
        onVolumeChanged: (value) {
          setState(() {
            _volume = value; // Обновляем локально, чтобы слайдер двигался плавно
          });
          player.setVolume(value);
        },
      ),
      floatingActionButton: AddTrackButton(
        onTracksAdded: _addTracks,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}