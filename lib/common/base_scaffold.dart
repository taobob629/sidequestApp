import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sq_hub_app/common/page_title.dart';

import '../config/app_color.dart';

class BaseScaffold extends StatelessWidget {
  final String title;
  Color backgroundColor;
  final Color appBarBackgroundColor;
  final List<Widget>? actions;
  final Widget body;
  final Widget? floatingActionButton;
  final Widget? leading;
  final bool resizeToAvoidBottomInset;

  BaseScaffold({
    required this.title,
    this.backgroundColor = AppColor.background,
    this.appBarBackgroundColor = AppColor.background,
    required this.body,
    this.actions,
    this.leading,
    this.floatingActionButton,
    this.resizeToAvoidBottomInset = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: appBarBackgroundColor,
        leading: leading,
        elevation: 0,
        title: PageTitle(
          title: title,
        ),
        actions: actions,
      ),
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      body: body,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: floatingActionButton,
    );
  }
}
