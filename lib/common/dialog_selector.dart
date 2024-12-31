import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sq_hub_app/common/wy_dialog.dart';
import 'package:sq_hub_app/utils/toast_utils.dart';

import '../image_utils.dart';
import '../model/selector_item.dart';

class SelectorDialog extends StatelessWidget {
  final List<SelectorItem> items;

  final bool showActions;

  final bool showInfo;

  final bool isSmartDialog;

  final String title;

  SelectorDialog({
    required this.items,
    this.showActions = false,
    this.showInfo = false,
    this.isSmartDialog = false,
    this.title = "",
  });

  @override
  Widget build(BuildContext context) {
    return WyDialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Offstage(
              offstage: title.isEmpty,
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          _buildItems(context),
          _buildActions()
        ],
      ),
    );
  }

  String showName(String name) {
    if (name.contains('9999')) {
      String showName = name.split('9999')[0];
      return showName;
    }
    return name;
  }

  Widget _buildItems(BuildContext context) {
    double height = MediaQuery.of(context).size.height * 0.4;
    return Container(
      height: height,
      padding: const EdgeInsets.only(top: 15, bottom: 0),
      child: ListView.separated(
        itemBuilder: (context, index) {
          SelectorItem item = items[index];
          return InkWell(
            onTap: () {
              if (item.selectable()) {
                if (!isSmartDialog) {
                  Navigator.pop(context, item);
                } else {
                  dismissLoading(result: item);
                }
              }
            },
            child: Container(
                color: Colors.transparent,
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              showName(item.displayLabel()),
                              style: TextStyle(
                                color: item.selectable()
                                    ? Colors.white
                                    : Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          6.horizontalSpace,
                          Visibility(
                            visible: item.displayLabel().contains('9999') &&
                                item.displayLabel().split('9999')[1] == 'true',
                            child: Image.asset(
                              ImageUtils.is_tech_pro_icon2,
                              scale: 1.7,
                            ),
                          ),
                        ],
                      ),
                    ),
                    this.showInfo
                        ? Text(
                            item.displayInfo(),
                            style:
                                TextStyle(color: Colors.white38, fontSize: 10),
                          )
                        : Container(),
                  ],
                )),
          );
        },
        separatorBuilder: (context, index) {
          return Divider(
            height: 1,
            color: Colors.white24,
          );
        },
        itemCount: items.length,
      ),
    );
  }

  Widget _buildActions() {
    if (showActions) {
      return Container(
        height: 50,
        decoration: BoxDecoration(
            border: Border(top: BorderSide(color: Colors.black12))),
        child: Row(
          children: [
            Expanded(
                child: Container(
              color: Colors.transparent,
              child: Center(
                  child: Text(
                "Cancel".tr,
                style: TextStyle(color: Colors.grey, fontSize: 16),
              )),
            )),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 0.5, color: Colors.black12)),
            ),
            Expanded(
                child: Container(
              color: Colors.transparent,
              child: Center(
                  child: Text(
                "Confirm".tr,
                style: TextStyle(color: Colors.black, fontSize: 16),
              )),
            ))
          ],
        ),
      );
    } else {
      return Container(
        height: 30,
      );
    }
  }

  static Future<SelectorItem?> show(
      BuildContext context, List<SelectorItem> items,
      {String title = ""}) async {
    return await showDialog<SelectorItem>(
        context: context,
        barrierColor: Colors.black26,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SelectorDialog(
            items: items,
            title: title,
          );
        });
  }
}
