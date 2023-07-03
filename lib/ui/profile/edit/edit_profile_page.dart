import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:wy/api/user_api.dart';
import 'package:wy/ui/common/floating_button.dart';
import 'package:wy/ui/common/input_view.dart';
import 'package:wy/ui/common/keyboard_scaffold.dart';
import 'package:wy/ui/controller/user_controller.dart';
import 'package:wy/ui/profile/edit/crop_page.dart';
import 'package:wy/ui/profile/edit/info_item.dart';
import 'package:wy/utils/permission_helper.dart';

import '../../../api/auth_api.dart';
import '../../../config/app_config.dart';
import '../../../utils/toast_utils.dart';
import '../../common/action_button.dart';
import '../../common/dialog_confirm.dart';


class EditProfilePage extends StatelessWidget {

  final controller = Get.put(EditProfilePageController());

  final userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return KeyboardScaffold(
      title: "Profile".tr,
      actions: [
        ActionButton(
          icon: Icon(
            Icons.delete,
            color: Colors.white,
          ),
          onTap: () => controller.deleteAccount(),
        )
      ],
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildAvatarEdit(context),
            SizedBox(height: 10,),
            InputView(
                controller: controller.nickController, label: "Nickname".tr, maxLength: 20, tips: "${userController.userProfile.nickName}"),
            InputView(
                controller: controller.fistController, label: "First Name".tr, maxLength: 20, tips: "${userController.user.value.firstName}"),
            InputView(
                controller: controller.lastController, label: "Last Name".tr, maxLength: 20, tips: "${userController.user.value.lastName}"),
            InputView(
                controller: controller.phoneController, label: "Phone".tr, maxLength: 20, textInputType: TextInputType.phone, tips: "${userController.user.value.phone}"),
            /*
            Obx(()=>BirthdayEditor(
              label: "Birthday",
              value: controller.birthday.value,
              onTap: ()=>Get.dialog<DateTime?>(
                DateTimePickerDialog(
                  maxDateTime: DateTime.now(),
                  initDateTime: controller.birthday.value,
                ),barrierColor: Colors.black26
              ).then((value) {
                controller.setBirthday(value);
              }),
            )),*/
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              height: 10,
              color: Color(0xFF0F0D1A),
            ),
            InfoItem(title: "Birthday".tr, detail: "${userController.user.value.birth}"),
            InfoItem(title: "Account Email".tr, detail: "${userController.user.value.email}"),
            InfoItem(title: "Registered Date".tr, detail: "${userController.user.value.createTime}"),
            SizedBox(
              height: 50,
            )
          ],
        ),
      ),
      floatingActionButton: FloatingButton(
        label: "CONFIRM".tr,
        onTap: () => controller.updateInfo(),
      ),
    );
  }

  Widget _buildAvatarEdit(BuildContext context){
    return GestureDetector(
      onTap: ()=>selectAvatar(context),
      child: Container(
        width: 80,
        height: 80,
        child: Stack(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 40,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: ClipOval(
                  child: Obx((){
                    if(controller.avatar.value.path == "") {
                      if(userController.userProfile.avatar.isEmpty){
                        return Icon(Icons.person,size: 70, color: Colors.black38,);
                      }else {
                        return CachedNetworkImage(
                          imageUrl: userController.userProfile.avatar,
                          fit: BoxFit.cover,
                        );
                      }
                    }else{
                      return Image.file(controller.avatar.value,fit: BoxFit.cover,);
                    }
                  })
                ),
              )
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: CircleAvatar(
                radius: 10,
                backgroundColor:Colors.grey,
                child: Icon(Icons.camera_alt_rounded,color: Colors.white,size: 12,),
              )
            )
          ],
        ),
      ),
    );
  }

  void selectAvatar(BuildContext context) async{
    var status = await PermissionHelper.requestPhotosPermission(context);
    if(status == false) {
      return;
    }
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      var _image = File(pickedFile.path);
      Get.to<File?>(()=>CropPage(image: _image))!
        .then((value) {
          controller.setAvatar(value);
        });
    } else {
    }
  }
}

class EditProfilePageController extends GetxController {

  late Rx<DateTime> birthday = DateTime.now().obs;

  var avatar = Rx<File>(File(""));

  late TextEditingController nickController;
  late TextEditingController fistController;
  late TextEditingController lastController;
  late TextEditingController phoneController;

  final userController = Get.find<UserController>();

  EditProfilePageController(){
    birthday.value = DateFormat('dd/MM/y', 'en_GB').parse(userController.user.value.birth);
  }

  @override
  void onInit() {
    super.onInit();
    nickController = TextEditingController();
    fistController = TextEditingController();
    lastController = TextEditingController();
    phoneController = TextEditingController();
  }

  @override
  onClose(){
    nickController.dispose();
    fistController.dispose();
    lastController.dispose();
    phoneController.dispose();
    super.onClose();
  }

  Future<void> initData() async{

  }

  void setAvatar(File? data){
    avatar.value = data == null ? File("") : data;
  }

  void setBirthday(DateTime? birthday){
    if(birthday != null) {
      this.birthday.value = birthday;
    }
  }

  void updateInfo() async {
    showLoading();
    String avatarUrl = userController.userProfile.avatar;
    if(avatar.value.path != "") {
      avatarUrl = await UserApi.uploadAvatar(avatar.value, (p0, p1) => print("$p0,$p1"));
    }

    String nick = nickController.text.isEmpty ? userController.userProfile.nickName : nickController.text;

    String birth = userController.user.value.birth;
    // if(DatetimeUtils.getAge(this.birthday.value) >= 16) {
    //   birth = formatDate(this.birthday.value, [dd, '/', mm, '/', yyyy]);
    // }else{
    //   SmartDialog.showError("Your age can not less than 16!");
    //   return;
    // }

    String firstName = fistController.text.isEmpty ? userController.user.value.firstName : fistController.text;
    String lastName = lastController.text.isEmpty ? userController.user.value.lastName : lastController.text;
    String phone = phoneController.text.isEmpty ? userController.user.value.phone : phoneController.text;

    await UserApi.updateProfile(nick, birth, firstName, lastName, phone);
    showSuccess("Success".tr);
    Get.back(result: true);
  }

  void deleteAccount() async {
    var info = "Deleting your account will remove your profile and all of your content from SideQuest. Delete account means you won't be able to get any of your data back. All your SideQuest account data will be deleted. If you experienced an issue with your account and need help, please contact us so we can assist you.This action cannot be UNDONE. Are you sure you need to DELETE ACCOUNT?".tr;
    Get.dialog(
        ConfirmDialog(
          title: "Delete Account".tr,
          info: info,
          confirmBtn: "CONFIRM".tr,
          onConfirm: () async {
            Get.back();
            showLoading();
            await UserApi.deleteAccount();
            await AuthApi.signOut();
            await AppConfig.flutterLocalNotificationsPlugin.cancelAll();
            dismissLoading();
            UserController userController = Get.find<UserController>();
            userController.logout(done: () => Get.back());
          },
        ),barrierColor: Colors.black26);
  }
}