import 'package:get/get.dart';
import 'package:wy/api/wy_http.dart';

import '../../../api/user_api.dart';
import '../../../common/getx_refresh_controller.dart';
import '../../../model/service_list_model.dart';
import '../../../model/vistor_model.dart';

class MyOrdersCtr extends GetxRefreshController<ServiceListModel> {
  var ifScaleBigReceived = true.obs;
  var ifSelectCompleted = true.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  @override
  Future<List<ServiceListModel>> loadData({int pageNum = 1}) async {
    List<ServiceListModel> list = [];
    int type = 2;
    if (!ifScaleBigReceived.value) {
      type = 1;
    }

    String url = '/peiwan/app/new/orders/list?type=$type';
    if (ifSelectCompleted.value) {
      url = '/peiwan/app/new/orders/list?type=$type&status=-2';
    }

    var response = await http.get(url,
        queryParameters: ({'pageNum': pageNum, 'pageSize': pageSize}));
    if (response.data == null) {
      return list;
    }
    list = response.data['rows']
        .map<ServiceListModel>((item) => ServiceListModel.fromJson(item))
        .toList();
    return list;
  }
}
