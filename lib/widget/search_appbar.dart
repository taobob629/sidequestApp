/**
    author:mac
    创建日期:2023/2/2
    描述:
 */
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchAppBar extends StatelessWidget {
  final String hintLabel;
  final TextEditingController? textEditingController;
  bool canInput;
  bool showRight;
  Function()? onTap;

  SearchAppBar(
      {required this.hintLabel,
      this.textEditingController,
      this.canInput = false,
      this.onTap,
      this.showRight = true})
      : super();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap?.call(),
      //  height: 70,
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              height: 40,
              margin: EdgeInsets.only(left: 16,right: 16),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white10),
                  borderRadius: BorderRadius.circular(8)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Image.asset(
                      "assets/images/ic_search.webp",
                      width: 20,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      enabled: canInput,
                      controller: textEditingController,
                      autofocus: false,
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white30,
                          textBaseline: TextBaseline.alphabetic),
                      decoration: InputDecoration(
                          hintText: hintLabel,
                          counterText: '',
                          hintStyle: TextStyle(fontSize: 14, color: Colors.white30),

                          /// 以下设置为了让textfield占满父组件的高度且内容居中
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.transparent,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.transparent,
                            ),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.transparent,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.transparent,
                            ),
                          ),
                          contentPadding: EdgeInsets.only(top: 0, bottom: 0)),
                      maxLines: 1,

                      /// 光标样式
                      cursorColor: Colors.black87,
                    ),
                  )
                ],
              ),
            ),
          ),
          if (showRight)
            GestureDetector(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'CANCEL'.tr,
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
