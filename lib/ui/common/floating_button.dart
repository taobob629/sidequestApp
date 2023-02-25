import 'package:flutter/material.dart';

import 'colorful_button.dart';

class FloatingButton extends StatelessWidget {
  final String label;
  final Function? onTap;

  FloatingButton({required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: ColorfulButton(
        height: 50,
        borderRadius: 25,
        child: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: "DIN"),
          ),
        ),
        onTap: () => onTap?.call(),
      ),
    );
  }
}
