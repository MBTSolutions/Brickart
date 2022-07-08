import 'package:brickart_flutter/bloc/auth_bloc.dart';
import 'package:brickart_flutter/controller/cart_controller.dart';
import 'package:brickart_flutter/controller/payment_information_controller.dart';
import 'package:brickart_flutter/models/auth_status.dart';
import 'package:brickart_flutter/models/promo_code.dart';
import 'package:brickart_flutter/screens/add_promo_code_screen.dart';
import 'package:brickart_flutter/screens/credit_cards_screen.dart';
import 'package:brickart_flutter/screens/payment_information_screen.dart';
import 'package:brickart_flutter/screens/shipping_address_screen.dart';
import 'package:brickart_flutter/util/date_format.dart';
import 'package:brickart_flutter/util/decimal_format.dart';
import 'package:brickart_flutter/util/route_guard.dart';
import 'package:brickart_flutter/widgets/basic_circular_progress_indicator.dart';
import 'package:brickart_flutter/widgets/edit_your_brick_popup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../util/textstyle_constant.dart';
import '../widgets/appbar_listtile.dart';
import '../widgets/button_widget.dart';
import '../widgets/drawer_menu.dart';

class ShoppingCartScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  final CartController _cartController = Get.find();
  final PaymentInformationController _paymentController =
      Get.put(PaymentInformationController());

  @override
  Widget build(BuildContext context) {
    _cartController.quantity.listen((value) {
      if (value < 3) Get.back();
    });

    return StreamBuilder<AuthStatus>(
        stream: Provider.of<AuthBloc>(context).authStatus,
        builder: (context, snapshot) {
          if (snapshot?.data == AuthStatus.signedOut) {
            navigateToLogin(context);
            return Scaffold();
          } else {
            return Obx(() => Scaffold(
                  backgroundColor: Color(0xffE5E5E5),
                  appBar: AppBar(
                    automaticallyImplyLeading: false,
                    centerTitle: true,
                    title: AppbarListTile(
                      drawerKey: _drawerKey,
                      title: 'Shopping Cart',

                    ),



                  ),
                  key: _drawerKey,
                  drawer: DrawerMenu(),
                  body: SafeArea(
                    child: AnimatedCrossFade(
                      duration: Duration(seconds: 1),
                      firstChild: Column(
                        children: <Widget>[
                          Expanded(
                            child: ListView(
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  height: 40,
                                  color: Colors.white,
                                  child: Row(
                                    children: <Widget>[
                                      Image.asset(
                                        'assets/icons/gallery.png',
                                        height: 40,
                                        width: 40,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        'My Gallery',
                                        style: px12BoldBlack,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(left: 30),
                                  height: 250,
                                  child: ListView.builder(
                                    itemCount:
                                        _cartController.myGaleryPhotos.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) => Container(
                                      margin: const EdgeInsets.only(right: 20),
                                      child: Container(
                                      //  height: 250,
                                        //width: 250,
                                        // decoration: BoxDecoration(
                                        //   border: Border(
                                        //     bottom: BorderSide(
                                        //         width: 4, color: Colors.black),
                                        //     right: BorderSide(
                                        //         width: 5, color: Colors.black),
                                        //   ),
                                        // ),
                                      //  margin: EdgeInsets.only(left: 30, top: 100, right: 30, bottom: 50),
                                        height: 250,
                                        width: 250,
                                        // decoration: BoxDecoration(
                                        //   color: Colors.black,
                                        //
                                        //   borderRadius: BorderRadius.only(
                                        //       topLeft: Radius.circular(10),
                                        //       topRight: Radius.circular(10),
                                        //       bottomLeft: Radius.circular(10),
                                        //       bottomRight: Radius.circular(10)
                                        //   ),
                                        //   boxShadow: [
                                        //     BoxShadow(
                                        //       color: Colors.black.withOpacity(1),
                                        //       spreadRadius: 5,
                                        //       blurRadius: 7,
                                        //       offset: Offset(3.0, 0),
                                        //     ),
                                        //   ],),
                                        child: Stack(
                                          children: [
                                            Positioned(
                                              width: 250,
                                              height: 250,
                                              child: Image.memory(
                                                _cartController
                                                            .myGaleryPhotos[
                                                                index]
                                                            .imageChanged !=
                                                        null
                                                    ? _cartController
                                                        .myGaleryPhotos[index]
                                                        .imageChanged
                                                    : _cartController
                                                        .myGaleryPhotos[index]
                                                        .image,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            Positioned(
                                              bottom: 8,
                                              right: 8,
                                              child: InkWell(
                                                onTap: () {
                                                  showGeneralDialog(
                                                    context: Get.context,
                                                    barrierDismissible: true,
                                                    barrierLabel:
                                                        MaterialLocalizations
                                                                .of(context)
                                                            .modalBarrierDismissLabel,
                                                    barrierColor:
                                                        Colors.black45,
                                                    transitionDuration:
                                                        const Duration(
                                                            milliseconds: 200),
                                                    pageBuilder: (BuildContext
                                                            buildContext,
                                                        Animation animation,
                                                        Animation
                                                            secondaryAnimation) {
                                                      return EditYourBrickPopup(
                                                          index);
                                                    },
                                                  );
                                                },
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                              _cartController.myGaleryPhotos[index].quantity.value != 1 ?  ClipOval(
                                                child:Opacity(
                                                  opacity: 0.5,

                                                  child: Container(
                                                  height: 40,
                                                  width: 40,
                                                  color: Get.theme.primaryColor,
                                                  child: Center(
                                                    child: Container(
                                                      child: Text(_cartController.myGaleryPhotos[index].quantity.value.toString(), style:TextStyle(color: Colors.white, fontWeight: FontWeight.bold,)),
                                                    ),),
                                                  ),
                                                ),
                                              ):Container(),


                                              SizedBox(height:150),



                                              Opacity(
                                                opacity: 0.5,
                                                child:ClipOval(
                                                  child: Container(
                                                    height: 40,
                                                    width: 40,
                                                    color: Get.theme.primaryColor,
                                                    child: Image.asset(
                                                        'assets/icons/tap_image.png'),
                                                  ),
                                                 ),),



                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10,),
                                // Container(
                                //   padding: const EdgeInsets.symmetric(
                                //       horizontal: 20),
                                //   height: 40,
                                //   color: Colors.white,
                                //   child: Row(
                                //     children: <Widget>[
                                //       Image.asset(
                                //         'assets/icons/paint-brush.png',
                                //         height: 40,
                                //         width: 40,
                                //       ),
                                //       SizedBox(
                                //         width: 10,
                                //       ),
                                //       Text(
                                //         'Collections',
                                //         style: px12BoldBlack,
                                //       ),
                                //     ],
                                //   ),
                                // ),
                                // Container(
                                //   padding: const EdgeInsets.all(20),
                                //   child: Column(
                                //     children: <Widget>[
                                //       CircleAvatar(
                                //         backgroundColor: Color(0xffA1A4B1),
                                //         child: Center(
                                //           child: Icon(
                                //             Icons.add,
                                //             color: Colors.white,
                                //           ),
                                //         ),
                                //       ),
                                //       SizedBox(
                                //         height: 10,
                                //       ),
                                //       Text(
                                //         'Click to add a brick from your collection',
                                //         style: bottomAppBarTextStyle,
                                //       ),
                                //     ],
                                //   ),
                                // ),
                                GestureDetector(
                                  onTap: () {
                                    Get.to(ShippingAddressScreen());
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 5),
                                    height: 56,
                                    color: Colors.white,
                                    child: ListTile(
                                      leading: Image.asset(
                                        'assets/icons/home1.png',
                                        height: 40,
                                        width: 40,
                                      ),
                                      title: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text('Shipping Address',
                                              style: px12BoldBlack),
                                          Text(
                                            _cartController.address.value ==
                                                    null
                                                ? ''
                                                : '${_cartController.address.value.email}, '
                                                '${_cartController.address.value.addressNumber}, '
                                                '${_cartController.address.value.city} - ${
                                            _cartController.address.value.state
                                            }',
                                            //'Avenida lins de vasconcelos, 1455 - ap 44 bl 1 ',
                                            maxLines: 1,
                                            style: TextStyle(
                                              fontSize: 9,
                                              fontWeight: FontWeight.normal,
                                              fontStyle: FontStyle.normal,
                                              color: Color(0xffA1A4B1),
                                            ),
                                          ),
                                        ],
                                      ),
                                      trailing: Icon(
                                        Icons.arrow_forward_ios,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if (_paymentController.cardToken.value ==
                                            null ||
                                        _paymentController
                                                .cardToken.value.creditCardId ==
                                            null) {
                                      Get.to(PaymentInformationScreen());
                                    } else {
                                      Get.to(CreditCardsScreen());
                                    }
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 5),
                                    height: 56,
                                    color: Colors.white,
                                    child: ListTile(
                                      leading: Image.asset(
                                        'assets/icons/fileplus.png',
                                        height: 40,
                                        width: 40,
                                      ),
                                      title: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(' Payment Information',
                                              style: px12BoldBlack),
                                          Text(
                                            _paymentController
                                                            .cardToken.value ==
                                                        null ||
                                                    _paymentController
                                                            .cardToken
                                                            .value
                                                            .creditCardId ==
                                                        null
                                                ? 'Nenhum cartão'
                                                : '${_paymentController.cardToken.value.brand == null ? 'Não Identificado' : _paymentController.cardToken.value.brand}'
                                                    ' ****-****-****-${_paymentController.cardToken.value.last4CardNumber}',
                                            maxLines: 1,
                                            style: TextStyle(
                                              fontSize: 9,
                                              fontWeight: FontWeight.normal,
                                              fontStyle: FontStyle.normal,
                                              color: Color(0xffA1A4B1),
                                            ),
                                          ),
                                        ],
                                      ),
                                      trailing: Icon(
                                        Icons.arrow_forward_ios,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 40),
                                  height: 208,
                                  color: Colors.white,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Text(
                                        'Your Order',
                                        style: homeTitle.copyWith(
                                          fontSize: 16,

                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      rowOrder(
                                          '${_cartController.product.value.mimimunOrderQuantity} bricks for ${reaisFormat(_cartController.product.value.price)}',
                                          reaisFormat(_cartController
                                              .product.value.price)),
                                      rowOrder(
                                          _cartController.aditional > 0
                                              ? '${_cartController.aditional} additional brick${_cartController.aditional == 1 ? "" : "s"} for ${reaisFormat(_cartController.product.value.additionalPrice)} each'
                                              : 'No additional bricks',
                                          '${reaisFormat(_cartController.aditional * _cartController.product.value.additionalPrice)}'),
                                      rowOrder(
                                          'Shipping Cost',
                                          _cartController.freeShipping
                                              ? 'free'
                                              : _cartController
                                                      .gettingShipValue.value
                                                  ? 'Wait...'
                                                  : _cartController.address
                                                              .value.zipCode ==
                                                          null
                                                      ? 'S/Add'
                                                      : reaisFormat(
                                                          _cartController
                                                              .shippingValue
                                                              .value)),
                                      _cartController.promoCode.value.code ==
                                              null
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                InkWell(
                                                  onTap: () {
                                                    Get.to(
                                                        AddPromoCodeScreen());
                                                  },
                                                  child: Text(
                                                    'Promo Code',
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'Montserrat',
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        color:
                                                            Color(0xff303030),
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: 12,
                                                        decoration:
                                                            TextDecoration
                                                                .underline),
                                                  ),
                                                ),
                                                Text('R\$ 0,00',
                                                    style: px12BoldBlack),
                                              ],
                                            )
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Row(
                                                  children: [
                                                    Text(
                                                      _cartController
                                                          .promoCode.value.code,
                                                      maxLines: 1,
                                                      style:
                                                          px12BoldPrimaryColor,
                                                    ),
                                                    SizedBox(
                                                      width: 2,
                                                    ),
                                                    InkWell(
                                                      onTap: () =>
                                                          _cartController
                                                                  .promoCode
                                                                  .value =
                                                              PromoCode(),
                                                      child: Text(
                                                        '(remove)',
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Montserrat',
                                                            fontStyle: FontStyle
                                                                .normal,
                                                            color: Get.theme
                                                                .primaryColor,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            fontSize: 12,
                                                            decoration:
                                                                TextDecoration
                                                                    .underline),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                Text(
                                                    'R\$ -${doubleFormat(_cartController.promoCode.value.promoValue)}',
                                                    style:
                                                        px12BoldPrimaryColor),
                                              ],
                                            ),
                                      rowOrder(
                                          'Delivery Estimate',
                                          returnsFormattedDate(_cartController
                                              .deliveryEstimate)),
                                      rowOrder('Total',
                                          reaisFormat(_cartController.total)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: ButtonWidget(
                                    sizeButton: 48,
                                    onPressed:
                                        _cartController.address.value != null &&
                                                _paymentController
                                                        .cardToken.value !=
                                                    null &&
                                                !GetUtils.isNullOrBlank(
                                                    _paymentController.cardToken
                                                        .value.creditCardId)
                                            ? () => {
                                                /*here is where the charge executes*/

                                                  _paymentController
                                                      .completeOrder(),
                                                }
                                            :     ()=>  Get.offAllNamed('/confirme_order'),

                                    textColor: Colors.white,
                                    color: Get.theme.primaryColor,
                                    text: 'COMPLETE ORDER'),
                              ),
                            ],
                          ),
                        ],
                      ),
                      secondChild: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Processing Payment'),
                            SizedBox(
                              height: 8,
                            ),
                            BasicCircularProgressIndicator()
                          ],
                        ),
                      ),
                      crossFadeState: _paymentController.processingPayment.value
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                    ),
                  ),
                ));
          }
        });
  }

  rowOrder(String text, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(text, maxLines: 1, style: px12NormalBlack),
        Text(value, style: px12BoldBlack),
      ],
    );
  }
}
