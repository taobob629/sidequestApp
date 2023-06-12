import 'package:flutter/material.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:wy/ui/common/colorful_button.dart';
import 'package:wy/ui/common/wy_dialog.dart';

import '../../utils/toast_utils.dart';
import '../booking/booking_detail_ctr.dart';

class DateTimePickerDialog extends StatelessWidget {
  late final DateTimePickerDialogController controller;

  final String format;

  final DateTime? minDateTime;

  final DateTime? maxDateTime;

  final DateTime initDateTime;

  final int? minuteDivider;

  final bool ifSkip;

  DateTimePickerDialog({
    this.format = "dd-MM-yyyy",
    this.minDateTime,
    this.maxDateTime,
    required this.initDateTime,
    this.minuteDivider,
    this.ifSkip = false,
  }) {
    controller = Get.put(DateTimePickerDialogController(date: initDateTime));
  }

  @override
  Widget build(BuildContext context) {
    return WyDialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Text(
              "Select Time".tr,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white),
            ),
          ),
          _buildItems(context),
          _buildActions()
        ],
      ),
    );
  }

  Widget _buildItems(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(top: 0, bottom: 0),
        child: DateTimePickerWidget(
          dateFormat: format,
          minDateTime: minDateTime,
          initDateTime: initDateTime,
          maxDateTime: maxDateTime,
          minuteDivider: minuteDivider == null ? 1 : minuteDivider!,
          pickerTheme: DateTimePickerTheme(
              showTitle: false,
              backgroundColor: Colors.white12,
              itemTextStyle: TextStyle(color: Colors.white, fontSize: 14)),
          onChange: (date, _) => controller.updateDate(date),
        ));
  }

  Widget _buildActions() {
    return Container(
      height: 40,
      margin: const EdgeInsets.only(top: 10),
      decoration:
          BoxDecoration(border: Border(top: BorderSide(color: Colors.black12))),
      child: Row(
        children: [
          Expanded(
              child: ColorfulButton(
            onTap: () {
              DateTime selectTime = controller.getDate();
              if (ifSkip && (selectTime.hour > 24 || selectTime.hour < 12)) {
                showError(
                    "${BookingDetailCtr.find.model?.name} ${'is closed at that time.'.tr}");
                return;
              }
              Get.back(result: selectTime);
            },
            height: 40,
            child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  "CONFIRM".tr,
                  style: TextStyle(
                      color: Colors.white, fontSize: 18, fontFamily: "DIN"),
                )),
          ))
        ],
      ),
    );
  }
}

class DateTimePickerDialogController extends GetxController {
  late DateTime date;

  DateTimePickerDialogController({required this.date});

  void updateDate(DateTime date) {
    this.date = date;
  }

  DateTime getDate() {
    return this.date;
  }
}
