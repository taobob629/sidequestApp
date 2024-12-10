import 'package:get/get.dart';

import '../../../api/wy_http.dart';
import '../../../common/web_page.dart';
import '../../../controller/user_controller.dart';
import '../../../model/game_account_model.dart';
import '../../../utils/toast_utils.dart';
import '../../dialog/dialog_confirm.dart';

class SearchFriendCtr extends GetxController {

  @override
  void onInit() {
    super.onInit();

    requestData();
  }

  void requestData() async {
    showLoading();
    final response = await http.get('/peiwan/app/new/home/lol/user/list');
    // final response = await http.get('/peiwan/app/profile/connections/list');
    dismissLoading();
  }

  void searchFriend() async {

  }
}
