import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/getx_list_controller.dart';
import '../../../../model/balance_record_model.dart';
import '../../../common/base_scaffold.dart';
import '../../../common/empty_view.dart';
import 'balance_record_item.dart';

class BalanceRecordPage extends StatelessWidget {

  final controller = Get.put(BalanceRecordPageController());

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: "Balance Records",
      body: Stack(
        children: [
          Positioned(
            left: 0,right: 0,top: 0,bottom: 0,
            child: Obx(()=>controller.initializing.value ? Container() : controller.list.length == 0? EmptyView():
            ListView.separated(
              itemBuilder: (context, index){
                BalanceRecordModel model = controller.list[index];
                return BalanceRecordItem(model: model,);
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

class BalanceRecordPageController extends GetxListController<BalanceRecordModel> {
  @override
  Future<List<BalanceRecordModel>> loadData() async {
    List<BalanceRecordModel> list = [];
    return list;
  }

}