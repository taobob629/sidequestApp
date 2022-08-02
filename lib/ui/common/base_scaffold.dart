import 'package:flutter/material.dart';
import 'package:wy/config/app_color.dart';

import 'floating_button_animation.dart';
import 'page_title.dart';

class BaseScaffold extends StatelessWidget {
  final String title;
  final Color backgroundColor;
  final List<Widget>? actions;
  final Widget body;
  final Widget? floatingActionButton;

  BaseScaffold({
    required this.title,
    this.backgroundColor = AppColor.background,
    required this.body,
    this.actions,
    this.floatingActionButton
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        title: PageTitle(title: title,),
        actions: actions,
      ),
      body: body,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: floatingActionButton,
      floatingActionButtonAnimator: FloatingButtonAnimation(),
    );
  }
}