import 'package:flutter/material.dart';
import '../models/track.dart';

class TrackList extends StatefulWidget {
  final List<Track> tracks;
  final int? currentTrackIndex;
  final Function(int)? onTrackSelected;
  final bool showAddButton;
  final Function()? onAddTrackPressed;

  const TrackList({
    Key? key,
    required this.tracks,
    this.currentTrackIndex,
    this.onTrackSelected,
    this.showAddButton = false,
    this.onAddTrackPressed,
  }) : super(key: key);

  @override
  _TrackListState createState() => _TrackListState();
}

class _TrackListState extends State<TrackList> {
  @override
  Widget build(BuildContext context) {
    if (widget.tracks.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.music_note,
            size: 64,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            'No tracks added yet',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[400],
            ),
          ),
          if (widget.showAddButton) ...[
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: widget.onAddTrackPressed,
              icon: Icon(Icons.add),
              label: Text('Add Track'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ],
      );
    }

    return ListView.builder(
      itemCount: widget.tracks.length,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        final track = widget.tracks[index];
        final isCurrentTrack = index == widget.currentTrackIndex;

        return Card(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          color: isCurrentTrack ? Colors.blue[100] : null,
          child: ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Icon(
                Icons.music_note,
                color: Colors.grey[600],
                size: 20,
              ),
            ),
            title: Text(
              track.title,
              style: TextStyle(
                fontWeight: isCurrentTrack ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            subtitle: Text(
              track.artist,
              style: TextStyle(
                color: isCurrentTrack ? Colors.blue[800] : null,
              ),
            ),
            trailing: Text(
              'MP3',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            onTap: () {
              widget.onTrackSelected?.call(index);
            },
            selected: isCurrentTrack,
            selectedColor: Colors.blue,
          ),
        );
      },
    );
  }
}