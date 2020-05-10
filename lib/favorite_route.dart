import 'package:flutter/material.dart';
import 'package:technewsapp/saved_newsdata.dart';
import 'package:technewsapp/dbhealper.dart';
import 'webview_screen.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

final dbHelper = DatabaseHelper.instance;

class Favorite extends StatefulWidget {
  @override
  _Favorite createState() => _Favorite();
}
class _Favorite extends State<Favorite> {

  SlidableController slidableController;
  List<SavedNews> savedNews = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _queryAll();
  }

  Animation<double> _rotationAnimation;
  Color _fabColor = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favorite"),
      ),
      body: Container(
        child: _ListViewWidget(savedNews: savedNews),
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


class _ListViewWidget extends StatelessWidget {
  const _ListViewWidget({
    Key key,
    @required this.savedNews,
  }) : super(key: key);

  final List<SavedNews> savedNews;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(2.0),
      itemCount: savedNews.length,
      itemBuilder: (BuildContext context, int index) {
        if (savedNews.length == 0) {
          return Center(child: Text('データがありません'));
        }
        return CardListItems(savedNews: savedNews, index: index);
      },
    );
  }
}

class CardListItems extends StatelessWidget {
  final int index;
  final List<SavedNews> savedNews;

  const CardListItems({
    Key key,
    @required this.savedNews,
    @required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: Key(savedNews[index].id),
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      dismissal: SlidableDismissal(
        child: SlidableDrawerDismissal(),
        onDismissed: (actionType) {
            savedNews.removeAt(index);
            // delete from db
          _delete(savedNews[index].id);
        },
      ),
      child: Card(
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
              MaterialPageRoute(
                  builder: (context) =>
                      WebViewScreen(url: savedNews[index].url)),
            );
          },
        ),
      ),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () {
              _delete(savedNews[index].id);
          },
        ),
      ],
    );
  }

  void _delete(id) async {
    // Assuming that the number of rows is the id for the last row.
    final rowsDeleted = await dbHelper.delete(id);
  }

}
