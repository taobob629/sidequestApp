
import '../config/app_config.dart';

class NewsDetailModel {
  late String title;
  late String image;
  late String author;
  late String time;
  late String content;

  NewsDetailModel();

  NewsDetailModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    image = json['image'] == null ? AppConfig.noImage : json['image'];
    author = json['author'];
    time = json['time'];
    content = json['content'];
  }
}