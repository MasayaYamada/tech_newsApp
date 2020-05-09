import 'package:flutter/material.dart';
import 'package:technewsapp/saved_newsdata.dart';
import 'package:technewsapp/dbhealper.dart';
import 'webview_screen.dart';
import 'package:flutter_slidable/flutter_slidable.dart';


class Favorite extends StatefulWidget {

  @override
  _Favorite createState() => _Favorite();
}

class _Favorite extends State<Favorite> {

  List<SavedNews> savedNews = [];

  final dbHelper = DatabaseHelper.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _queryAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favorite"),
      ),
      body: Container(
        child: ListView.builder(
          padding: const EdgeInsets.all(2.0),
          itemCount: savedNews.length,
          itemBuilder: (BuildContext context, int index) {
            if (savedNews.length == 0){
              return Center(child: Text('データがありません'));
            } else if (index == savedNews.length) {
              setState(() {
                _queryAll();
              });
            }
            return Card(
              child: ListTile(
                 title: Text(
                  '${savedNews[index].title}',
                  style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    child: savedNews[index].urlToImage == null
                        ? Image(
                      image: AssetImage('assets/image/noImage.png'),
                    )
                        : Image.network('${savedNews[index].urlToImage}'),
                    height: 100.0,
                    width: 100.0,
                  ),
                ),
                onTap: () {
                  print(savedNews[index].url);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => WebViewScreen(url: savedNews[index].url)),
                  );
                },
              ),
            );
          },
        ),
    ),
    );
  }

  void _queryAll() async {
    final allRows = await dbHelper.queryAllRows();
    allRows.forEach((row) => savedNews.add(SavedNews.fromMap(row)));
    print('Query done.');
    setState(() {});
  }

}
