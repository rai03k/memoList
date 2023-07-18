import 'package:flutter/material.dart';
import 'package:todolist/memo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _memoList = ['title', 'title2', 'title3'];
  var _titleController = TextEditingController();

  Future<void> InputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("タイトル"),
            content: TextField(
              decoration: InputDecoration(hintText: "ここに入力"),
              controller: _titleController,
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("キャンセル"),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _memoList.add(_titleController.text);
                  });
                  Navigator.pop(context);
                },
                child: Text("OK"),
              ),
            ],
          );
        });
  }

  Widget _listTile(String title) {
    return Column(
      children: <Widget>[
        ListTile(
            title: Text(title),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return MemoPage(title: title);
                  },
                ),
              );
            }),
        const Divider(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Home"),
      ),
      body: ListView.builder(
          itemCount: _memoList.length,
          itemBuilder: (context, index) {
            return _listTile(_memoList[index]);
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          InputDialog(context);
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
