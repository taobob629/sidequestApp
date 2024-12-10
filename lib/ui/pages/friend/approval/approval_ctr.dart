import 'package:get/get.dart';

import '../../../../api/wy_http.dart';
import '../../../../model/friend_model.dart';
import '../../../../utils/toast_utils.dart';

class ApprovalCtr extends GetxController {
  static ApprovalCtr get find => Get.find();

  var friendList = <FriendModel>[].obs;

  @override
  void onInit() {
    super.onInit();

    requestData();
  }

  void requestData() async {
    showLoading();
    final response = await http.get('/app/point/approval/list');
    dismissLoading();

    friendList.value = response.data
        .map<FriendModel>((item) => FriendModel.fromJson(item))
        .toList();
  }
}
