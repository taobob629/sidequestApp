import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:wy/api/balance_api.dart';
import 'package:wy/api/wy_http.dart';
import 'package:wy/common/getx_refresh_controller.dart';
import 'package:wy/model/withdraw_record_model.dart';

/*
    controller
    sidequest_hub_app
    desc:
    Created by chunma on .
    Copyright © sidequest_hub_app. All rights reserved.
 **/
class WithDrawRecordPageController extends GetxRefreshController {
  var type;

  WithDrawRecordPageController(this.type);

  @override
  void onInit() {
    initialRefresh = true;
    super.onInit();
  }

  @override
  Future<List<WithdrawRecordModel>> loadData({int pageNum = 1}) async {
    var list = await BalanceApi.withDrawRecords(pageNum, pageSize);
    return list;
  }

  void cancelWithDraw(id) async {
    EasyLoading.show();
    await http.post('/peiwan/app/withDrawal/cancel', data: {"id": id});
    EasyLoading.dismiss();

    onRefresh();
  }
}
