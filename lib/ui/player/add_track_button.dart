import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../models/track.dart';

class AddTrackButton extends StatelessWidget {
  final Function(List<Track>)? onTracksAdded;

  const AddTrackButton({
    Key? key,
    this.onTracksAdded,
  }) : super(key: key);

  Future<void> _pickAndAddTrack(BuildContext context) async {
    try {
      // Platform-specific file picking
      FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['mp3'],
          allowMultiple: true,
        );

      if (result != null) {
        List<PlatformFile> files = result.files;
        List<Track> newTracks = [];

        for (PlatformFile file in files) {
          if (file.extension?.toLowerCase() == 'mp3' && file.path != null) {
            Track track = Track(
              title: _getFileNameWithoutExtension(file.name),
              artist: 'Unknown Artist', // Default artist for local files
              url: file.path!, // Using the local file path
            );
            newTracks.add(track);
          }
        }

        if (newTracks.isNotEmpty) {
          onTracksAdded?.call(newTracks);
          
          // Show success message
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${newTracks.length} track(s) added successfully'),
                backgroundColor: Colors.green,
              ),
            );
          }
        } else {
          // Show message if no valid files were selected
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('No valid MP3 files were selected'),
                backgroundColor: Colors.orange,
              ),
            );
          }
        }
      }
    } catch (e) {
      // Handle any errors during file picking
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking files: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _getFileNameWithoutExtension(String fileName) {
    int lastDotIndex = fileName.lastIndexOf('.');
    if (lastDotIndex != -1) {
      return fileName.substring(0, lastDotIndex);
    }
    return fileName;
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _pickAndAddTrack(context),
      tooltip: 'Add Track',
      backgroundColor: Colors.blue,
      child: Icon(
        Icons.add,
        color: Colors.white,
      ),
    );
  }
}