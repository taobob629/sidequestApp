/**
    author:mac
    创建日期:2023/2/17
    描述:
 */

import 'package:dio/src/response.dart' as dio;
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wy/api/network_method.dart';
import 'package:wy/common/list/index.dart';
import 'package:wy/config/app_pages.dart';
import 'package:wy/model/consum_model.dart';
import 'package:wy/utils/index.dart';

class StoreConsumDetailPageController
    extends RefreshListController<ConsumListBean> {
  var gameId;

  @override
  buildMethodType() {
    return NWMethod.GET;
  }

  @override
  void onInit() {
    gameId = Get.arguments['gameId'];
    flog('gameId $gameId');
    refreshController = RefreshController();
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  @override
  Map<String, dynamic> buildParams() => Map<String, dynamic>()..['gameId'] = gameId;

  @override
  String buildUrl() {
    return '/peiwan/app/users/game/details';
  }

  @override
  bool paged() => true;

  @override
  List<ConsumListBean> dealData(dio.Response<dynamic> response) {
    return response.data
        .map<ConsumListBean>((item) => ConsumListBean.fromJson(item))
        .toList();
  }

  @override
  needAutoLoadData() => true;

  toDetail(ConsumListBean item) {
    Get.toNamed(AppPages.OrderDetail, arguments: Map()..['id'] = item.id)
        ?.then((value) {
      if (value == true) onRefresh();
    });
  }
}
