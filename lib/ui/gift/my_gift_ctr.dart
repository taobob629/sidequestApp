import 'package:get/get.dart';
import 'package:wy/api/wy_http.dart';
import 'package:wy/ui/controller/user_controller.dart';

import '../../../common/getx_refresh_controller.dart';
import '../../../model/beans/order_status_bean.dart';
import '../../../utils/toast_utils.dart';
import '../../model/gift_model.dart';

class MyGiftCtr extends GetxRefreshController<GiftListModel> {
  var ifScaleBigReceived = true.obs;

  int selectStatus = -10;

  List<OrderStatusBean> orderStatusList = [
    OrderStatusBean(statusName: 'All'.tr, status: -10),
    OrderStatusBean(statusName: 'Completed'.tr, status: -2),
    OrderStatusBean(statusName: 'Ongoing'.tr, status: 2),
    OrderStatusBean(statusName: 'Refund Dispute'.tr, status: 6),
    OrderStatusBean(statusName: 'Cancelled'.tr, status: -1),
  ];

  @override
  void onInit() {
    super.onInit();

    ifScaleBigReceived.value = UserController.find.userProfile.isAuth == 1;
  }

  @override
  Future<List<GiftListModel>> loadData({int pageNum = 1}) async {
    List<GiftListModel> list = [];
    int type = 0;
    if (!ifScaleBigReceived.value) {
      type = 1;
    }
    showLoading();

    String url = '/peiwan/app/gift/list?type=$type';
    var response = await http.get(url,
        queryParameters: ({'pageNum': pageNum, 'pageSize': pageSize}));
    if (response.data == null) {
      return list;
    }
    var giftModel = GiftModel.fromJson(response.data);
    list = giftModel.rows;
    dismissLoading();
    return list;
  }
}
