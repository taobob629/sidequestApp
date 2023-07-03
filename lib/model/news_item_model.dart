
class NewsItemModel {
  late int id;
  late String title;
  late List<String> imageList;
  late String time;
  late int addtime;

  NewsItemModel();

  NewsItemModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    addtime = json['addtime'];
    title = json['title'];
    imageList = json['imageList'] == null ? [] : (json['imageList'] as List).map<String>((e) => e.toString()).toList();
    time = json['time'];
  }
}

class NewsContent {
  late int type;
  late String content;
}