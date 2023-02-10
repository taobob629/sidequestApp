import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wy/config/app_color.dart';

class AuthInputView extends StatelessWidget {

  final String tips;
  final bool password;
  final TextInputType? keyboardType;
  final TextEditingController? editingController;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final Function(String)? onSubmitted;
  final List<TextInputFormatter>? inputFormatters;

  AuthInputView({
    required this.tips,
    this.password = false,
    this.keyboardType,
    this.editingController,
    this.focusNode,
    this.textInputAction,
    this.inputFormatters,
    this.onSubmitted
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.only(left: 20),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.all(Radius.circular(16)).w,
      ),
      child: TextField(
        controller: editingController,
        focusNode: focusNode,
        maxLines: 1,
        keyboardType: keyboardType,
        obscureText: password,
        cursorColor: Colors.white70,
        textAlign: TextAlign.start,
        textInputAction: textInputAction,
        inputFormatters: inputFormatters,
        style: const TextStyle(color: Colors.white, fontSize: 16),
        decoration: InputDecoration(
          hintText: tips,
          hintStyle: TextStyle(fontSize: 14, color: AppColor.whiteGray),
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(bottom: 0)
        ),
        onSubmitted: onSubmitted,
      ),
    );
  }
}