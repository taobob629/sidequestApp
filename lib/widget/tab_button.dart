import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:badges/badges.dart' as badges;

class TabButton extends StatefulWidget {
  final int index;
  final int currentIndex;
  final String selectIconName;
  final String normalIconName;
  final Function onTap;
  final bool? showBadge;

  TabButton({
    required this.index,
    required this.currentIndex,
    required this.selectIconName,
    required this.normalIconName,
    required this.onTap,
    this.showBadge,
  });

  @override
  State createState() => _TabButtonState();
}

class _TabButtonState extends State<TabButton>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => widget.onTap.call(),
      child: SizedBox(
        width: 56.h,
        height: 56.h,
        child: Stack(
          children: createIcon(),
        ),
      ),
    );
  }

  List<Widget> createIcon() {
    List<Widget> icons = [];

    if (widget.index == widget.currentIndex) {
      icons.add(
        Container(
          alignment: Alignment.center,
          width: 56.h,
          height: 56.h,
          child: badges.Badge(
            showBadge: widget.showBadge ?? false,
            position: badges.BadgePosition(end: 0, top: 16),
            child: Image.asset(
              widget.selectIconName,
              fit: BoxFit.contain,
              height: 56.h,
            ),
          ),
        ),
      );
    } else {
      icons.add(
        Container(
          width: 56.h,
          height: 56.h,
          padding: widget.index == 2 ? EdgeInsets.zero : EdgeInsets.symmetric(horizontal: 12.w),
          color: Colors.transparent,
          child: badges.Badge(
            showBadge: widget.showBadge ?? false,
            position: badges.BadgePosition(end: 0, top: 16),
            child: Image.asset(
              widget.normalIconName,
              fit: BoxFit.contain,
              height: widget.index == 2 ? 56.h : null,
            ),
          ),
        ),
      );
    }
    return icons;
  }
}
