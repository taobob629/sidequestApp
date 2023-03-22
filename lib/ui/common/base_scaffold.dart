import 'package:flutter/material.dart';
import 'package:wy/config/app_color.dart';

import 'floating_button_animation.dart';
import 'page_title.dart';

class BaseScaffold extends StatelessWidget {
  final String title;
  Color backgroundColor;
  final Color appBarBackgroundColor;
  final List<Widget>? actions;
  final Widget body;
  final Widget? floatingActionButton;
  final bool resizeToAvoidBottomInset;

  BaseScaffold({
    required this.title,
    this.backgroundColor = AppColor.background,
    this.appBarBackgroundColor = AppColor.background,
    required this.body,
    this.actions,
    this.floatingActionButton,
    this.resizeToAvoidBottomInset = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: appBarBackgroundColor,
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
      floatingActionButtonAnimator: FloatingButtonAnimation(),
    );
  }
}
