import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wy/common/paixs_fun.dart';
import 'package:wy/model/bank_card_model.dart';
import 'package:wy/ui/common/floating_button.dart';
import 'package:wy/ui/common/input_view.dart';
import 'package:wy/ui/profile/bankcard/controller.dart';
import 'package:wy/utils/text_utils.dart';
import 'package:wy/utils/utils.dart';
import 'package:wy/widget/city_picker/csc_picker.dart';
import 'package:wy/widget/city_picker/model/select_status_model.dart';
import 'package:wy/widget/light_text.dart';
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
            label: "Confirm".tr,
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
        divider: Divider(height: 8, color: Colors.transparent),
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
        controller: controller.bankCountryTEC,
        label: '*${'Recipient’s Bank Country'.tr}',
        maxLength: 24,
        customInput: country_widget(),
        tips: '',
      ),
      Obx(() => Visibility(
            visible: controller.country?.name == ENGLAND,
            child: InputView(
                controller: controller.sortCodeTEC,
                label: "Sort Code".tr,
                inputFormatters: [
                  TextInputFormatter.withFunction(
                      (oldValue, newValue) => TextUtils.addSortCodeSeparator(newValue.text))
                ],
                maxLength: 20,
                tips: "please input".tr),
          )),
      Obx(() => Visibility(
          visible: controller.country != null && controller.country?.name != ENGLAND,
          child: InputView(
              controller: controller.swiftCodeTEC,
              label: "SWIFT Code".tr,
              maxLength: 20,
              tips: "please input".tr))),
      // InputView(
      //   controller: controller.bankIBANTEC,
      //   label: '${'Recipient’s IBAN (optional)'.tr}',
      //   maxLength: 20,
      //   tips: 'optional',
      // ),
      bankNameWidget(),

      InputView(
          controller: controller.nameOnAccountNumTEC,
          label: '*${'Recipient’s Bank Account Name'.tr}',
          maxLength: 24,
          tips: "please input".tr),
      InputView(
          controller: controller.accountNumTEC,
          label: '*${'Recipient Bank Account Number'.tr}',
          maxLength: 100,
          tips: "please input".tr),
      InputView(
          controller: controller.bankAddressTEC,
          label: '${'Recipient Bank Address (Optional)'.tr}',
          maxLength: 200,
          tips: "please input".tr),
      // InputView(
      //     controller: controller.accountAddressTEC,
      //     label: '*${'Recipient’s Bank Account Address'.tr}',
      //     maxLength: 20,
      //     tips: "please input".tr),
    ];
  }

  final TextStyle lightTextStyle = const TextStyle(
    color: Colors.blue,
    fontWeight: FontWeight.bold,
  );

  InlineSpan formSpan(String src, String pattern) {
    List<TextSpan> span = [];
    List<String> parts = src.split(pattern);
    if (parts.length > 1) {
      for (int i = 0; i < parts.length; i++) {
        span.add(TextSpan(text: parts[i]));
        if (i != parts.length - 1) {
          span.add(TextSpan(text: pattern, style: lightTextStyle));
        }
      }
    } else {
      span.add(TextSpan(text: src));
    }
    return TextSpan(children: span);
  }

  Widget bankNameWidget() {
    //return itemBg(BanksField());
    return InputView(
        // controller: controller.bankNameTEC,
        label: '*${'Recipient Bank Name'.tr}',
        maxLength: 20,
        customInput: Autocomplete<SimpleBankModel>(
          optionsMaxHeight: Get.height,
          optionsBuilder: (value) => controller.banks,
          displayStringForOption: (bank) => bank.bank ?? '',
          onSelected: (value) {},
          fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
            controller.bankNameTEC = textEditingController;
            return Container(
              child: TextFormField(
                controller: textEditingController,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                focusNode: focusNode,
                onFieldSubmitted: (String value) {
                  onFieldSubmitted();
                },
                onChanged: (text) {
                  controller.filterBank(text.toUpperCase());
                },
                decoration: InputDecoration(
                  hintText: 'please input'.tr,
                  counterText: '',
                  hintStyle: TextStyle(fontSize: 14, color: Colors.white24),
                  border: InputBorder.none,
                ),
              ),
            );
          },
          optionsViewBuilder: (context, onSelected, options) => Obx(() => ListView.builder(
              itemCount: controller.filterBanks.length,
              itemBuilder: (context, index) => Material(
                    color: Color(0xff282640),
                    child: ListTile(
                      onTap: () {
                        SimpleBankModel model = controller.filterBanks[index];
                        onSelected(model);
                      },
                      title: LightTextWidget(
                        text: '${controller.filterBanks[index].bank}',
                        lightText: controller.keyWord,
                      ),
                    ),
                  ))),
        ),
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
