import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/config/icon_font.dart';
import 'package:wy/model/address_model.dart';
import 'package:wy/res/index.dart';
import 'package:wy/ui/common/action_button.dart';
import 'package:wy/ui/common/floating_button.dart';
import 'package:wy/ui/common/input_view.dart';
import 'package:wy/ui/common/keyboard_scaffold.dart';

import 'controller.dart';

class EditAddressPage extends StatelessWidget {
  final bool edit;
  late final AddressModel? address;
  late final EditAddressPageController controller;

  EditAddressPage({required this.edit, this.address}) {
    controller = Get.put(EditAddressPageController(address: address));
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardScaffold(
      title: "${edit ? "Edit".tr : "New".tr} ${'Address'.tr}",
      actions: [
        Offstage(
            offstage: !edit,
            child: ActionButton(
              icon: Icon(
                Icons.delete,
                color: Colors.white,
              ),
              onTap: () => controller.delete(),
            ))
      ],
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildContactView(),
            _buildAddressView(context),
            _buildDefaultView(),
            SizedBox(
              height: 100,
            )
          ],
        ),
      ),
      floatingActionButton: FloatingButton(
        label: "CONFIRM".tr,
        onTap: () => controller.save(),
      ),
    );
  }

  var intputDecoration = BoxDecoration(
      color: Color(0xff2D2E3C), borderRadius: BorderRadius.all(Radius.circular(10.r)));

  Widget _buildContactView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        lable_text("Contact Info".tr),
        Container(
          padding: EdgeInsets.only(top: 20.h, bottom: 20.h),
          decoration: itemDecoration(),
          margin: EdgeInsets
              .all(15)
              .r,
          child: Column(
            children: [
              InputView(
                  decoration: intputDecoration,
                  label: "First Name".tr,
                  autoHeight: true,
                  tips: "Input your first name".tr,
                  textInputType: TextInputType.name,
                  controller: controller.firstNameController),
              divider,
              InputView(
                  decoration: intputDecoration,
                  autoHeight: true,
                  label: "Last Name".tr,
                  tips: "Input your last name".tr,
                  textInputType: TextInputType.name,
                  controller: controller.lastNameController),
              divider,
              InputView(
                  decoration: intputDecoration,
                  autoHeight: true,
                  label: "Email".tr,
                  tips: "Input your email address".tr,
                  textInputType: TextInputType.emailAddress,
                  controller: controller.emailController),
              divider,
              InputView(
                  decoration: intputDecoration,
                  autoHeight: true,
                  label: "Phone".tr,
                  tips: "Input your mobile phone number".tr,
                  textInputType: TextInputType.phone,
                  controller: controller.phoneController),
            ],
          ),
        )
      ],
    );
  }

  var divider = 15.verticalSpace;

  Widget _buildAddressView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        lable_text("Shipping Address".tr),
        Container(
          padding: EdgeInsets.only(top: 20.h, bottom: 20.h),
          decoration: itemDecoration(),
          margin: EdgeInsets
              .all(15)
              .r,
          child: Column(
            children: [
              InputView(
                  decoration: intputDecoration,
                  autoHeight: true,
                  label: "Address Line 1".tr,
                  tips: "Input your detailed address".tr,
                  textInputType: TextInputType.streetAddress,
                  controller: controller.line1Controller),
              divider,
              InputView(
                  decoration: intputDecoration,
                  autoHeight: true,
                  label: "Address Line 2 (Optional)".tr,
                  tips: "Input your detailed address".tr,
                  textInputType: TextInputType.streetAddress,
                  controller: controller.line2Controller),
              divider,
              InputView(
                  decoration: intputDecoration,
                  autoHeight: true,
                  label: "Post Code".tr,
                  tips: "Input your post code".tr,
                  textInputType: TextInputType.text,
                  controller: controller.codeController),
              divider,
              InputView(
                  decoration: intputDecoration,
                  autoHeight: true,
                  label: "City".tr,
                  tips: "Input your city".tr,
                  textInputType: TextInputType.text,
                  controller: controller.cityController),
            ],
          ),
        )
      ],
    );
  }

  Widget lable_text(var text) {
    return Padding(
      padding: EdgeInsets.only(top: 20.h, bottom: 10.h, left: 15.w, right: 15.w),
      child: Text(
        '$text',
        style: TextStyle(color: Colors.white, fontSize: 18.sp, fontFamily: FONT_LIGHT),
      ),
    );
  }

  Widget _buildDefaultView() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Use this as default".tr,
            style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: FONT_LIGHT),
          ),
          Obx(() =>
              CupertinoSwitch(
               //   activeColor: AppColor.accent,
                  value: controller.useAsDefault.value,
                  onChanged: (value) => controller.useAsDefault.value = value))
        ],
      ),
    );
  }
}
