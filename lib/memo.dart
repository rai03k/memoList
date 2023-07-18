import 'package:flutter/material.dart';

class MemoPage extends StatefulWidget {
  final String title;
  const MemoPage({super.key, required this.title});

  @override
  State<MemoPage> createState() => _MemoPage();
}

class _MemoPage extends State<MemoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Memo"),
      ),
      body: Container(
        child: Text(widget.title),
      ),
    );
  }
}
