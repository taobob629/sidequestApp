import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sq_hub_app/common/wy_dialog.dart';

import '../model/price_range_model.dart';
import '../model/selector_item.dart';
import '../utils/utils.dart';

class SelectorMutipleDialog extends StatelessWidget {
  final List<SelectorItem> items;
  List<SelectorItem>? initSelects;

  final bool showActions;

  final bool showInfo;

  final String title;
  final int mode;

  SelectorMutipleDialog(
      {required this.items,
      this.mode = single,
      this.showActions = false,
      this.showInfo = false,
      this.initSelects,
      this.title = ""});

  @override
  Widget build(BuildContext context) {
    selects.addAll(initSelects??[]);
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
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
          _buildItems(context),
          _buildActions()
        ],
      ),
    );
  }

  RxList<SelectorItem> selects = RxList();

  Widget _buildItems(BuildContext context) {
    double height = MediaQuery.of(context).size.height * 0.4;
    return Container(
      height: height,
      padding: const EdgeInsets.only(top: 15, bottom: 0),
      child: ListView.separated(
          itemBuilder: (context, index) {
            SelectorItem item = items[index];
            if (mode == single) {
              return ListTile(
                onTap: () {
                  Get.back(result: [item.displayLabel()]);
                },
                title: Text(
                  '${item.displayLabel()}',
                  style: TextStyle(color: Colors.white, fontSize: 12.sp),
                ),
              );
            }
            return Obx(() => CheckboxListTile(
                  value: selects.contains(item),
                  title: Text(
                    '${item.displayLabel()}',
                    style: TextStyle(color: Colors.white, fontSize: 12.sp),
                  ),
                  onChanged: (bool? value) {
                    flog('value $value');
                    if (value == true) {
                      selects.add(item);
                    } else {
                      selects.remove(item);
                    }
                  },
                ));
          },
          separatorBuilder: (context, index) {
            return Divider(
              height: 1,
              color: Colors.white24,
            );
          },
          itemCount: items.length),
    );
  }

  Widget _buildActions() {
    if (mode == multiple) {
      return Container(
        height: 50,
        decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.black12))),
        child: Row(
          children: [
            Expanded(
                child: TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text('Cancel'.tr, style: TextStyle(color: Colors.grey, fontSize: 16.sp)),
            )),
            Container(
              decoration: BoxDecoration(border: Border.all(width: 0.5, color: Colors.black12)),
            ),
            Expanded(
                child: TextButton(
              onPressed: () {
                Get.back(result: selects.map((e) => e.displayLabel()).toList());
              },
              child: Text(
                "Confirm".tr,
                style: TextStyle(color: Colors.white, fontSize: 16.sp),
              ),
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

  static Future<SelectorItem?> show(BuildContext context, List<SelectorItem> items,
      {String title = ""}) async {
    return await showDialog<SelectorItem>(
        context: context,
        barrierColor: Colors.black26,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SelectorMutipleDialog(
            items: items,
            title: title,
          );
        });
  }
}
