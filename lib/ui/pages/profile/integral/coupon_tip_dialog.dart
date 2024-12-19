import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:sq_hub_app/config/icon_font.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:html/dom.dart' as dom;

import '../../../../common/wy_confirm_dialog.dart';

class CouponTipDialog extends StatelessWidget {
  final String info;
  final String? confirmBtn;
  final Function? onConfirm;

  CouponTipDialog({
    required this.info,
    this.confirmBtn = "CONFIRM",
    this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return view2(context);
  }

  ///可滚动
  Widget view2(BuildContext context) {
    return WyConfirmDialog(
      child: SizedBox(
        height: 1.sw,
        child: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Platform.isAndroid
                    ? Html(
                        data: info,
                        style: {"body": Style()},
                        onLinkTap: (
                          String? url,
                          RenderContext context,
                          Map<String, String> attributes,
                          dom.Element? element,
                        ) async {
                          if (url != null) {
                            await launchUrl(Uri.parse(url));
                          }
                        },
                      )
                    : HtmlWidget(
                        info,
                        onTapUrl: (url) async =>
                            await launchUrl(Uri.parse(url)),
                      ),
              ),
            ),
            InkWell(
              onTap: () => onConfirm == null
                  ? Navigator.pop(context, true)
                  : onConfirm!.call(),
              child: Container(
                decoration: ShapeDecoration(
                  color: Color(0xFFFFB20E),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r)),
                ),
                alignment: Alignment.center,
                child: Text(
                  "$confirmBtn".tr,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontFamily: FONT_MEDIUM,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                height: 40.h,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
