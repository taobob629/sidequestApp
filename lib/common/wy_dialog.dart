import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sq_hub_app/image_utils.dart';

class WyDialog extends StatelessWidget {

  final Widget child;
  final bool forceShow;
  final String logo;
  final double? height;

  WyDialog({
    required this.child,
    this.forceShow = false,
    this.logo = "default_logo.webp",
    this.height
  });

  @override
  Widget build(BuildContext context) {
    double width = (MediaQuery.of(context).size.width - 80) / 2;
    return WillPopScope(
      onWillPop: () async{
        if(forceShow){
          //await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          exit(0);
        }
        return true;
      },
      child: Dialog(
        backgroundColor: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30)),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 40,),
                  Container(
                    clipBehavior: Clip.antiAlias,
                    width: double.infinity,
                    height: height,
                    padding: const EdgeInsets.only(top: 40),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Color(0xFFFC3C02),width: 3),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          right:-24,
                          bottom: -20,
                          width: width,
                          child: Image.asset(ImageUtils.ic_dialog,)
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15,right: 15,bottom: 20),
                          child: Center(child: child),
                        )
                      ],
                    )
                  ),
                  SizedBox(height: 40,),
                ],
              ),
            ),
            Positioned(
              left: 0,right: 0,top: 0,
              height: 80,
              child: CircleAvatar(
                backgroundColor: Colors.black,
                radius: 40,
                child: Container(
                  width: 76,
                  height: 76,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    image:DecorationImage(
                      image: AssetImage("assets/images/$logo"),
                      fit: BoxFit.cover,
                    )
                  ),
                ),
              )
            )
          ],
        ),
      ),
    );
  }
}