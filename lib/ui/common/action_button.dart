import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final Function? onTap;
  final Widget icon;
  ActionButton({
    required this.icon,
    this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: ()=> this.onTap?.call(),
        borderRadius: BorderRadius.circular(30),
        child: Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30)
          ),
          child: Center(child: icon),
        ),
      ),
    );
  }
}