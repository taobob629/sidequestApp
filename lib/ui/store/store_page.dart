import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:wy/common/getx_list_controller.dart';

import '../../model/store_model.dart';
import '../../utils/toast_utils.dart';
import '../common/base_scaffold.dart';
import '../common/empty_view.dart';
import 'store_item.dart';

class StorePage extends StatelessWidget {

  final controller = Get.put(StorePageController());

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: "Stores".tr,
      body: Stack(
        children: [
          Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 0,
              child: Obx(() => controller.initializing.value
                  ? Container()
                  : controller.list.length == 0
                      ? EmptyView()
                      : ListView.separated(
                          controller: controller.scrollController,
                          itemBuilder: (context, index) {
                            StoreModel model = controller.list[index];
                            return StoreItem(
                              model: model,
                );
              },
              separatorBuilder: (context, index){
                return Container(height: 15,);
              },
              itemCount: controller.list.length
            ))
          )
        ],
      ),
    );
  }
}

class StorePageController extends GetxListController<StoreModel> {
  late ScrollController scrollController;

  @override
  void onInit() {
    super.onInit();
    scrollController = ScrollController();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  @override
  Future<List<StoreModel>> loadData() async{
    showLoading();
    List<StoreModel> list = [];
    dismissLoading();
    return list;
  }

}