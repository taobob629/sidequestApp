import 'package:sq_hub_app/api/wy_http.dart';

import '../model/notification_model.dart';

class NotificationApi {
  static Future<List<NotificationModel>> list(int pageNum, int pageSize) async {
    var response = await http.get('/app/message/list',
        queryParameters: ({'pageNum': pageNum, 'pageSize': pageSize}));
    List<NotificationModel> list = response.data
        .map<NotificationModel>((item) => NotificationModel.fromJson(item))
        .toList();
    return list;
  }

  static Future<void> notifySetting(int setting) async {
    var response = await http.get('/sideQuest/app/sq/user/notifySetting',
        queryParameters: ({'setting': setting}));
  }
}
