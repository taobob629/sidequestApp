import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:wy/common/paixs_fun.dart';
import 'package:wy/model/event_detail_model.dart';
import 'package:wy/model/selector_item.dart';
import 'package:wy/ui/common/colorful_button.dart';
import 'package:wy/ui/common/dialog_date_time_picker.dart';
import 'package:wy/ui/common/dialog_selector.dart';
import 'package:wy/utils/utils.dart';
import 'package:wy/widget/paixs_widget.dart';

class EventSelectoWidget extends StatefulWidget {
  final String title;
  final List<SelectorItem> selectorList;
  const EventSelectoWidget(this.title, {Key? key, this.selectorList = const []}) : super(key: key);
  @override
  _EventSelectoWidgetState createState() => _EventSelectoWidgetState();
}

class _EventSelectoWidgetState extends State<EventSelectoWidget> {
  SelectorItem? item;
  LocationModel? store;
  DateTime? dateTime1;
  DateTime? dateTime2;

  @override
  void initState() {
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    if (widget.selectorList.length == 1) {
      item = widget.selectorList[0];
      store = item as LocationModel;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PWidget.container(
      PWidget.column([
        PWidget.text(widget.title, [Colors.white, 20, true], {'ff': 'DIN'}),
        PWidget.boxh(16),
        PWidget.text('${'Location'.tr} : ', [Colors.white, 16], {'ff': 'DIN'}),
        PWidget.boxh(8),
        PWidget.row([
          Expanded(
            child: GestureDetector(
              onTap: () async {
                item = await SelectorDialog.show(context, widget.selectorList, title: "Select Location".tr);
                if (item != null) {
                  store = item as LocationModel;
                  setState(() {});
                }
              },
              child: PWidget.container(
                PWidget.row([
                  PWidget.text(
                    item == null ? 'Please select location'.tr : store?.name,
                    [Colors.white.withOpacity(item == null ? 0.5 : 1), 16],
                    {'ff': 'DIN', 'exp': true},
                  ),
                  PWidget.boxw(8),
                  PWidget.icon(Icons.keyboard_arrow_down_rounded, [Colors.white70]),
                ]),
                [null, null, Colors.white10],
                {'pd': 8, 'br': 8},
              ),
            ),
          ),
        ]),
        PWidget.boxh(24),
        PWidget.text('${'Cup Sleeve'.tr} : ', [Colors.white, 16], {'ff': 'DIN'}),
        PWidget.boxh(8),
        PWidget.row([
          Expanded(
            child: GestureDetector(
              onTap: () async {
                var res = await showDialog(
                  context: context,
                  builder: (_) {
                    return DateTimePickerDialog(
                      initDateTime: DateTime.now(),
                      format: 'HH:mm',
                    );
                  },
                );
                if (res != null) {
                  setState(() {
                    dateTime1 = res;
                    dateTime2 = (res as DateTime).add(Duration(minutes: 15));
                  });
                }
              },
              child: PWidget.container(
                PWidget.row([
                  PWidget.icon(Icons.alarm_rounded, [Colors.white70, 20]),
                  PWidget.boxw(8),
                  PWidget.text(
                    dateTime1 == null ? 'cup sleeve required'.tr : (dateTime1.toString().split(' ').last.split(':')).sublist(0, 2).join(':'),
                    [Colors.white.withOpacity(dateTime1 == null ? 0.5 : 1), 16],
                    {'ff': 'DIN', 'exp': true},
                  ),
                ]),
                [null, null, Colors.white10],
                {'pd': 8, 'br': 8},
              ),
            ),
          ),
          PWidget.container(null, [8, 2, Colors.white70], {'mg': PFun.lg(0, 0, 4, 4)}),
          Expanded(
            child: PWidget.container(
              PWidget.row([
                PWidget.icon(Icons.alarm_rounded, [Colors.white70, 20]),
                PWidget.boxw(8),
                PWidget.text(
                  dateTime2 == null ? 'cup sleeve required'.tr : (dateTime2.toString().split(' ').last.split(':')).sublist(0, 2).join(':'),
                  [Colors.white.withOpacity(0.5), 16],
                  {'ff': 'DIN', 'exp': true},
                ),
              ]),
              [null, null, Colors.white10],
              {'pd': 8, 'br': 8},
            ),
          ),
        ]),
        PWidget.boxh(16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: ColorfulButton(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text('confirm'.tr, style: TextStyle(color: Colors.white, fontFamily: "DIN", fontSize: 18)),
            ),
            height: 48,
            onTap: () {
              if (item == null) return EasyLoading.showToast('Please select location'.tr);
              if (dateTime1 == null) return EasyLoading.showToast('cup sleeve required'.tr);
              Get.back(result: {'location': store, 'time': dateTime1});
            },
          ),
        ),
      ], '000'),
      [null, null, Color(0xff3B3860)],
      {'pd': 16, 'br': PFun.lg(16, 16)},
    );
  }
}
