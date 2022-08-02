
import 'package:wy/config/app_config.dart';

class BannerModel  {
  late String image;
  late String content;

  BannerModel();

  BannerModel.fromJson(Map<String, dynamic> json) {
    image = json['image'] == null ? AppConfig.noImage : json['image'];
    content = json['content'];
  }
}