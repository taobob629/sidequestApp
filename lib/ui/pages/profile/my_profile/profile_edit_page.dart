import 'dart:convert';
import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sq_hub_app/image_utils.dart';

import '../../../../../utils/toast_utils.dart';
import '../../../../api/common.dart';
import '../../../../api/profile_api.dart';
import '../../../../common/address_model.dart';
import '../../../../common/cs_drop_down.dart';
import '../../../../common/input_view.dart';
import '../../../../common/styles.dart';
import '../../../../config/app_color.dart';
import '../../../../config/icon_font.dart';
import '../../../../controller/user_controller.dart';
import '../../../../model/profile_detail.dart';
import '../../../../utils/permission_helper.dart';
import '../../../../widget/city_picker/model/select_status_model.dart';
import '../../../../widget/icon_text.dart';
import '../../../../widget/phone_input/src/utils/phone_number.dart';
import '../../../../widget/phone_input/src/utils/selector_config.dart';
import '../../../../widget/phone_input/src/widgets/input_widget.dart';
import '../../../../widget/views.dart';
import '../crop_page.dart';

class ProfileEditPage extends StatelessWidget {
  ProfileEditPage({Key? key}) : super(key: key);

  final t = Get.put(ProfileEditController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => t.profile == null
        ? buildLoad()
        : KeyboardVisibilityBuilder(
            builder: (context, bool isKeyboardVisible) {
              return KeyboardDismissOnTap(
                child: Scaffold(
                  appBar: AppBar(
                    title: Text('Personal'.tr),
                    centerTitle: true,
                    elevation: 0,
                    leading: GestureDetector(
                      onTap: () => Get.back(),
                      child: Icon(Icons.arrow_back_ios),
                    ),
                  ),
                  body: ListView(
                    children: [
                      /// 编辑头像
                      Container(
                        height: 130.h,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height:
                                  UserController.find.userProfile.vipLevel >= 5
                                      ? 86.w
                                      : 68.w,
                              child: Stack(
                                children: [
                                  Obx(() => GestureDetector(
                                        onTap: () {
                                          t.selectUpdateAvatar(context);
                                        },
                                        child: Container(
                                          clipBehavior: Clip.antiAlias,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(68.r),
                                              border: Border.all(
                                                  color: Colors.white)),
                                          child: ExtendedImage.network(
                                              UserController
                                                  .find.userProfile.avatar,
                                              width: 68.w,
                                              height: 68.w,
                                              fit: BoxFit.cover),
                                        ),
                                      )),
                                  Obx(() => Positioned(
                                      left: 0,
                                      right: 0,
                                      bottom: 0,
                                      child: Visibility(
                                        visible: UserController
                                                .find.userProfile.vipLevel >=
                                            5,
                                        child: Image.asset(
                                          "assets/images/huizhang_${UserController.find.userProfile.vipLevel == 0 ? 5 : UserController.find.userProfile.vipLevel}.webp",
                                          height: 28.w,
                                        ),
                                      ))),
                                ],
                              ),
                            ),
                            12.verticalSpace,
                            Text(
                              "Click to edit avatar".tr,
                              style: TextStyle(
                                  fontSize: 14.sp, color: AppColor.colorB9C9),
                            )
                          ],
                        ),
                      ),

                      /// nickname，gender，country，language
                      InputView(
                          autoHeight: true,
                          controller: t.nickController,
                          label: "NickName".tr,
                          maxLength: 20,
                          tips: "${UserController.find.userProfile.nickName}"),
                      Container(
                        height: 40.h,
                        padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                        child: Row(
                          children: [
                            Text(
                              "Gender".tr,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: FONT_MEDIUM),
                            ),
                            Spacer(),
                          ],
                        ),
                      ),
                      Container(
                        height: 50,
                        margin: EdgeInsets.symmetric(horizontal: 16.w),
                        decoration: BoxDecoration(
                            color: AppColor.itemBg2,
                            borderRadius: BorderRadius.circular(10).r),
                        child: Obx(() => Row(
                              children: [
                                Radio<int>(
                                    value: 0,
                                    groupValue: t.gender.value,
                                    onChanged: (value) =>
                                        t.gender.value = value!),
                                Text(
                                  "Male".tr,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14.sp),
                                ),
                                Radio<int>(
                                    value: 1,
                                    groupValue: t.gender.value,
                                    onChanged: (value) =>
                                        t.gender.value = value!),
                                Text(
                                  "Female".tr,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14.sp),
                                ),
                                Radio<int>(
                                    value: 2,
                                    groupValue: t.gender.value,
                                    onChanged: (value) =>
                                        t.gender.value = value!),
                                Text(
                                  "Non-binary".tr,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14.sp),
                                ),
                              ],
                            )),
                      ),
                      // InputView(autoHeight: true, controller: t.phoneController, label: "Gender".tr, maxLength: 20, tips: "${UserController.find.userProfile.gender}"),
                      Container(
                        height: 40.h,
                        padding:
                            EdgeInsets.only(top: 16.h, left: 16.w, right: 16.w),
                        child: Row(
                          children: [
                            Text(
                              "Phone".tr,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: FONT_MEDIUM),
                            ),
                            Spacer(),
                          ],
                        ),
                      ),
                      Container(
                        height: 50,
                        margin: EdgeInsets.symmetric(horizontal: 16.w),
                        decoration: BoxDecoration(
                            color: AppColor.itemBg2,
                            borderRadius: BorderRadius.circular(10).r),
                        child: Obx(() => InternationalPhoneNumberInput(
                              onInputChanged: (PhoneNumber number) {
                                var phoneParts =
                                    number.phoneNumber!.split(number.dialCode!);
                                t.phone.value =
                                    "${number.dialCode!} ${phoneParts.last}";
                                print(t.phone.value);
                              },
                              onInputValidated: (bool value) {
                                // print(value);
                              },
                              selectorConfig: SelectorConfig(
                                selectorType: PhoneInputSelectorType.DROPDOWN,
                              ),
                              ignoreBlank: false,
                              autoValidateMode: AutovalidateMode.disabled,
                              selectorTextStyle: TextStyle(
                                color: AppColor.colorB9C9,
                              ),
                              textStyle: TextStyle(
                                color: AppColor.colorB9C9,
                              ),
                              inputDecoration: InputDecoration(
                                hintText: "Phone number".tr,
                                hintStyle: TextStyle(color: AppColor.colorB9C9),
                                labelStyle:
                                    TextStyle(color: AppColor.colorB9C9),
                                helperStyle:
                                    TextStyle(color: AppColor.colorB9C9),
                              ),
                              initialValue: PhoneNumber(
                                  isoCode: PhoneNumber.getISO2CodeByPrefix(
                                          t.digalCode.value) ??
                                      ""),
                              textFieldController: t.phoneController,
                              formatInput: true,
                              cursorColor: Colors.white,
                              hintText: "Phone number".tr,
                              keyboardType: TextInputType.numberWithOptions(
                                  signed: true, decimal: true),
                              inputBorder: OutlineInputBorder(),
                              onSaved: (PhoneNumber number) {
                                print('On Saved: $number');
                                // t.phone.value = number.toString();
                                // print(t.phone.value);
                              },
                            )),
                      ),
                      Container(
                        height: 40.h,
                        padding:
                            EdgeInsets.only(top: 16.h, left: 16.w, right: 16.w),
                        child: Row(
                          children: [
                            Text(
                              "Country".tr,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: FONT_MEDIUM),
                            ),
                            Spacer(),
                          ],
                        ),
                      ),
                      Builder(builder: (optionContext) {
                        return GestureDetector(
                          child: Obx(() => Container(
                              height: 50,
                              padding: EdgeInsets.only(left: 15, right: 10),
                              decoration: BoxDecoration(
                                color: AppColor.itemBg2,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    t.curCountry.value,
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        color: AppColor.colorB9C9),
                                  ),
                                  Spacer(),
                                  Icon(
                                    Icons.keyboard_arrow_down,
                                    color: AppColor.colorB9C9,
                                  ),
                                ],
                              ))),
                          onTap: () {
                            Get.dialog(
                                CsDropDownDialog(
                                    optionContext: optionContext,
                                    itemList: t.countries
                                        .map<DropDownModel>((country) =>
                                            DropDownModel()
                                              ..title = ((country.emoji ?? "") +
                                                  country.name))
                                        .toList(),
                                    onTap: (index, value) {
                                      t.curCountry.value = value;
                                    }),
                                barrierColor: Colors.transparent,
                                useSafeArea: false);
                          },
                        );
                      }).marginSymmetric(horizontal: 15),
                      // Obx(() => AddressItemView(
                      //       address: t.addressModel.value,
                      //       onEdit: () => t.jumpEditAddress(true, address: t.addressModel.value),
                      //       onTap: () {},
                      //     )),
                      33.verticalSpace,
                      GestureDetector(
                        onTap: () {
                          t.updateProfile();
                        },
                        child: Container(
                          width: 240,
                          height: 40.h,
                          margin: EdgeInsets.symmetric(horizontal: 21),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            gradient:
                                LinearGradient(colors: AppColor.yellowGradient),
                            borderRadius: BorderRadius.circular(20.h),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Save".tr,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                      100.verticalSpace
                    ],
                  ),
                ),
              );
            },
          ));
  }
}

class AddressItemView extends StatelessWidget {
  final AddressModel address;
  final Function? onTap;
  final Function onEdit;

  AddressItemView({
    required this.address,
    required this.onEdit,
    this.onTap,
  });

  var divider = 8.verticalSpace;
  var textColor = Color(0xffB2B9C9);
  var iconColor = Color(0xffB2B9C9);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => onTap?.call(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 40.h,
              padding: EdgeInsets.only(top: 16, left: 16, right: 16),
              child: Row(
                children: [
                  Text(
                    "Address",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: FONT_MEDIUM),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () => onEdit.call(),
                    child: Row(
                      children: [
                        Image.asset(ImageUtils.ic_edit2,
                            width: 15.w, height: 15.h, color: Colors.white),
                        5.horizontalSpace,
                        Text(
                          "Edit",
                          style: TextStyle(
                              color: AppColor.yellow,
                              fontSize: 16,
                              fontFamily: FONT_MEDIUM),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              padding: itemPaddingNormal,
              clipBehavior: Clip.antiAlias,
              decoration: itemDecoration(),
              child: list_item(false),
            ),
          ],
        ));
  }

  Widget list_item(var isDefault) {
    if (isDefault) {
      textColor = Colors.white;
      iconColor = AppColor.yellow;
    }
    return Column(
      children: [
        Container(
          child: Row(
            children: [
              Text(
                "${address.firstName} ${address.lastName}",
                style: TextStyle(
                    color: isDefault ? AppColor.textYellow : Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                    fontFamily: FONT_MEDIUM),
              ),
              Spacer(),
              Text(
                "${address.phone}",
                style: TextStyle(
                  color: isDefault ? AppColor.textYellow : Colors.white,
                  fontFamily: FONT_LIGHT,
                  fontSize: 16.sp,
                ),
              ),
            ],
          ),
        ),
        listDivider,
        10.verticalSpace,
        Container(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconTextWidget(
              textColor: textColor,
              iconColor: iconColor,
              icon: ImageUtils.ic_email,
              text: address.email,
              size: 13.w,
            ),
            divider,
            IconTextWidget(
              textColor: textColor,
              iconColor: iconColor,
              icon: ImageUtils.ic_location,
              text: "${address.city} | ${address.line1}",
              size: 13.w,
            ),
            divider,
            IconTextWidget(
              icon: 'ic_nav',
              iconColor: iconColor,
              textColor: textColor,
              text: address.postCode,
              size: 13.w,
            ),
          ],
        ))
      ],
    );
  }
}

class ProfileEditController extends GetxController {
  BuildContext? myContext;

  TextEditingController nickController = TextEditingController();

  TextEditingController phoneController = TextEditingController();

  final gender = 2.obs;

  RxBool _hasInited = false.obs;

  bool get hasInited => _hasInited.value;

  set hasInited(bool value) {
    _hasInited.value = value;
  }

  final curCountry = "".obs;
  final addressModel = AddressModel().obs;
  final phone = "".obs;
  final digalCode = "+44".obs;

  ///是否正在上传文件
  bool isUploadFile = false;

  @override
  void onInit() {
    initLocation();
    hasInited = true;
    profileInit();
    super.onInit();
  }

  Rxn<ProfileDetailBean> _profile = Rxn<ProfileDetailBean>();

  ProfileDetailBean? get profile => _profile.value;

  set profile(ProfileDetailBean? value) {
    _profile.value = value;
  }

  profileInit() {
    ProfileApi.profileInit().then((res) {
      profile = res;
      nickController.text = res.nick;
      gender.value = int.parse(res.gender);

      phone.value = res.phone;
      if (phone.value.isNotEmpty && phone.contains(" ")) {
        digalCode.value = phone.value.split(" ").first;
        phoneController.text = phone.value.split(" ").last;
      } else
        phoneController.text = phone.value;

      var loc = res.country;
      if (loc.isNotEmpty && loc != "null") {
        String country =
            jsonDecode(loc.replaceAll("""\\""", """\\\\"""))["country"];
        var tempCountry = countries.firstWhereOrNull(
            (element) => country.contains('${element.name}'))!;
        print(tempCountry);
        curCountry.value = ((tempCountry.emoji ?? "") + tempCountry.name);
      }
    });
  }

  updateProfile() {
    if (curCountry.value.isEmpty) {
      showInfo(
        "Please choose a Country".tr,
      );
      return;
    }
    ProfileApi.updateProfile(nickController.text, phone.value,
            jsonEncode({"country": curCountry.value}), gender.value.toString())
        .then((value) {
      Get.back();
      UserController.find.updateInfo();
    });
  }

  RxList<Country> countries = RxList();

  initLocation() async {
    if (countries.isNotEmpty) return countries;
    countries.clear();
    var res = await rootBundle.loadString('assets/data/country.json');
    countries.value = (jsonDecode(res) as List)
        .map((json) => Country.fromJson(json))
        .toList();
  }

  void selectUpdateAvatar(BuildContext context) async {
    var status = await PermissionHelper.requestPhotosPermission(context);
    if (status == false) {
      return;
    }
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      var _image = File(pickedFile.path);
      Get.to<File?>(() => CropPage(image: _image))!.then((value) async {
        // flog(value!.path, 'selectAvatar');
        if (value != null) {
          isUploadFile = true;
          showLoading();
          await Common.uploadAvatar(value, (p0, p1) => {});
          dismissLoading();
          isUploadFile = false;
          UserController.find.updateInfo();
        }
      });
    } else {
      print('No image selected.');
    }
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}
