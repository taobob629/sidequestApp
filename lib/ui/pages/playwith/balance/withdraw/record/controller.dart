/*
    controller
    sidequest_hub_app
    desc:
    Created by chunma on .
    Copyright © sidequest_hub_app. All rights reserved.
 **/
import '../../../../../../api/balance_api.dart';
import '../../../../../../api/wy_http.dart';
import '../../../../../../common/getx_refresh_controller.dart';
import '../../../../../../model/withdraw_record_model.dart';
import '../../../../../../utils/toast_utils.dart';

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
    showLoading();
    await http.post('/peiwan/app/withDrawal/cancel', data: {"id": id});
    dismissLoading();

    onRefresh();
  }
}
