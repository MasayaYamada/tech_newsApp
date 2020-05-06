import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class NewsDataList {

  final String title;
  final String url;
  final String urlToImage;

  NewsDataList({this.title, this.url, this.urlToImage});

  factory NewsDataList.fromJson(Map<String, dynamic> json) {
    return NewsDataList(
      title: json['title'] as String,
      url: json['url'] as String,
      urlToImage: json['urlToImage'] as String,
    );
  }
}


Future<List<NewsDataList>> fetchNewsData() async {

  List<NewsDataList> list;
  String url = "http://newsapi.org/v2/top-headlines?country=jp&category=technology&apiKey=f289d460a5f94d4087d54cd187becceb";
  var res = await http.get(Uri.encodeFull(url), headers: {"Accept": "application/json"});

  print(res.body);

  if(res.statusCode == 200){
    var data = json.decode(res.body);
    var rest = data["articles"] as List;
    print(rest);
    list = rest.map<NewsDataList>((json) => NewsDataList.fromJson(json)).toList();
    return list;
  } else {
    throw Exception('Failed to load album');
  }
}

