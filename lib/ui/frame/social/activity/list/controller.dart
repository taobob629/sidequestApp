/**
    author:mac
    创建日期:2023/2/17
    描述:
 */
import 'package:dio/src/response.dart' as dio;
import 'package:wy/api/network_method.dart';
import 'package:wy/common/list/index.dart';
import 'package:wy/model/activity_list_model.dart';

class ActivityListController extends RefreshListController<ActivityListModel> {

 ActivityListController();

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
  };

  @override
  String buildUrl() {
    return '/peiwan/app/new/event/eventlist';
  }

  @override
  bool paged() => true;

  @override
  List<ActivityListModel> dealData(dio.Response<dynamic> response) {
    return response.data.map<ActivityListModel>((item) => ActivityListModel.fromJson(item)).toList();
  }

  @override
  needAutoLoadData() => true;
}
