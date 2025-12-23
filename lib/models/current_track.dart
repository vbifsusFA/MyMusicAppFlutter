import 'track.dart';

class CurrentTrack {
  final Track track;
  final int index;
  final bool isPlaying;

  CurrentTrack({
    required this.track,
    required this.index,
    this.isPlaying = false,
  });

  CurrentTrack copyWith({
    Track? track,
    int? index,
    bool? isPlaying,
  }) {
    return CurrentTrack(
      track: track ?? this.track,
      index: index ?? this.index,
      isPlaying: isPlaying ?? this.isPlaying,
    );
  }

  @override
  String toString() {
    return 'CurrentTrack(track: $track, index: $index, isPlaying: $isPlaying)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CurrentTrack &&
        other.track == track &&
        other.index == index &&
        other.isPlaying == isPlaying;
  }

  @override
  int get hashCode => track.hashCode ^ index.hashCode ^ isPlaying.hashCode;
}