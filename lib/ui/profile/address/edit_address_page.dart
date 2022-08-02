import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:wy/api/address_api.dart';
import 'package:wy/common/getx_list_controller.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/config/app_config.dart';
import 'package:wy/model/address_model.dart';
import 'package:wy/model/shire.dart';
import 'package:wy/ui/common/action_button.dart';
import 'package:wy/ui/common/floating_button.dart';
import 'package:wy/ui/common/input_view.dart';
import 'package:wy/ui/common/keyboard_scaffold.dart';

class EditAddressPage extends StatelessWidget {

  final bool edit;
  late final AddressModel? address;
  late final EditAddressPageController controller;

  EditAddressPage({required this.edit, this.address}){
    controller = Get.put(EditAddressPageController(address: address));
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardScaffold(
      title: "${edit ? "Edit" : "New"} Address",
      actions: [
        Offstage(
          offstage: !edit,
          child: ActionButton(
            icon: Icon(Icons.delete,color: Colors.white,),
            onTap: ()=>controller.delete(),
          )
        )
      ],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Obx(() {
            return Column(
              children: [
                _buildContactView(),
                _buildAddressView(context),
                _buildDefaultView(),
                SizedBox(height: 100,)
              ],
            );
          }),
        ),
      ),
      floatingActionButton: FloatingButton(
        label: "CONFIRM",
        onTap: ()=> controller.save(),
      ),
    );
  }

  Widget _buildContactView() {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Color(0xFF28253D),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: Text("Contact Info", style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: "DIN"),),
          ),
          Container(
            color: Color(0x08ffffff),
            padding: const EdgeInsets.only(bottom: 15),
            child: Column(
              children: [
                InputView(
                  label: "First Name",
                  tips: "Input your first name",
                  textInputType: TextInputType.name,
                  controller: controller.firstNameController
                ),
                InputView(
                  label: "Last Name",
                  tips: "Input your last name",
                  textInputType: TextInputType.name,
                  controller: controller.lastNameController
                ),
                InputView(
                  label: "Email",
                  tips: "Input your email address",
                  textInputType: TextInputType.emailAddress,
                  controller: controller.emailController
                ),
                InputView(
                  label: "Phone",
                  tips: "Input your mobile phone number",
                  textInputType: TextInputType.phone,
                  controller: controller.phoneController
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAddressView(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Color(0xFF28253D),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: Text("Shipping Address", style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: "DIN"),),
          ),
          Container(
            color: Color(0x08ffffff),
            padding: const EdgeInsets.only(bottom: 15),
            child: Column(
              children: [
                InputView(
                  label: "Address Line 1",
                  tips: "Input your detailed address",
                  textInputType: TextInputType.streetAddress,
                  controller: controller.line1Controller
                ),
                InputView(
                  label: "Address Line 2 (Optional)",
                  tips: "Input your detailed address",
                  textInputType: TextInputType.streetAddress,
                  controller: controller.line2Controller
                ),
                InputView(
                  label: "Post Code",
                  tips: "Input your post code",
                  textInputType: TextInputType.text,
                  controller: controller.codeController
                ),
                InputView(
                  label: "City",
                  tips: "Input your city",
                  textInputType: TextInputType.text,
                  controller: controller.cityController
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDefaultView() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Use this as default", style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: "DIN"),),
          Switch(
            activeColor: AppColor.accent,
            value: controller.useAsDefault.value,
            onChanged: (value) => controller.useAsDefault.value = value
          )
        ],
      ),
    );
  }
}

class EditAddressPageController extends GetxListController<Shire> {
  var useAsDefault = true.obs;

  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var line1Controller = TextEditingController();
  var line2Controller = TextEditingController();
  var codeController = TextEditingController();
  var cityController = TextEditingController();

  var id = 0;

  EditAddressPageController({required AddressModel? address}){
    if(address != null) {
      firstNameController.text = address.firstName;
      lastNameController.text = address.lastName;
      emailController.text = address.email;
      phoneController.text = address.phone;
      line1Controller.text = address.line1;
      line2Controller.text = address.line2;
      codeController.text = address.postCode;
      cityController.text = address.city;
      useAsDefault.value = address.useDefault;
      id = address.id;
    }
  }

  @override
  void onClose(){
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    line1Controller.dispose();
    line2Controller.dispose();
    codeController.dispose();
    cityController.dispose();
    super.onClose();
  }

  Future<List<Shire>> loadData() async {
    List<Shire> shireList = [];

    List<dynamic> stateList = jsonDecode(AppConfig.cityJson);
    shireList = stateList
      .map((e) => Shire.fromJson(e))
      .where((element) => element.countryCode == "GB").toList();
    jsonEncode(shireList);
    return shireList;
  }

  void delete() async {
    EasyLoading.show();
    await AddressApi.delete(id);
    EasyLoading.dismiss();
    Get.back(result: true);
  }

  void save() async{
    String firstName = firstNameController.text;
    if(firstName.isEmpty){
      EasyLoading.showToast("Please input a first name");
      return;
    }
    String lastName = lastNameController.text;
    if(lastName.isEmpty){
      EasyLoading.showToast("Please input a last name");
      return;
    }
    String email = emailController.text;
    if(email.isEmpty){
      EasyLoading.showToast("Please input a email");
      return;
    }
    String phone = phoneController.text;
    if(phone.isEmpty){
      EasyLoading.showToast("Please input a phone number");
      return;
    }
    String line1 = line1Controller.text;
    if(line1.isEmpty){
      EasyLoading.showToast("Please input a detail address");
      return;
    }
    String line2 = line2Controller.text;

    String code = codeController.text;
    if(code.isEmpty){
      EasyLoading.showToast("Please input a post code");
      return;
    }

    String city = cityController.text;
    if(city.isEmpty){
      EasyLoading.showToast("Please input your city");
      return;
    }
    print("useAsDefault.value=${useAsDefault.value}");
    AddressModel model = AddressModel();
    model.id = id;
    model.firstName = firstName;
    model.lastName = lastName;
    model.email = email;
    model.phone = phone;
    model.line1 = line1;
    model.line2 = line2;
    model.postCode = code;
    model.city = city;
    model.useDefault = useAsDefault.value;
    EasyLoading.show();
    await AddressApi.save(model);
    EasyLoading.dismiss();
    Get.back(result: true);
  }
}