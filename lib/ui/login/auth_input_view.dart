import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wy/config/app_color.dart';

class AuthInputView extends StatelessWidget {
  final String tips;
  final bool isRequired;
  final bool password;
  final TextInputType? keyboardType;
  final TextEditingController? editingController;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final Function(String)? onSubmitted;
  final VoidCallback? onRightCallback;
  final List<TextInputFormatter>? inputFormatters;
  final bool readOnly;
  final bool rightBtn;

  AuthInputView({
    required this.tips,
    this.isRequired = true,
    this.password = false,
    this.keyboardType,
    this.editingController,
    this.focusNode,
    this.textInputAction,
    this.inputFormatters,
    this.readOnly = false,
    this.rightBtn = false,
    this.onSubmitted,
    this.onRightCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.only(left: 16).r,
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.all(Radius.circular(16)).w,
      ),
      child: Row(
        children: [
          Expanded(
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
              readOnly: readOnly,
              decoration: InputDecoration(
                  hintText: isRequired ? '* $tips' : tips,
                  hintStyle: TextStyle(fontSize: 14, color: AppColor.whiteGray),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(bottom: 0)),
              onSubmitted: onSubmitted,
            ),
          ),
          Visibility(
            visible: rightBtn,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: onRightCallback,
              child: Container(
                height: 48,
                alignment: Alignment.center,
                padding: EdgeInsets.only(left: 6.w, right: 10.w),
                child: Text(
                  'Send',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
