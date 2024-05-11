import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sq_hub_app/image_utils.dart';

class WyConfirmDialog extends StatelessWidget {
  final Widget child;
  final bool forceShow;
  final String logo;
  final double? height;

  WyConfirmDialog({
    required this.child,
    this.forceShow = false,
    this.logo = "default_logo.webp",
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    double width = (MediaQuery.of(context).size.width - 80) / 2;
    return WillPopScope(
      onWillPop: () async {
        if (forceShow) {
          //await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          exit(0);
        }
        return true;
      },
      child: Dialog(
        backgroundColor: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        child: Container(
          clipBehavior: Clip.antiAlias,
          width: double.infinity,
          height: height,
          padding: EdgeInsets.only(top: 24.h),
          decoration: BoxDecoration(
            color: Color(0xFF23201C),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                ImageUtils.confirm_dialog_icon,
                width: 35.w,
              ),
              Container(
                margin: EdgeInsets.only(top: 20.h),
                child: Stack(
                  children: [
                    Positioned(
                      right: -24,
                      bottom: -20,
                      width: width,
                      child: Image.asset(
                        ImageUtils.ic_dialog,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 15,
                        right: 15,
                        bottom: 20,
                      ),
                      child: Center(child: child),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
