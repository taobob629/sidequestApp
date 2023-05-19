import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../api/user_api.dart';
import '../../../common/getx_refresh_controller.dart';
import '../../../model/vistor_model.dart';

class TaskCtr extends GetxRefreshController<VisitorModel>
    with GetSingleTickerProviderStateMixin {

  @override
  void onInit() {
    super.onInit();
  }

  @override
  Future<List<VisitorModel>> loadData({int pageNum = 1}) async {
    return await UserApi.visitorList(pageNum, 20);
  }
}
