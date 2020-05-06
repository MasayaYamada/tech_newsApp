import 'dbhealper.dart';

class SavedNews {

  String id;
  String title;
  String url;
  String urlToImage;

  SavedNews({this.id, this.title, this.url, this.urlToImage});

  SavedNews.fromMap(Map<String, dynamic> map){
    id = map['id'];
    title = map['title'];
    url = map['url'];
    urlToImage = map['urlToImage'];
  }

  Map<String, dynamic> toMap() {
    return {
      DatabaseHelper.columnId: id,
      DatabaseHelper.columnTitle: title,
      DatabaseHelper.columnUrl: url,
      DatabaseHelper.columnUrlToImage: urlToImage,
    };
  }
}







