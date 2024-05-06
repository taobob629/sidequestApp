import 'package:flutter/material.dart';

import 'mytext.dart';

class ShimmerWidget extends StatelessWidget {
  final String? text;
  final Color textColor;
  final String redText;
  final Function? callBack;
  final Color color;

  const ShimmerWidget({
    Key? key,
    this.text,
    this.callBack,
    this.redText = 'Click Retry',
    this.color = Colors.white,
    this.textColor = const Color(0xff999999),
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var isToken = text?.contains('token');
    return Container(
      color: color,
      alignment: Alignment.center,
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 250),
        child: GestureDetector(
          onTap: callBack == null ? () {} : () => callBack!(),
          child: MyText(
            isToken! ? 'Login status has expired' : text,
            size: 16,
            color: textColor,
            textAlign: TextAlign.center,
            isOverflow: false,
            children: [
              MyText.ts(
                callBack == null ? '' : (isToken ? '' : '\t$redText'),
                color: Theme.of(context).primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
