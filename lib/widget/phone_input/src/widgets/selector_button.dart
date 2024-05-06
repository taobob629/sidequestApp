import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../config/app_color.dart';
import '../models/country_model.dart';
import '../test/test_helper.dart';
import '../utils/selector_config.dart';
import 'countries_search_list_widget.dart';
import 'input_widget.dart';
import 'item.dart';

/// [SelectorButton]
class SelectorButton extends StatelessWidget {
  final List<Country> countries;
  final Country? country;
  final SelectorConfig selectorConfig;
  final TextStyle? selectorTextStyle;
  final InputDecoration? searchBoxDecoration;
  final bool autoFocusSearchField;
  final String? locale;
  final bool isEnabled;
  final bool isScrollControlled;

  final ValueChanged<Country?> onCountryChanged;

  const SelectorButton({
    Key? key,
    required this.countries,
    required this.country,
    required this.selectorConfig,
    required this.selectorTextStyle,
    required this.searchBoxDecoration,
    required this.autoFocusSearchField,
    required this.locale,
    required this.onCountryChanged,
    required this.isEnabled,
    required this.isScrollControlled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return selectorConfig.selectorType == PhoneInputSelectorType.DROPDOWN
    //     ? countries.isNotEmpty && countries.length > 1
    //         ? DropdownButtonHideUnderline(
    //             child: DropdownButton<Country>(
    //               key: Key(TestHelper.DropdownButtonKeyValue),
    //               hint: Item(
    //                 country: country,
    //                 showFlag: selectorConfig.showFlags,
    //                 useEmoji: selectorConfig.useEmoji,
    //                 leadingPadding: selectorConfig.leadingPadding,
    //                 trailingSpace: selectorConfig.trailingSpace,
    //                 textStyle: selectorTextStyle,
    //               ),
    //               value: country,
    //               items: mapCountryToDropdownItem(countries),
    //               onChanged: isEnabled ? onCountryChanged : null,
    //             ),
    //           )
    //         : Item(
    //             country: country,
    //             showFlag: selectorConfig.showFlags,
    //             useEmoji: selectorConfig.useEmoji,
    //             leadingPadding: selectorConfig.leadingPadding,
    //             trailingSpace: selectorConfig.trailingSpace,
    //             textStyle: selectorTextStyle,
    //           )
    //     :
    return MaterialButton(
      key: Key(TestHelper.DropdownButtonKeyValue),
      padding: EdgeInsets.zero,
      minWidth: 0,
      onPressed: countries.isNotEmpty && countries.length > 1 && isEnabled
          ? () async {
              Country? selected;
              if (selectorConfig.selectorType ==
                  PhoneInputSelectorType.BOTTOM_SHEET) {
                selected =
                    await showCountrySelectorBottomSheet(context, countries);
              } else {
                // selected = await showCountrySelectorDialog(context, countries);
                Get.dialog(DropDownListView(
                    optionContext: context,
                    itemList: countries,
                    onTap: (int index) {
                      selected = countries[index];
                      if (selected != null) {
                        onCountryChanged(selected);
                      }
                    }));
              }

              if (selected != null) {
                onCountryChanged(selected);
              }
            }
          : null,
      child: Padding(
        padding: EdgeInsets.only(left: 10.w, right: 8.0.w),
        child: Row(
          children: [
            Expanded(
              child: Item(
                country: country,
                showFlag: selectorConfig.showFlags,
                useEmoji: selectorConfig.useEmoji,
                leadingPadding: selectorConfig.leadingPadding,
                trailingSpace: selectorConfig.trailingSpace,
                textStyle: selectorTextStyle,
              ),
            ),
            Icon(
              Icons.arrow_drop_down,
              color: AppColor.colorB9C9,
            )
          ],
        ),
      ),
    );
  }

  /// Converts the list [countries] to `DropdownMenuItem`
  List<DropdownMenuItem<Country>> mapCountryToDropdownItem(
      List<Country> countries) {
    return countries.map((country) {
      return DropdownMenuItem<Country>(
        value: country,
        child: Item(
          key: Key(TestHelper.countryItemKeyValue(country.alpha2Code)),
          country: country,
          showFlag: selectorConfig.showFlags,
          useEmoji: selectorConfig.useEmoji,
          textStyle: selectorTextStyle,
          withCountryNames: false,
          trailingSpace: selectorConfig.trailingSpace,
        ),
      );
    }).toList();
  }

  /// shows a Dialog with list [countries] if the [PhoneInputSelectorType.DIALOG] is selected
  Future<Country?> showCountrySelectorDialog(
      BuildContext inheritedContext, List<Country> countries) {
    return showDialog(
      context: inheritedContext,
      barrierDismissible: true,
      builder: (BuildContext context) => AlertDialog(
        content: Directionality(
          textDirection: Directionality.of(inheritedContext),
          child: Container(
            width: double.maxFinite,
            child: CountrySearchListWidget(
              countries,
              locale,
              searchBoxDecoration: searchBoxDecoration,
              showFlags: selectorConfig.showFlags,
              useEmoji: selectorConfig.useEmoji,
              autoFocus: autoFocusSearchField,
            ),
          ),
        ),
      ),
    );
  }

  /// shows a Dialog with list [countries] if the [PhoneInputSelectorType.BOTTOM_SHEET] is selected
  Future<Country?> showCountrySelectorBottomSheet(
      BuildContext inheritedContext, List<Country> countries) {
    return showModalBottomSheet(
      context: inheritedContext,
      clipBehavior: Clip.hardEdge,
      isScrollControlled: isScrollControlled,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12), topRight: Radius.circular(12))),
      builder: (BuildContext context) {
        return Stack(children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
          ),
          Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: DraggableScrollableSheet(
              builder: (BuildContext context, ScrollController controller) {
                return Directionality(
                  textDirection: Directionality.of(inheritedContext),
                  child: Container(
                    decoration: ShapeDecoration(
                      color: Theme.of(context).canvasColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                    ),
                    child: CountrySearchListWidget(
                      countries,
                      locale,
                      searchBoxDecoration: searchBoxDecoration,
                      scrollController: controller,
                      showFlags: selectorConfig.showFlags,
                      useEmoji: selectorConfig.useEmoji,
                      autoFocus: autoFocusSearchField,
                    ),
                  ),
                );
              },
            ),
          ),
        ]);
      },
    );
  }
}

class DropDownListView extends StatelessWidget {
  DropDownListView({
    Key? key,
    required this.optionContext,
    required this.onTap,
    this.itemList = const [],
  }) : super(key: key);

  final BuildContext optionContext;

  List<Country> itemList = [];

  final Function(int index) onTap;

  final _cellHeight = 40.h;

  @override
  Widget build(BuildContext context) {
    final RenderBox box = optionContext.findRenderObject()! as RenderBox;
    final Offset target = box.localToGlobal(
      box.size.bottomLeft(Offset.zero),
    );
    double viewHeight = min(240, _cellHeight * itemList.length);
    double? positionTop = target.dy - MediaQuery.of(Get.context!).padding.top;
    double? positionBottom = Get.height - target.dy;

    if (target.dy + viewHeight >= Get.height) {
      positionTop = null;
    } else {
      positionBottom = null;
    }
    debugPrint(
        "left:${target.dx} top:${target.dy}, viewHeight:$viewHeight，positionTop2 = $positionTop， positionBottom: $positionBottom");
    return Stack(
      children: [
        Positioned(
            left: target.dx,
            top: positionTop,
            bottom: positionBottom,
            child: Container(
              height: viewHeight,
              width: Get.width - 64,
              decoration: BoxDecoration(
                color: AppColor.itemBg2,
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: itemList.length,
                itemBuilder: ((context, index) {
                  final country = itemList[index];
                  return InkWell(
                    onTap: () {
                      onTap(index);
                      Get.back();
                    },
                    child: SizedBox(
                      height: _cellHeight,
                      child: Item(
                        key: Key(TestHelper.countryItemKeyValue(
                            country.alpha2Code)),
                        country: country,
                        showFlag: true,
                        useEmoji: false,
                        withCountryNames: true,
                      ),
                    ),
                  );
                }),
              ),
            )),
      ],
    );
  }
}
