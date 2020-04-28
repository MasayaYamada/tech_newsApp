import 'package:flutter/material.dart';
import 'fetch_newsdata.dart';
import 'webview_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {

  @override
  _Home createState() => _Home();

}

class _Home extends State<Home> {

  PageController _pageController;

  int _selectedIndex = 0;
  List<bool> _isFavorite = List.generate(20, (i)=>false);
  List<NewsFavorite> _savedFavorite = new List<NewsFavorite>();

  // Animation controller init method
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tech News App'),
      ),
      body: FutureBuilder(
          future: fetchNewsData(),
          builder: (context, snapshot) {
            return snapshot.data != null
                ? listViewWidget(snapshot.data)
                : Center(child: CircularProgressIndicator());
          }),
    );
  }

  Widget listViewWidget(List<NewsDataList> article) {
    return Container(
      child: ListView.builder(
          itemCount: 20,
          padding: const EdgeInsets.all(2.0),
          itemBuilder: (BuildContext context, int position) {
            return Card(
              child: ListTile(
                title: Text(
                  '${article[position].title}',
                  style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    child: article[position].urlToImage == null
                        ? Image(
                      image: AssetImage('assets/image/noImage.png'),
                    )
                        : Image.network('${article[position].urlToImage}'),
                    height: 100.0,
                    width: 100.0,
                  ),
                ),
                trailing: _favoriteIconButton(context, position, article[position].title, article[position].url, article[position].urlToImage),
                onTap: () {
                  print(article[position].url);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => WebViewScreen(url: article[position].url)),
                  );
                },
              ),
            );
          }),
    );
  }

  IconButton _favoriteIconButton( BuildContext context, int position, String title, String url, String urlToImage, {IconData iconData}){
    print('_isFavorite on favoButton function is $_isFavorite');
    print('position is $position');
    return(
        IconButton(
          icon: Icon(
            _isFavorite[position] == true ? Icons.favorite : Icons.favorite_border,
            color: _isFavorite[position] == true ? Colors.red : null,
          ),
          onPressed: (){
            setState(() {
              if(_isFavorite[position] == false) {
                _isFavorite[position] = true;
                saveNewsData(title, url, urlToImage);
              } else {
                _isFavorite[position] = false;
                removeNewsData(title, url, urlToImage);
              }
            });
          },
        )
    );
  }

  void saveNewsData(String title, String url, String urlToImage) async{
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('title', title);
      prefs.setString('url', url);
      prefs.setString('urlToImage', urlToImage);
  }

  void removeNewsData(String title, String url, String urlToImage) async{
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('title');
    prefs.remove('url');
    prefs.remove('urlToImage');
  }


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}