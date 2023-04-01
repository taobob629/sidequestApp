import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/model/address_model.dart';
import 'package:wy/ui/common/base_scaffold.dart';
import 'package:wy/ui/common/empty_view.dart';
import 'package:wy/ui/common/floating_button.dart';
import 'package:wy/ui/profile/address/list/address_item.dart';
import 'package:wy/ui/profile/address/edit/edit_address_page.dart';

import 'controller.dart';

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
            children: [Positioned(left: 0, right: 0, top: 0, bottom: 0, child: EmptyView())],
          );
        }
        return ListView.separated(
            controller: controller.scrollController,
            itemBuilder: (context, index) {
              // if (index == 0) {
              //   return Padding(
              //     padding: const EdgeInsets.symmetric(horizontal: 15),
              //     child: DefaultAddress(selectable: false,addressModel: controller.defaultAddress.value,),
              //   );
              // }
              AddressModel address = controller.list[index];
              return AddressItem(
                address: address,
                onEdit: () => gotoEditPage(true, address: address),
                onTap: () => select ? Get.back(result: address) : null,
              );
            },
            separatorBuilder: (context, index) => 15.verticalSpace,
            itemCount: controller.list.length);
      }),
      floatingActionButton: Obx(() => controller.floatingActionButtonShow.value
          ? FloatingButton(label: "NEW ADDRESS".tr, onTap: () => gotoEditPage(false))
          : Container()),
    );
  }

  void gotoEditPage(bool edit, {AddressModel? address}) {
    Get.to(() => EditAddressPage(
          edit: edit,
          address: address,
        ))?.then((value) {
      if (value != null && value == true) {
        controller.reload();
      }
    });
  }
}
