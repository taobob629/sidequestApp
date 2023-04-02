import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wy/api/common.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/config/icon_font.dart';
import 'package:wy/model/address_model.dart';
import 'package:wy/ui/common/input_view.dart';
import 'package:wy/ui/common/keyboard_scaffold.dart';
import 'package:wy/ui/controller/user_controller.dart';
import 'package:wy/ui/order/detail/widgets/acticon_widget.dart';
import 'package:wy/ui/profile/edit/crop_page.dart';
import 'package:wy/utils/index.dart';
import 'package:get/get.dart';
import 'package:wy/res/index.dart';
import 'package:wy/widget/city_picker/csc_picker.dart';
import 'package:wy/widget/city_picker/model/select_status_model.dart';
import 'package:wy/widget/icon_text.dart';
import 'package:wy/widget/phone_input/intl_phone_number_input.dart';

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
                      Obx(() => GestureDetector(
                            onTap: () {
                              t.selectUpdateAvatar(context);
                            },
                            child: Container(
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(34), border: Border.all(color: Colors.white)),
                              child: ImageUtil.networkImage(url: UserController.find.userProfile.value.avatar, width: 68, height: 68, fit: BoxFit.cover),
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
                InputView(autoHeight: true, controller: t.nickController, label: "Nickname".tr, maxLength: 20, tips: "${UserController.find.userProfile.value.nickName}"),
                Container(
                  height: 40.h,
                  padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                  child: Row(
                    children: [
                      Text(
                        "Gender",
                        style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: FONT_MEDIUM),
                      ),
                      Spacer(),
                    ],
                  ),
                ),
                Container(
                  height: 50,
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(color: AppColor.itemBg2, borderRadius: BorderRadius.circular(10).r),
                  child: Obx(() => Row(
                        children: [
                          Radio<int>(value: 0, groupValue: t.sex.value, onChanged: (value) => t.sex.value = value!),
                          Text(
                            "Male".tr,
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          Radio<int>(value: 1, groupValue: t.sex.value, onChanged: (value) => t.sex.value = value!),
                          Text(
                            "Female".tr,
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          Radio<int>(value: 2, groupValue: t.sex.value, onChanged: (value) => t.sex.value = value!),
                          Text(
                            "Non-binary".tr,
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ],
                      )),
                ),
                // InputView(autoHeight: true, controller: t.phoneController, label: "Gender".tr, maxLength: 20, tips: "${UserController.find.userProfile.value.gender}"),
                Container(
                  height: 40.h,
                  padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                  child: Row(
                    children: [
                      Text(
                        "Phone",
                        style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: FONT_MEDIUM),
                      ),
                      Spacer(),
                    ],
                  ),
                ),
                Container(
                  height: 50,
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(color: AppColor.itemBg2, borderRadius: BorderRadius.circular(10).r),
                  // color: Colors.yellow,
                  child: InternationalPhoneNumberInput(
                    onInputChanged: (PhoneNumber number) {
                      print(number.phoneNumber);
                    },
                    onInputValidated: (bool value) {
                      print(value);
                    },
                    selectorConfig: SelectorConfig(
                      selectorType: PhoneInputSelectorType.DROPDOWN,
                    ),
                    ignoreBlank: false,
                    autoValidateMode: AutovalidateMode.disabled,
                    selectorTextStyle: TextStyle(color: AppColor.colorB9C9),
                    textStyle: TextStyle(color: AppColor.colorB9C9),
                    inputDecoration: InputDecoration(
                      hintText: "Phone number",
                      hintStyle: TextStyle(color: AppColor.colorB9C9),
                      labelStyle: TextStyle(color: AppColor.colorB9C9),
                      helperStyle: TextStyle(color: AppColor.colorB9C9),
                    ),
                    initialValue: PhoneNumber(isoCode: 'NG'),
                    textFieldController: t.phoneController,
                    formatInput: true,
                    hintText: "Phone number",
                    keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                    inputBorder: OutlineInputBorder(),
                    onSaved: (PhoneNumber number) {
                      print('On Saved: $number');
                    },
                  ),
                ),
                Container(
                  height: 40.h,
                  padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                  child: Row(
                    children: [
                      Text(
                        "Country",
                        style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: FONT_MEDIUM),
                      ),
                      Spacer(),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  child: Obx(() => t.countries.isEmpty
                      ? Container()
                      : Visibility(
                          visible: t.hasInited && t.countries.isNotEmpty,
                          child: CSCPicker(
                            countries: t.countries,
                            arrowColor: Colors.white60,
                            showStates: false,
                            showCities: false,
                            currentCountry: t._curCountry == null ? null : '${t._curCountry?.emoji}  ${t._curCountry?.name}',
                            currentState: t.state == null ? null : t.state,
                            currentCity: t.city == null ? null : t.city,
                            // flagState: CountryFlag.DISABLE,
                            //  disabledDropdownDecoration: BoxDecoration(
                            //      borderRadius: BorderRadius.all(Radius.circular(10)),
                            //      color: AppColor.itemBg,
                            //      border: Border.all(color: AppColor.itemBg, width: 1)),
                            dropdownDecoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), color: AppColor.itemBg2, border: Border.all(color: AppColor.itemBg2, width: 1)),
                            countrySearchPlaceholder: "Country".tr,
                            stateSearchPlaceholder: "State".tr,
                            citySearchPlaceholder: "City".tr,
                            countryDropdownLabel: "*${'Country'.tr}",
                            stateDropdownLabel: "*${'State'.tr}",
                            cityDropdownLabel: "*${'City'.tr}",
                            //  defaultCountry: DefaultCountry.United_States,
                            selectedItemStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                            dropdownDialogRadius: 10.0,
                            searchBarRadius: 10.0,
                            onCountryChanged: (value) {
                              //  flog('onCountryChanged${value.name}');
                              t.country = value?.name;
                              t._curCountry = value;
                            },
                            onStateChanged: (value) {
                              // flog('onStateChanged$value');
                              if (value == null && value == '*${'State'.tr}') {
                                t.state = null;
                                t._curState = null;
                              } else {
                                t.state = value;
                                t._curState = t._curCountry?.state.firstWhereOrNull((item) => item.name == t.state);
                              }
                            },
                            onCityChanged: (value) {
                              //   flog('onCityChanged$value');
                              //  if (value == null) return;
                              if (value == null && value == '*${'City'.tr}') {
                                t.city = null;
                              } else {
                                t.city = value;
                              }
                            },
                          ))),
                ),
                // 8.verticalSpace,
                // InputView(autoHeight: true, controller: t.countryController, label: "Country".tr, maxLength: 20, tips: "${UserController.find.userProfile.value.location.country}"),
                // 8.verticalSpace,
                InputView(
                    autoHeight: true,
                    controller: t.launageController,
                    label: "Language".tr,
                    maxLength: 20,
                    textInputType: TextInputType.phone,
                    tips: "${UserController.find.userProfile.value.language}"),
                AddressItemView(
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
                    style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: FONT_MEDIUM),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () => onEdit.call(),
                    child: Row(
                      children: [
                        ImageUtil.assetImage('ic_edit2', width: 15.w, height: 15.h, color: Colors.white),
                        5.horizontalSpace,
                        Text(
                          "Edit",
                          style: TextStyle(color: AppColor.yellow, fontSize: 16, fontFamily: FONT_MEDIUM),
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
              child: list_item(address.useDefault),
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
                style: TextStyle(color: address.useDefault ? AppColor.textYellow : Colors.white, fontWeight: FontWeight.bold, fontSize: 16.sp, fontFamily: FONT_MEDIUM),
              ),
              Spacer(),
              Text(
                "${address.phone}",
                style: TextStyle(
                  color: address.useDefault ? AppColor.textYellow : Colors.white,
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
              text: "${address.line1} | ${address.line2} | ${address.city} | ${address.postCode}",
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
  TextEditingController nickController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController launageController = TextEditingController();

  final sex = 2.obs;

  Rxn<String?> _country = Rxn();
  Rxn<String?> _state = Rxn();
  Rxn<String?> _city = Rxn();
  RxBool _hasInited = false.obs;

  bool get hasInited => _hasInited.value;

  set hasInited(bool value) {
    _hasInited.value = value;
  }

  String? get state => _state.value;

  String? get country => _country.value;

  String? get city => _city.value;

  showState() {
    if (_curCountry != null) {
      return _curCountry?.state.isNotEmpty == true;
    }
    if (_curState == null) return false;
    return country?.isNotEmpty == true;
  }

  showCity() {
    if (_curState == null) return false;
    if (_curCountry != null) {
      if (_curCountry?.state.isEmpty == true) return false;
    }
    //   if (state == null||state=='*State') return false;
    if (_curState == null) {
      return false;
    }
    return _curState?.city.isNotEmpty == true;
  }

  Country? _curCountry;
  Region? _curState;

  set country(String? value) {
    _country.value = value;
  }

  set state(String? value) {
    _state.value = value;
  }

  set city(String? value) {
    _city.value = value;
  }

  ///是否正在上传文件
  bool isUploadFile = false;
  @override
  void onInit() {
    // TODO: implement onInit
    initLocation();
    hasInited = true;

    super.onInit();
  }

  RxList<Country> countries = RxList();

  // List<Country> get countries => _countries;

  // set countries(List<Country> value) {
  //   _countries.value = value;
  // }

  initLocation() async {
    if (countries.isNotEmpty) return countries;
    countries.clear();
    var res = await rootBundle.loadString('assets/data/country.json');
    countries.value = (jsonDecode(res) as List).map((json) => Country.fromJson(json)).toList();
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
        EasyLoading.show();
        var url = await Common.uploadAvatar(value!, (p0, p1) => flog("$p0,$p1"));
        EasyLoading.dismiss();
        isUploadFile = false;
        UserController.find.updateInfo();
      });
    } else {
      print('No image selected.');
    }
  }

  void jumpEditAddress(bool edit, {AddressModel? address}) {
    // Get.to(() => EditAddressPage(
    //       edit: edit,
    //       address: address,
    //     ))?.then((value) {
    //   if (value != null && value == true) {}
    // });
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}
