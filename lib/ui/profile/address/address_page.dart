import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:wy/api/address_api.dart';
import 'package:wy/common/getx_list_controller.dart';
import 'package:wy/model/address_model.dart';
import 'package:wy/ui/common/base_scaffold.dart';
import 'package:wy/ui/common/empty_view.dart';
import 'package:wy/ui/common/floating_button.dart';
import 'package:wy/ui/profile/address/default_address.dart';
import 'package:wy/ui/profile/address/address_item.dart';
import 'package:wy/ui/profile/address/edit_address_page.dart';

class AddressPage extends StatelessWidget {
  final bool select;

  AddressPage({required this.select});

  final controller = Get.put(AddressPageController());

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: "My Address".tr,
      body: Obx(() {
        if (controller.initializing.value) {
          return Container();
        }
        if (controller.list.length == 0) {
          return Stack(
            children: [Positioned(left: 0, right: 0, top: 0, bottom: 0, child: EmptyView())
            ],
          );
        }
        return ListView.separated(
          controller: controller.scrollController,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: DefaultAddress(selectable: false,addressModel: controller.defaultAddress.value,),
              );
            }
            AddressModel address = controller.list[index - 1];
            return AddressItem(
              address: address,
              onEdit: () => gotoEditPage(true, address:address),
              onTap: ()=> select ? Get.back(result: address) : null,
            );
          },
          separatorBuilder: (context, index) {
            return Container(height: 15,);
          },
          itemCount: controller.list.length + 1
        );
      }),
      floatingActionButton: Obx(()=>
      controller.floatingActionButtonShow.value ? FloatingButton(label: "NEW ADDRESS".tr, onTap: () => gotoEditPage(false)) : Container()),
    );
  }

  void gotoEditPage(bool edit, {AddressModel? address}) {
    Get.to(()=>EditAddressPage(edit: edit, address: address,))?.then((value){
        if(value != null && value == true) {
          controller.reload();
        }
    });
  }
}

class AddressPageController extends GetxListController<AddressModel> {

  late ScrollController scrollController;
  late var floatingActionButtonShow = true.obs;
  late double offset = 0;

  Rx<AddressModel> defaultAddress = AddressModel().obs;

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
  void onReady() {
    scrollController.addListener(() {
      if (scrollController.offset - offset > 0) { //down
        if (floatingActionButtonShow.value) {
          floatingActionButtonShow.value = false;
        }
      } else { //up
        if (!floatingActionButtonShow.value) {
          floatingActionButtonShow.value = true;
        }
      }
      offset = scrollController.offset;
    });
    super.onReady();
  }

  Future<List<AddressModel>> loadData() async {
    List<AddressModel> addressList = [];
    EasyLoading.show();
    addressList = await AddressApi.list();
    EasyLoading.dismiss();
    if(addressList.length > 0) {
      defaultAddress.value = addressList.firstWhere((element) => element.useDefault, orElse:()=>addressList.first);
    }
    return addressList;
  }
}