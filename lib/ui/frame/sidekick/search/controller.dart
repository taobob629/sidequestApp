import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:wy/api/shop_api.dart';
import 'package:wy/api/user_api.dart';
import 'package:wy/common/getx_list_controller.dart';
import 'package:wy/model/game_user_model.dart';
import 'package:wy/model/product_item_model.dart';
import 'package:wy/model/simple_user_info_model.dart';

/**
    author:mac
    创建日期:2023/2/2
    描述:
 */
class SearchUserController extends GetxListController<GameUserModel> {
  late FocusNode focusNode;
  late TextEditingController controller;

  @override
  void onInit() {
    super.onInit();
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
    EasyLoading.show();
    List<GameUserModel> list = await UserApi.search(key);
    EasyLoading.dismiss();
    return list;
  }


}
