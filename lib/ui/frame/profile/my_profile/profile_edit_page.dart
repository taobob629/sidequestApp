import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:wy/api/common.dart';
import 'package:wy/api_service/profile_api.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/config/icon_font.dart';
import 'package:wy/model/address_model.dart';
import 'package:wy/model/profile_detail.dart';
import 'package:wy/res/index.dart';
import 'package:wy/ui/common/cs_drop_down.dart';
import 'package:wy/ui/common/input_view.dart';
import 'package:wy/ui/controller/user_controller.dart';
import 'package:wy/ui/profile/edit/crop_page.dart';
import 'package:wy/utils/index.dart';
import 'package:wy/widget/city_picker/model/select_status_model.dart';
import 'package:wy/widget/icon_text.dart';
import 'package:wy/widget/phone_input/intl_phone_number_input.dart';
import 'package:wy/widget/views.dart';

import '../../../../utils/global_key_constants.dart';
import '../../../../utils/toast_utils.dart';

class ProfileEditPage extends StatelessWidget {
  ProfileEditPage({Key? key}) : super(key: key);

  final t = Get.put(ProfileEditController());

  @override
  Widget build(BuildContext context) {
    bool? profileEditInfoBackKey =
        StorageManager.getBoolByKey('profileEditInfoBackKey');
    // if (profileEditInfoBackKey == null || profileEditInfoBackKey == false) {
    //   ambiguate(WidgetsBinding.instance)?.addPostFrameCallback(
    //         (_) =>
    //         ShowCaseWidget.of(t.myContext!).startShowCase([
    //           GlobalKeyConstants.profileEditInfoBackKey,
    //         ]),
    //   );
    // }

    return Obx(() => t.profile == null
        ? buildLoad()
        : ShowCaseWidget(
            autoPlay: true,
            autoPlayDelay: Duration(seconds: 5),
            onFinish: () =>
                StorageManager.setBoolValue('profileEditInfoBackKey', true),
            builder: Builder(builder: (builder) {
              t.myContext = builder;
              return KeyboardVisibilityBuilder(
                builder: (context, bool isKeyboardVisible) {
                  return KeyboardDismissOnTap(
                    child: Scaffold(
                      appBar: AppBar(
                        title: Text('Personal'.tr),
                        centerTitle: true,
                        elevation: 0,
                        leading: Showcase(
                          key: GlobalKeyConstants.profileEditInfoBackKey,
                          description:
                              'Please complete your personal information and click the back button.'
                                  .tr,
                          child: GestureDetector(
                            onTap: () => Get.back(),
                            child: Icon(Icons.arrow_back_ios),
                          ),
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
                                Stack(
                                  children: [
                                    Obx(() => GestureDetector(
                                          onTap: () {
                                            t.selectUpdateAvatar(context);
                                          },
                                          child: Container(
                                            clipBehavior: Clip.antiAlias,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(34),
                                                border: Border.all(
                                                    color: Colors.white)),
                                            child: ImageUtil.networkImage(
                                                url: UserController
                                                    .find.userProfile.avatar,
                                                width: 68,
                                                height: 68,
                                                fit: BoxFit.cover),
                                          ),
                                        )),
                                    Obx(() => Visibility(
                                          visible: UserController
                                                  .find.userProfile.vipLevel >=
                                              5,
                                          child: Positioned(
                                              left: 0,
                                              right: 0,
                                              bottom: 0,
                                              child: Image.asset(
                                                "assets/images/profile/icon_level_${UserController.find.userProfile.vipLevel == 0 ? 5 : UserController.find.userProfile.vipLevel}.webp",
                                                height: 28,
                                              )),
                                        )),
                                  ],
                                ),
                                12.verticalSpace,
                                Text(
                                  "Click to edit avatar".tr,
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      color: AppColor.colorB9C9),
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
                              tips:
                                  "${UserController.find.userProfile.nickName}"),
                          _eplayerIntroWidget(),
                          Container(
                            height: 40.h,
                            padding:
                                EdgeInsets.only(top: 16, left: 16, right: 16),
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
                            padding: EdgeInsets.only(
                                top: 16.h, left: 16.w, right: 16.w),
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
                                    var phoneParts = number.phoneNumber!
                                        .split(number.dialCode!);
                                    t.phone.value =
                                        "${number.dialCode!} ${phoneParts.last}";
                                    print(t.phone.value);
                                  },
                                  onInputValidated: (bool value) {
                                    // print(value);
                                  },
                                  selectorConfig: SelectorConfig(
                                    selectorType:
                                        PhoneInputSelectorType.DROPDOWN,
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
                                    hintStyle:
                                        TextStyle(color: AppColor.colorB9C9),
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
                            padding: EdgeInsets.only(
                                top: 16.h, left: 16.w, right: 16.w),
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
                                                  ..title =
                                                      ((country.emoji ?? "") +
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
                          Container(
                            height: 40.h,
                            padding:
                                EdgeInsets.only(top: 16, left: 16, right: 16),
                            child: Row(
                              children: [
                                Text(
                                  "Language".tr,
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
                                        t.languageList.join("/"),
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
                                    CsDropDownMulitSelectDialog(
                                      optionContext: optionContext,
                                      itemList: [
                                        DropDownModel()..title = "English",
                                        DropDownModel()..title = "Chinese"
                                      ],
                                      initSelectList: t.languageList,
                                      onSelect: (value) {
                                        t.languageList.clear();
                                        t.languageList.addAll(value);
                                        // t.languageList.refresh();
                                      },
                                    ),
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
                                gradient: LinearGradient(
                                    colors: AppColor.yellowGradient),
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
              );
            }),
          ));
  }

  Widget _eplayerIntroWidget() => Container(
        margin: const EdgeInsets.only(left: 15, right: 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            10.verticalSpace,
            Text(
              'SideKicker Introduction'.tr,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontFamily: FONT_MEDIUM,
              ),
            ),
            6.verticalSpace,
            Container(
              margin: EdgeInsets.only(top: 6.h, bottom: 6.h),
              padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: Color(0xff313033),
                borderRadius: BorderRadius.all(Radius.circular(8)).w,
              ),
              child: TextField(
                controller: t.signatureController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '${UserController.find.userProfile.signature}',
                  hintStyle:
                      TextStyle(color: Color(0xffb2b9c9), fontSize: 14.sp),
                  helperStyle: TextStyle(color: Colors.white, fontSize: 14.sp),
                  labelStyle: TextStyle(color: Colors.white, fontSize: 14.sp),
                ),
                style: TextStyle(color: Colors.white, fontSize: 14.sp),
                maxLength: 255,
                maxLines: 4,
                minLines: 4,
              ),
            )
          ],
        ),
      );
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
                        ImageUtil.assetImage('ic_edit2',
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
              icon: 'ic_email',
              text: address.email,
              size: 13.w,
            ),
            divider,
            IconTextWidget(
              textColor: textColor,
              iconColor: iconColor,
              icon: 'ic_location',
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
  TextEditingController signatureController = TextEditingController();

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

  final languageList = <String>[].obs;

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
      signatureController.text = res.signature;
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
      languageList.addIf(res.language.contains("English"), "English");
      languageList.addIf(res.language.contains("Chinese"), "Chinese");
    });
  }

  updateProfile() {
    if (curCountry.value.isEmpty) {
      showInfo(
        "Please choose a Country".tr,
      );
      return;
    }
    if (languageList.isEmpty) {
      showInfo(
        "Please set language first".tr,
      );
      return;
    }
    ProfileApi.updateProfile(
            nickController.text,
            signatureController.text,
            phone.value,
            languageList.join("/"),
            jsonEncode({"country": curCountry.value}),
            gender.value.toString())
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
        isUploadFile = true;
        showLoading();
        await Common.uploadAvatar(value!, (p0, p1) => flog("$p0,$p1"));
        dismissLoading();
        isUploadFile = false;
        UserController.find.updateInfo();
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
