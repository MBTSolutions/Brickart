import 'package:brickart_flutter/controller/cart_controller.dart';
import 'package:brickart_flutter/screens/shopping_cart.dart';
import 'package:brickart_flutter/util/decimal_format.dart';
import 'package:brickart_flutter/widgets/icon_badge.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../util/textstyle_constant.dart';
import 'package:flutter/material.dart';

class BottomCartWidget extends StatelessWidget {
  final CartController _cartController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() => InkWell(
      onTap: _cartController.quantity.value <3 ?
      null :
      (){
        _cartController.getSheepValue();
          Get.to(ShoppingCartScreen());
          },
      child: Container(
        height: 48,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Each Additional Brick R\$35,00',
                      style: bottomAppBarTextStyle.copyWith(
                        color: Color(0xFFA1A4B1),
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Text(
                      'Sub-total: ${reaisFormat(
                          _cartController.product.value.price)}',
                      style: TextStyle(
                        color: Color(0xff5B5B5B),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                height: 48,
                color: _cartController.quantity.value < 3 ?
                Colors.grey :
                Theme.of(context).primaryColor,
                child: _cartController.quantity.value < 3 ?
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[

                     GestureDetector(

                     child:Center(
                      child: Text(
                        'Choose ${_cartController.product.value.mimimunOrderQuantity - _cartController.quantity.value} '
                            '${_cartController.product.value.mimimunOrderQuantity - _cartController.quantity.value == 1 ?  'image' : 'images'}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ),
                     onTap: (){
                       Get.to(()=>ShoppingCartScreen());

                     },

                     ),
                  ],
                ) :
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Center(
                      child: Text(
                        'Go to Cart',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ),
                   IconBadge(MdiIcons.cartOutline,
                      colorTextBadge: Get.theme.primaryColor,
                      colorBackground: Colors.white,
                      badge: _cartController.myGaleryPhotos.length.toString(),)

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
