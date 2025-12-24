import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../models/track.dart';

class AddTrackButton extends StatefulWidget {
  final Function(List<Track>)? onTracksAdded;

  const AddTrackButton({
    Key? key,
    this.onTracksAdded,
  }) : super(key: key);

  @override
  _AddTrackButtonState createState() => _AddTrackButtonState();
}

class _AddTrackButtonState extends State<AddTrackButton> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: _pickAudioFiles,
      child: Icon(Icons.add),
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
    );
  }

  void _pickAudioFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
        allowMultiple: true,
      );

      if (result != null) {
        List<PlatformFile> files = result.files;
        List<Track> tracks = [];

        for (PlatformFile file in files) {
          tracks.add(Track(
            title: file.name,
            artist: 'Unknown Artist',
            url: file.path ?? '', // For local files, we use the path
          ));
        }

        widget.onTracksAdded?.call(tracks);
      }
    } catch (e) {
      print('Error picking files: $e');

      // Fallback to sample tracks if file picking fails (especially important for web)
      _addSampleTracks();
    }
  }

  void _addSampleTracks() {
    // Add some sample tracks for testing
    List<Track> sampleTracks = [
      Track(
        title: 'Sample Track 1',
        artist: 'Sample Artist 1',
        url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
      ),
      Track(
        title: 'Sample Track 2',
        artist: 'Sample Artist 2',
        url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
      ),
      Track(
        title: 'Sample Track 3',
        artist: 'Sample Artist 3',
        url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
      ),
    ];

    widget.onTracksAdded?.call(sampleTracks);
  }
}