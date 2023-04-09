import 'package:flutter/material.dart';
import 'progress.dart';
import 'progress_service.dart';

class ProgressScreen extends StatefulWidget {
  @override
  _ProgressScreenState createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  List<Progress> _progressList = [];

  Future<void> _loadProgress() async {
    final progressList = await ProgressService.loadProgressList() as List<Progress>;
    setState(() {
      _progressList = progressList;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Progress'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: _progressList.length,
          itemBuilder: (BuildContext context, int index) {
            final progress = _progressList[index];
            return Card(
              child: ListTile(
                title: Text(progress.word),
                // subtitle: Text(progressdefinition),
                trailing: Text(progress.date),
              ),
            );
          },
        ),
      ),
    );
  }
}
