import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:share/share.dart';

class WebViewScreen extends StatefulWidget {

  WebViewScreen({this.url});
  final String url;

  String get newsType => null;

  @override
  _WebViewScreen createState() => _WebViewScreen(url: url);
}

class _WebViewScreen extends State<WebViewScreen> {

  _WebViewScreen({this.url});
  final String url;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      appBar: AppBar(
          actions: <Widget>[
      // action button
         IconButton(
          icon: Icon(Icons.share),
          onPressed: () {
              Share.share(url);
           },
         ),
      ],
      ),
      url: url,
    );
  }
}