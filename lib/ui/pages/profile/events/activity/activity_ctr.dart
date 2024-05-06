/**
    author:mac
    创建日期:2023/2/17
    描述:
 */
import 'package:dio/src/response.dart' as dio;

import '../../../../../api/network_method.dart';
import '../../../../../common/refreshlist_controller.dart';
import '../../../../../model/activity_list_model.dart';

class ActivityCtr extends RefreshListController<ActivityListModel> {

  ActivityCtr();

  @override
  buildMethodType() {
    return NWMethod.GET;
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  Map<String, dynamic> buildParams() => {
          'pageNum': page,
          'pageSize': pageSize,
          'matchDiff': 1,
        };

  @override
  String buildUrl() {
    return '/app/events/26/userActivities';
  }

  @override
  bool paged() => true;

  @override
  List<ActivityListModel> dealData(dio.Response<dynamic> response) {
    return response.data
        .map<ActivityListModel>((item) => ActivityListModel.fromJson(item))
        .toList();
  }

  @override
  needAutoLoadData() => true;
}
