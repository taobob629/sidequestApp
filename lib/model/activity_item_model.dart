import 'package:wy/config/app_config.dart';

class ActivityItemModel {
  late int id = 0;
  late String title = "";
  late String image = AppConfig.noImage;
  late String time = "";
  late bool inProgress = false;
  late int addtime = 0;
  late int matchDiff = 0;
  int showCountdown = 0; //0不显示1显示
  showCounter() {
    return showCountdown == 1 &&
        DateTime.now().millisecondsSinceEpoch < addtime * 1000; //已经过期了
  }

  ActivityItemModel();

  ActivityItemModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    addtime = json['addtime'] ?? 0;
    matchDiff = json['matchDiff'] ?? 0;
    showCountdown = json['showCountdown'] ?? 0;
    title = json['title'];
    image = json['image'] == null ? AppConfig.noImage : json['image'];
    time = json['time'];
  }
}
