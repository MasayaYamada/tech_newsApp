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
      body: Center(
        child: OrientationBuilder(
          builder: (context, orientation) => _listViewWidget(
              context,
              orientation == Orientation.portrait
                  ? Axis.vertical
                  : Axis.horizontal),
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

  Widget _listViewWidget(BuildContext context, Axis direction) {
    return ListView.builder(
      scrollDirection: direction,
      itemCount: savedNews.length == 0 ? 0 : savedNews.length - 1,
      itemBuilder: (context, index) {
        final Axis slideDirection = direction == Axis.horizontal ? Axis.vertical : Axis.horizontal;
        return _getSlideWithLists(context, index, slideDirection);
      },
    );
  }

  Widget _getSlideWithLists(BuildContext context, int index, Axis direction){
    return Slidable.builder(
      key: Key(savedNews[index].id),
      controller: slidableController,
      direction: direction,

      dismissal: SlidableDismissal(
        child: SlidableDrawerDismissal(),
        onDismissed: (actionType) {
          setState(() {
            savedNews.removeAt(index);
            if (index == 0 ){
              _delete(savedNews[0].id);
            } else if(index + 1 == savedNews.length - 1){
              _delete(savedNews[savedNews.length - 1].id);
            } else {
              _delete(savedNews[index].id);
            }
          });
        },
      ),
      child: CardListItems(savedNews: savedNews, index: index),
      secondaryActionDelegate: SlideActionBuilderDelegate(
          actionCount: 1,
          builder: (context, index, animation, renderingMode) {
            return IconSlideAction(
              caption: 'Delete',
              color: renderingMode == SlidableRenderingMode.slide
                  ? Colors.red.withOpacity(animation.value)
                  : Colors.red,
              icon: Icons.delete,
              onTap: ((){
                setState(() {
                  savedNews.removeAt(index);
                  _delete(savedNews[index].id);
                });
              }),
            );
          }
      ), actionPane: SlidableScrollActionPane(),
    );
  }
  void _delete(id) async {
    // Assuming that the number of rows is the id for the last row.
    final rowsDeleted = await dbHelper.delete(id);
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
            MaterialPageRoute(
                builder: (context) =>
                    WebViewScreen(url: savedNews[index].url)),
          );
        },
      ),
    );
  }
}