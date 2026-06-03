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
  final Widget? bottomNavigationBar;
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
    this.bottomNavigationBar,
    this.resizeToAvoidBottomInset = true,
  });

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.of(context).canPop();

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: appBarBackgroundColor,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.white,
          size: 30,
        ),
        leadingWidth: 64.w,
        leading: leading ??
            (canPop
                ? IconButton(
                    tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                    constraints: BoxConstraints(
                      minWidth: 56.w,
                      minHeight: 56.w,
                    ),
                    iconSize: 30.w,
                    splashRadius: 28.w,
                    color: Colors.white,
                    icon: const Icon(Icons.arrow_back_ios_new),
                    onPressed: () => Navigator.maybePop(context),
                  )
                : null),
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
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
