import 'dart:io';

import 'package:brickart_flutter/API/correios_api.dart';
import 'package:brickart_flutter/models/correios.dart';
import 'package:brickart_flutter/models/photos_my_galery.dart';
import 'package:brickart_flutter/models/product.dart';
import 'package:brickart_flutter/models/promo_code.dart';
import 'package:brickart_flutter/models/shipping.dart';
import 'package:brickart_flutter/models/shipping_address.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  var myGaleryPhotos = <PhotosMyGalery>[].obs;
  var product = Product().obs;
  var gettingShipValue = false.obs;
  var shipping = Shipping().obs;
  var correios = Correios().obs;
  var promoCode = PromoCode().obs;
  var address = ShippingAddress().obs;
  var quantity = 0.obs;
  var shippingValue = 0.0.obs;

  int get aditional => quantity.value - product.value.mimimunOrderQuantity;

  double get subtotal => quantity.value * product.value.price;
  double get total =>
      product.value.price +
      aditional * product.value.additionalPrice +
      correios.value.valor -
      promoCode.value.promoValue;
  bool get freeShipping =>
      shipping.value.isAllowFreeFrieght ||
      subtotal + promoCode.value.promoValue > shipping.value.freeShipping;
  DateTime get deliveryEstimate => new DateTime.now().add(Duration(
      days: correios.value.prazoEntrega +
          shipping.value.internalProduceTimeInDays));

  @override
  void onInit() async {
    try {
      FirebaseAuth.instance.authStateChanges().listen((event) {
        User user = event;
        if (user != null) {
          FirebaseFirestore.instance
              .collection('configs')
              .snapshots()
              .listen((event) async {
            try {
              product.value = Product.fromMap(event.docs[0].data());
              shipping.value = Shipping.fromMap(event.docs[1].data());
            } catch (e) {
              print(e);
            }
          });

          FirebaseFirestore.instance
              .collection('users')
              .doc(user == null && user == null ? '' : user.uid)
              .collection('address')
              .doc('1')
              .snapshots()
              .listen((value) {
            if (value.data() != null) {
              address.value = ShippingAddress();
              address.value = ShippingAddress.fromMap(value.data());
            } else {
              address.value = null;
            }
          });

          myGaleryPhotos.listen((data) {
            int newQuantity = 0;
            data.forEach((element) {
              newQuantity += element.quantity.value;
            });
            quantity.value = newQuantity;
          });
        } else {
          myGaleryPhotos.clear();
          product.value = Product();
          gettingShipValue.value = false;
          shipping.value = Shipping();
          correios.value = Correios();
          promoCode.value = PromoCode();
          address.value = ShippingAddress();
          quantity.value = 0;
          shippingValue.value = 0.0;
        }
      });

      address.listen((event) {
        getSheepValue();
      });
    } catch (e) {
      print(e);
    }
    super.onInit();
  }

  updateImageCart(int index, File file) {
    var changed = myGaleryPhotos[index];

    changed.imageChanged = file.readAsBytesSync();

    myGaleryPhotos[index] = changed;
  }

  getSheepValue() async {
    if (gettingShipValue.value ||
        address.value == null ||
        address.value.zipCode == null) return;
    if (freeShipping) {
      correios.value.valor = 0.0;
      return;
    }
    gettingShipValue.value = true;
    correios.value = await CorreiosAPI.getCorreios();
    shippingValue.value = correios.value.valor;
    gettingShipValue.value = false;
  }
}
