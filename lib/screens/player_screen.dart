import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../models/track.dart';
import '../ui/player/player.dart';
import '../ui/player/add_track_button.dart';
import '../ui/track_list.dart';
import 'profile_screen.dart'; // Импорт экрана профиля

class PlayerScreen extends StatefulWidget {
  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late AudioPlayer player;
  List<Track> tracks = [];
  int currentIndex = -1;

  // Переменные для стабильной работы ползунков
  double? _dragPosition; // Позиция, которую тянет пользователь
  double _volume = 0.5;  // Громкость

  // Ссылки на иконки кнопок


  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
    player.setVolume(_volume);

    // 1. Слушаем состояние плеера (играет/пауза/загрузка)
    player.playerStateStream.listen((state) {
      if (mounted) setState(() {});
      // Если песня доиграла до конца — включаем следующую
      if (state.processingState == ProcessingState.completed) {
        _nextTrack();
      }
    });

    // 2. Слушаем позицию трека (чтобы ползунок двигался сам)
    player.positionStream.listen((pos) {
      if (mounted) setState(() {});
    });

    // 3. Слушаем длительность трека
    player.durationStream.listen((dur) {
      if (mounted) setState(() {});
    });
  }

  // Метод загрузки и запуска трека
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
        debugPrint('Ошибка загрузки трека: $e');
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
    // Если это первые добавленные треки — загружаем первый
    if (tracks.isNotEmpty && currentIndex == -1) {
      _loadTrack(0);
    }
  }

  @override
  void dispose() {
    player.dispose(); // Освобождаем ресурсы при закрытии приложения
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Определяем текущие значения для отображения в ползунках
    final duration = player.duration?.inSeconds.toDouble() ?? 0.0;
    // Пока пользователь тянет ползунок, берем _dragPosition, иначе — реальную позицию из плеера
    final position = _dragPosition ?? player.position.inSeconds.toDouble();
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Music Player'),
        centerTitle: true,
        actions: [
          // Кнопка перехода в профиль
          IconButton(
            icon: const Icon(Icons.person_pin, size: 30),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Список треков
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
      // Нижняя панель управления (BottomPlayer)
      bottomNavigationBar: BottomPlayer(
        isPlaying: player.playing, // Передаем состояние проигрывания
        onPlayPressed: () {
          if (currentIndex == -1 && tracks.isNotEmpty) {
            _loadTrack(0);
          } else if (player.playing) {
            player.pause();
          } else {
            player.play();
          }
          setState(() {}); 
        },
        onNextPressed: _nextTrack,
        onPrevPressed: _prevTrack,
        
        // Позиция и длительность
        position: position,
        duration: duration,
        onPositionChanged: (value) {
          setState(() {
            _dragPosition = value;
          });
          player.seek(Duration(seconds: value.toInt()));
          Future.delayed(const Duration(milliseconds: 300), () {
            _dragPosition = null;
          });
        },
        
        // Громкость
        volume: _volume,
        onVolumeChanged: (value) {
          setState(() {
            _volume = value;
          });
          player.setVolume(value);
        },
      ),
      // Кнопка добавления музыки
      floatingActionButton: AddTrackButton(
        onTracksAdded: _addTracks,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}