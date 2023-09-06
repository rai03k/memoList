import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/data.dart';
import 'package:todolist/memo.dart';

import 'dbHelper.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

final memoProvider = ((_) => '');

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

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  final _memoTitleList = ['title', 'title2', 'title3'];
  late String _memo;
  var _titleController = TextEditingController();

  // DatabaseHelper クラスのインスタンス取得
  final dbHelper = DatabaseHelper.instance;

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
                    _memoTitleList.add(_titleController.text);
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
            subtitle: Text(""),
            onTap: () async {
              Data data = Data(title: title, memo: "");
              var memo = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return MemoPage(data: data);
                  },
                ),
              );
              setState(() {
                data.memo = memo;
              });
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
          itemCount: _memoTitleList.length,
          itemBuilder: (context, index) {
            return _listTile(_memoTitleList[index]);
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

  void _insert() async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnName: '山田　太郎',
      DatabaseHelper.columnAge: 35,
      DatabaseHelper.columnHoge: 1
    };
    final id = await dbHelper.insert(row);
    print('登録しました。id: $id');
  }

  // 照会ボタンクリック
  void _query() async {
    final allRows = await dbHelper.queryAllRows();
    print('全てのデータを照会しました。');
    allRows.forEach(print);
  }

  // 更新ボタンクリック
  void _update() async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnId: 1,
      DatabaseHelper.columnName: '鈴木　一郎',
      DatabaseHelper.columnAge: 48
    };
    final rowsAffected = await dbHelper.update(row);
    print('更新しました。 ID：$rowsAffected ');
  }

  // 削除ボタンクリック
  void _delete() async {
    final id = await dbHelper.queryRowCount();
    final rowsDeleted = await dbHelper.delete(id!);
    print('削除しました。 $rowsDeleted ID: $id');
  }
}
