import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:wy/api/shop_api.dart';
import 'package:wy/common/getx_list_controller.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/config/icon_font.dart';
import 'package:wy/model/product_item_model.dart';
import 'package:wy/ui/shop/product_item.dart';

class SearchPage extends StatelessWidget {

  final controller = Get.put(SearchPageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 0,
        title: Container(
          height: 40,
          padding: const EdgeInsets.only(left: 5),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white10),
            borderRadius: BorderRadius.circular(8)
          ),
          child: TextField(
            maxLines: 1,
            focusNode: controller.focusNode,
            controller: controller.controller,
            cursorColor: Colors.white70,
            textAlign: TextAlign.start,
            textInputAction: TextInputAction.search,
            style: const TextStyle(color: Colors.white, fontSize: 16),
            onSubmitted: (text) => controller.reload(),
            decoration: const InputDecoration(
              hintText: "Search anything you want to buy",
              hintStyle: TextStyle(fontSize: 14, color: Colors.white30),
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(bottom: 12)
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 15,right: 15),
            child: GestureDetector(
              child: Icon(IconFonts.search,size: 26,color: Colors.white,),
              onTap: ()=>controller.reload(),
            )
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              sliver: Obx(() {
                return SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                      ProductItemModel product = controller.list[index];
                      return ProductItem(product);
                    },
                    childCount: controller.list.length
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 90 / 160
                  )
                );
              }),
            )
          ],
        )
      ),
    );
  }
}

class SearchPageController extends GetxListController<ProductItemModel> {

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
  void onReady(){
    super.onReady();
    focusNode.requestFocus();
  }

  @override
  Future<List<ProductItemModel>> loadData() async{
    String key = controller.text;
    if(key.isEmpty){
      return [];
    }
    EasyLoading.show();
    List<ProductItemModel> list = await ShopApi.search(key);
    EasyLoading.dismiss();
    return list;
  }

}