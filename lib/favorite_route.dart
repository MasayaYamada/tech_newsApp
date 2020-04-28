import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Favorite extends StatefulWidget {

  @override
  _Favorite createState() => _Favorite();
}

class _Favorite extends State<Favorite> {

  Future<String> url;
  Future<String> title;
  Future<String> urlToImage;

  @override
  Widget build(BuildContext context) {
    url = _getURL();
    title = _getTitle();
    urlToImage = _getUrlToImage();
    print('url is $url');
    print('title is $title');
    print('urlToImage is $urlToImage');

    return Scaffold(
      appBar: AppBar(
        title: Text("Favorite"),
      ),
      body: Center(
          child: Text("ホゲホゲ"),
      ),
    );
  }

  Future<String> _getURL() async {
      String url;
      final prefs = await SharedPreferences.getInstance();
      url = (prefs.getString('url') ?? null);
      print('url is $url');
      return url;
    }

  Future<String> _getTitle() async {
     String title;
     final prefs = await SharedPreferences.getInstance();
     title = (prefs.getString('title') ?? null);
     print('title is $title');
     return title;
    }

  Future<String> _getUrlToImage() async {
     String urlToImage;
     final prefs = await SharedPreferences.getInstance();
     urlToImage = (prefs.getString('urlToString') ?? null);
     print('urlToImage is $urlToImage');
     return urlToImage;
    }

}