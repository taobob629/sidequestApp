import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wy/common/paixs_fun.dart';
import 'package:wy/ui/common/floating_button.dart';
import 'package:wy/ui/common/input_view.dart';
import 'package:wy/ui/common/privacy_check.dart';
import 'package:wy/ui/profile/bankcard/controller.dart';
import 'package:wy/ui/profile/bankcard/widget/bank_field.dart';
import 'package:wy/utils/text_utils.dart';
import 'package:wy/view/views.dart';
import 'package:wy/widget/city_picker/csc_picker.dart';
import 'package:wy/widget/mylistview.dart';
import 'package:wy/widget/paixs_widget.dart';
import 'package:wy/widget/scaffold_widget.dart';

/**
    view
    sidequest_hub_app
    desc:
    Created by chunma on .
    Copyright © sidequest_hub_app. All rights reserved.
 **/
class BindBankCardPage extends GetView<BindBankCardController> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      appBar: AppBar(
        title: Text('Bind bank card'.tr, style: TextStyle(fontSize: 18)),
        centerTitle: true,
        elevation: 0,
      ),
      body: _buildForm(),
      btnBar: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
        //  PrivacyCheck(controller: controller.privacyCheckController, type: TYPE_ADD_BANK),
          FloatingButton(
            label: "Next".tr,
            onTap: () {
              controller.save();
            },
          )
        ],
      ),
    );
  }

  _buildForm() => MyListView(
    isShuaxin: false,
        flag: false,
        //  padding: EdgeInsets.all(16),
        itemCount: item.length,
        item: (i) => item[i],
        divider: Divider(height: 2, color: Colors.transparent),
      );

  List<Widget> get item {
    return [
      PWidget.container(
        PWidget.row([
          PWidget.image('assets/images/ic_safety.webp', [24, 24]),
          PWidget.boxw(8),
          Expanded(
            child: Text(
              'In order to ensure normal bank card signing, you need to collect your bank card information to ensure privacy and security throughout the process. Please feel free to use'
                  .tr,
              style: TextStyle(color: Color(0xff4488FF)),
            ),
          ),
        ], '000'),
        [null, null, Color(0xffDEEAFF).withOpacity(0.1)],
        {'pd': 8},
      ),
      PWidget.text(
        'Bank card information'.tr,
        [Colors.white, 18, true],
        {'ff': 'DIN', 'pd': PFun.lg(16, 16, 26, 16)},
      ),
      InputView(
          controller: controller.sortCodeTEC,
          label: "Sort Code (Optional)".tr,
          inputFormatters: [
            TextInputFormatter.withFunction(
                (oldValue, newValue) => TextUtils.addSortCodeSeparator(newValue.text))
          ],
          maxLength: 20,
          tips: "please input".tr),
      InputView(
          controller: controller.swiftCodeTEC,
          label: "SWIFT Code (Optional)".tr,
          maxLength: 20,
          tips: "optional".tr),
      InputView(
        controller: controller.bankCountryTEC,
        label: '*${'Recipient’s Bank Country'.tr}',
        maxLength: 20,
        customInput: country_widget(),
        tips: '',
      ),
      bankNameWidget(),
      InputView(
        controller: controller.bankIBANTEC,
        label: '${'Recipient’s IBAN (optional)'.tr}',
        maxLength: 20,
        tips: 'optional',
      ),
      InputView(
          controller: controller.accountNumTEC,
          label: '*${'Recipient Bank Account Number'.tr}',
          maxLength: 20,
          tips: "please input".tr),
      InputView(
          controller: controller.bankAddressTEC,
          label: '*${'Recipient Bank Address'.tr}',
          maxLength: 20,
          tips: "please input".tr),
      InputView(
          controller: controller.nameOnAccountNumTEC,
          label: '*${'Recipient’s Bank Account Name'.tr}',
          maxLength: 20,
          tips: "please input".tr),
    ];
  }

  Widget bankNameWidget() {
    //return itemBg(BanksField());
    return InputView(
        controller: controller.bankNameTEC,
        label: '*${'Recipient Bank Name'.tr}',
        maxLength: 20,
        customInput: BanksField(),
        tips: "please input".tr);
  }

  country_widget() {
    return Obx(() => CSCPicker(
          countries: controller.countries,
          arrowColor: Colors.white60,
          showStates: false,
          showCities: false,
          dropdownDecoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(0)), color: Colors.transparent),
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
            controller.updateBanks(value);
          },
          onStateChanged: (value) {},
          onCityChanged: (value) {},
        ));
  }

  Widget itemBg(view, {Function? fun}) {
    return Container(
      child: view,
      padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
      decoration: ShapeDecoration(
        color: Color(0xff282640),
        shape: StadiumBorder(),
      ),
    );
    return PWidget.container(
        view, [null, 48, Color(0xff282640)], {'br': 48, 'pd': PFun.lg(0, 0, 16, 16), 'fun': fun});
  }

  _dropDownItems() {}
}
