import 'package:flutter/material.dart';
import 'package:technewsapp/saved_newsdata.dart';
import 'dbhealper.dart';

class Favorite extends StatefulWidget {

  @override
  _Favorite createState() => _Favorite();
}

class _Favorite extends State<Favorite> {

  List<SavedNews> savedNews = [];

  final dbHelper = DatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {
    _queryAll();
    return Scaffold(
      appBar: AppBar(
        title: Text("Favorite"),
      ),
      body: Container(
        child: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: savedNews.length + 1,
          itemBuilder: (BuildContext context, int index) {
            if (index == savedNews.length) {
              return RaisedButton(
                child: Text('Refresh'),
                onPressed: () {
                  setState(() {
                    _queryAll();
                  });
                },
              );
            }
            return Container(
              height: 40,
              child: Center(
                child: Text(
                  '[${savedNews[index].title}]',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            );
          },
        ),
    ),
    );
  }

  void _queryAll() async {
    final allRows = await dbHelper.queryAllRows();
//    savedNews.clear();
    allRows.forEach((row) => savedNews.add(SavedNews.fromMap(row)));
    print('Query done.');
    setState(() {});
  }

}