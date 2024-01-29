import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  final List<String> historyEquations;
  final List<String> historyResults;

  HistoryScreen({required this.historyEquations, required this.historyResults});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Historia Działań'),
      ),
      body: ListView.builder(
        itemCount: historyEquations.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(historyEquations[index]),
            subtitle: Text(historyResults[index]),
            onTap: () {
              Navigator.pop(context, historyEquations[index]);
            },
          );
        },
      ),
    );
  }
}
