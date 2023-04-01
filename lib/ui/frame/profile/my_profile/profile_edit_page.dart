import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/model/address_model.dart';
import 'package:wy/ui/common/input_view.dart';
import 'package:wy/ui/common/keyboard_scaffold.dart';
import 'package:wy/ui/controller/user_controller.dart';
import 'package:wy/utils/index.dart';
import 'package:get/get.dart';

import '../../../profile/address/edit/edit_address_page.dart';

class ProfileEditPage extends StatelessWidget {
  const ProfileEditPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var t = Get.put(ProfileEditController());
    return KeyboardScaffold(
      title: 'Personal',
      body: Stack(
        children: [
          Scaffold(
            body: ListView(
              children: [
                /// 编辑头像
                Container(
                  height: 130.h,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Obx(() => ClipOval(
                            child: ImageUtil.networkImage(
                              url: UserController.find.userProfile.value.avatar,
                              width: 68,
                              height: 68,
                            ),
                          )),
                      12.verticalSpace,
                      Text(
                        "Edit your personal avatar",
                        style: TextStyle(fontSize: 14.sp, color: AppColor.colorB9C9),
                      )
                    ],
                  ),
                ),

                /// nickname，gender，country，language
                InputView(autoHeight: true,controller: t.nickController, label: "Nickname".tr, maxLength: 20, tips: "${UserController.find.userProfile.value.nickName}"),
                8.verticalSpace,
                InputView(autoHeight: true,controller: t.fistController, label: "Gender".tr, maxLength: 20, tips: "${UserController.find.userProfile.value.gender}"),
                8.verticalSpace,
                InputView(autoHeight: true,controller: t.lastController, label: "Country".tr, maxLength: 20, tips: "${UserController.find.userProfile.value.location.country}"),
                8.verticalSpace,
                InputView(autoHeight: true,controller: t.phoneController, label: "Language".tr, maxLength: 20, textInputType: TextInputType.phone, tips: "${UserController.find.userProfile.value.language}"),
                20.verticalSpace,
                AddressItem(
                  address: AddressModel(),
                  onEdit: () => t.jumpEditAddress(true),
                  onTap: () {},
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class AddressItem extends StatelessWidget {
  final AddressModel address;
  final Function? onTap;
  final Function onEdit;

  AddressItem({
    required this.address,
    required this.onEdit,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap?.call(),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(color: Color(0xFF28253D), borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      "${address.firstName} ${address.lastName}",
                      style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: "DIN"),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "${address.phone}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Offstage(
                    offstage: !address.useDefault,
                    child: Container(
                      height: 17,
                      decoration: BoxDecoration(color: AppColor.accent, borderRadius: BorderRadius.circular(4)),
                      padding: const EdgeInsets.only(left: 10, right: 10, top: 1),
                      child: Text(
                        "Default".tr,
                        style: TextStyle(color: Colors.white, fontSize: 11),
                      ),
                    ),
                  ),
                  Spacer(),
                  GestureDetector(
                      onTap: () => onEdit.call(),
                      child: CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.transparent,
                          child: Image.asset(
                            "assets/images/ic_edit.webp",
                            width: 14,
                          ))),
                ],
              ),
            ),
            Container(
                decoration: BoxDecoration(
                  color: Color(0x08ffffff),
                ),
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          address.email,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "${address.line1} ${address.line2} ${address.city} ${address.postCode}",
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 11,
                      ),
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }
}

class ProfileEditController extends GetxController {
  TextEditingController nickController = TextEditingController();
  TextEditingController fistController = TextEditingController();
  TextEditingController lastController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  void jumpEditAddress(bool edit, {AddressModel? address}) {
    Get.to(() => EditAddressPage(
          edit: edit,
          address: address,
        ))?.then((value) {
      if (value != null && value == true) {}
    });
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}
