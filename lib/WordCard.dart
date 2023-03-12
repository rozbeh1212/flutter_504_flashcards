import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

import 'dart:io';

class WordCard extends StatefulWidget {
  final String word;
  final String definition;

  const WordCard({required this.word, required this.definition, Key? key})
      : super(key: key);

  @override
  _WordCardState createState() => _WordCardState();
}

class _WordCardState extends State<WordCard> {
  bool _isDownloading = false;

  Future<File> _downloadFile(String url, String filename) async {
    final response = await HttpClient().getUrl(Uri.parse(url));
    final bytes = await consolidateHttpClientResponseBytes(response as HttpClientResponse);
    final path =
        '${(await getApplicationDocumentsDirectory()).path}/audio/$filename';
    final file = File(path);
    await file.create(recursive: true);
    await file.writeAsBytes(bytes);
    return file;
  }

Future<void> _playDownloadedFile(String filepath) async {
    final player = AssetsAudioPlayer();
    await player.open(Audio.file(filepath));
    await player.play();
  }

  Future<void> _showDownloadDialog() async {
    setState(() {
      _isDownloading = true;
    });
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Downloading audio file...'),
        content: CircularProgressIndicator(),
      ),
    );
    setState(() {
      _isDownloading = false;
    });
  }

  void _handleAudioButtonPressed() async {
    try {
      // Check if the file is already downloaded
      final fileExists = await File(
              '${(await getApplicationDocumentsDirectory()).path}/audio/${widget.word}.mp3')
          .exists();

      // If it is, play the file
      if (fileExists) {
        await _playDownloadedFile('${widget.word}.mp3');
      }
      // If not, download the file and then play it
      else {
        await _showDownloadDialog();
        final downloadedFile = await _downloadFile(
            'https://example.com/audio/${widget.word}.mp3',
            '${widget.word}.mp3');
        Navigator.pop(context); // Close download dialog
        await _playDownloadedFile(downloadedFile.path);
      }
    } catch (e) {
      print('Error playing audio: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error playing audio')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.word, style: Theme.of(context).textTheme.headline6),
            SizedBox(height: 8.0),
            Text(widget.definition),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (_isDownloading)
                  CircularProgressIndicator()
                else
                  ElevatedButton.icon(
                    icon: Icon(Icons.volume_up),
                    label: Text('Play audio'),
                    onPressed: _handleAudioButtonPressed,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
