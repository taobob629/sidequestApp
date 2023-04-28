import 'package:flutter/widgets.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:wy/api/user_api.dart';
import 'package:wy/common/getx_list_controller.dart';
import 'package:wy/model/game_user_model.dart';
import 'package:get/get.dart';

import '../../../../utils/toast_utils.dart';
/**
    author:mac
    创建日期:2023/2/2
    描述:
 */
const int SEARCH_TYPE_TOP_MONTH=1;

class SearchUserController extends GetxListController<GameUserModel> {
  late FocusNode focusNode;
  late TextEditingController controller;
  var type;
  @override
  void onInit() {
    super.onInit();
    var args=Get.arguments;
   if(args!=null) type=Get.arguments['type'];
    focusNode = FocusNode();
    controller = TextEditingController();
  }

  @override
  void onClose() {
    controller.dispose();
    focusNode.dispose();
    super.onClose();
  }

  @override
  void onReady() {
    super.onReady();
    focusNode.requestFocus();
  }

  @override
  Future<List<GameUserModel>> loadData() async {
    String key = controller.text;
    if (key.isEmpty) {
      return [];
    }
    showLoading();
    List<GameUserModel> list = await UserApi.search(key,type: type);
    dismissLoading();
    return list;
  }


}
