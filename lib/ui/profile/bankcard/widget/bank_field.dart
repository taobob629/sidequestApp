/*
  bank_field
  sidequest_hub_app
  desc:
  Created by chunma on .
  Copyright © sidequest_hub_app. All rights reserved.
*/
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wy/ui/profile/bankcard/controller.dart';

class BanksField extends StatefulWidget {
  @override
  _CountriesFieldState createState() => _CountriesFieldState();
}

class _CountriesFieldState extends State<BanksField> {
  final FocusNode _focusNode = FocusNode();
  BindBankCardController controller = Get.find<BindBankCardController>();
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      changeOverlayState();
    });
  }

  void changeOverlayState() {
    if (_focusNode.hasFocus) {
      this._overlayEntry = this._createOverlayEntry();
      Overlay.of(context)?.insert(this._overlayEntry!!);
    } else {
      this._overlayEntry?.remove();
    }
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);
    return OverlayEntry(
        builder: (context) => Positioned(
              left: offset?.dx,
              top: offset.dy + size.height + 5.0,
              width: size.width,
              child: Material(
                elevation: 4.0,
                color: Color(0xff282640),
                child: ListView(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  children: controller.banks
                      .map((bank) => ListTile(
                            dense: true,
                            title: Container(
                                child: Text(
                              '${bank.bank}',
                              style: TextStyle(color: Colors.white, fontSize: 14),
                            )),
                            onTap: () {
                              controller.bankNameTEC.text = '${bank.bank}';
                              this._overlayEntry?.remove();
                            },
                          ))
                      .toList(),
                ),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      // onTap: (){
      //   this._overlayEntry = this._createOverlayEntry();
      //   Overlay.of(context)?.insert(this._overlayEntry);
      // },
      controller: controller.bankNameTEC,
      focusNode: this._focusNode,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        hintText: 'please input'.tr,
        counterText: '',
        hintStyle: TextStyle(fontSize: 14, color: Colors.white24),
        border: InputBorder.none,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    this._overlayEntry?.remove();
  }
}
