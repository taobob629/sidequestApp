import 'package:get/get.dart';
import 'package:wy/utils/toast_utils.dart';

import '../../api/wy_http.dart';
import '../../model/my_gift_detail_model.dart';

class MyGiftDetailCtr extends GetxController {
  late Map params;
  MyGiftDetailModel? model;

  @override
  void onInit() {
    super.onInit();
    params = Get.arguments as Map;

    _requestData();
  }

  void _requestData() async {
    showLoading();
    String url = '/peiwan/app/gift/orderDetail?id=${params['id']}&type=${params['type']}';
    var response = await http.get(url);
    model = MyGiftDetailModel.fromJson(response.data);
    dismissLoading();
    update();
  }
}
