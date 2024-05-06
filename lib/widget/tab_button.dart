import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sq_hub_app/image_utils.dart';

class TabButton extends StatefulWidget {
  final int index;
  final int currentIndex;
  final String selectIconName;
  final String normalIconName;
  final Function onTap;

  TabButton({
    required this.index,
    required this.currentIndex,
    required this.selectIconName,
    required this.normalIconName,
    required this.onTap,
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
        width: 50.h,
        height: 50.h,
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
          width: 50.h,
          height: 50.h,
          child: Image.asset(
            widget.selectIconName,
            fit: BoxFit.contain,
            height: 50.h,
          ),
        ),
      );
    } else {
      icons.add(
        Container(
          width: 50.h,
          height: 50.h,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          color: Colors.transparent,
          child: Image.asset(
            widget.normalIconName,
            fit: BoxFit.contain,
          ),
        ),
      );
    }
    return icons;
  }
}
