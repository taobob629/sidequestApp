import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/ui/controller/cart_controller.dart';
import 'package:wy/ui/shop/product/product_page.dart';

class AddButton extends StatelessWidget {

  final Function onTap;
  final int productId;

  late final ProductPageController productPageController;

  AddButton({
    required this.productId,
    required this.onTap
  }){
    productPageController = Get.find<ProductPageController>(tag: productId.toString());
  }

  final cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery
      .of(context)
      .size
      .width;
    return Container(
      height: 60,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 5,
            bottom: 0,
            width: width / 2 + 10,
            child: Container(
              color: Color(0xB3000000),
              child: Padding(
                padding: const EdgeInsets.only(top: 10, left: 20),
                child: Obx(()=>Text(
                  "£ ${productPageController.productDetailModel.value.price}",
                  style: TextStyle(color: Colors.white, fontFamily: "DIN", fontSize: 30),
                )),
              ),
            )
          ),
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            width: width / 2 + 30,
            child: ClipPath(
              clipper: _TrapezoidPath(),
              child: Stack(
                children: [
                  Container(
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Color(0xFFFC3C02), Color(0xFF841FC3)]
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            "ADD TO CART".tr,
                                style: TextStyle(color: Colors.white, fontFamily: "DIN", fontSize: 22),
                              ),
                        ),
                        SizedBox(width: 20, height: 10,),
                        Obx(() {
                          return Badge(
                            showBadge: productPageController.productCount.value > 0,
                            shape: BadgeShape.circle,
                            badgeColor: AppColor.accent,
                            toAnimate: false,
                            badgeContent: Text(
                              "${productPageController.productCount.value}",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white
                              ),
                            ),
                            child: Icon(Icons.shopping_cart, color: Colors.white, size: 32,),
                          );
                        }),
                      ],
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: Ink(
                      child: InkWell(
                        onTap: ()=>onTap.call(),
                        child: Container()
                      ),
                    ),
                  )
                ],
              )
            )
          )
        ],
      ),
    );
  }
}

class _TrapezoidPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(0, size.height); //x,y坐标
    path.lineTo(30, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}