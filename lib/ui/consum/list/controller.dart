/**
    author:mac
    创建日期:2023/2/17
    描述:
 */

import 'package:dio/src/response.dart' as dio;
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../api/network_method.dart';
import '../../../common/refreshlist_controller.dart';
import '../../../model/consum_model.dart';
import '../../../utils/utils.dart';
import '../detail/view.dart';

class StoreConsumListPageController
    extends RefreshListController<ConsumListBean> {
  @override
  buildMethodType() {
    return NWMethod.GET;
  }

  @override
  void onInit() {
    super.onInit();
    refreshController = RefreshController();
  }

  @override
  void onClose() {
    super.onClose();
  }

  @override
  Map<String, dynamic> buildParams() => {};

  @override
  String buildUrl() {
    return '/peiwan/app/users/game/list';
  }

  @override
  bool paged() => false;

  @override
  List<ConsumListBean> dealData(dio.Response<dynamic> response) {
    flog('dealData ${response.data}');
    return response.data
        .map<ConsumListBean>((item) => ConsumListBean.fromJson(item))
        .toList();
  }

  @override
  needAutoLoadData() => true;

  toDetail(ConsumListBean item) {
    Get.to(() => StoreConsumDetailPage(),
            arguments: {}
              ..['gameId'] = item.gameId
              ..['gameName'] = item.gameName)
        ?.then((value) {
      if (value == true) onRefresh();
    });
  }
}
