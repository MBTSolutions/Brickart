import 'package:brickart_flutter/controller/cart_controller.dart';
import 'package:brickart_flutter/models/promo_code.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PromoCodeController extends GetxController{

  var checkingPromo = false.obs;
  var promoCode = ''.obs;
  bool get isNotEmptyPromoCode => !GetUtils.isNullOrBlank(promoCode.value);

  verifyPromoCode() async {

    checkingPromo.value = true;

    await Future.delayed(Duration(seconds: 3));

    var promo = await FirebaseFirestore.instance
    .collection('promo_code')
    .doc(promoCode.value)
    .get();

    if(promo.data() == null)
      Get.defaultDialog(
         title: 'Warning',
        middleText: 'Promo not found',
        textConfirm: 'OK',
        confirmTextColor: Colors.white,
        onConfirm: () => Get.back(),
        buttonColor: Get.theme.primaryColor
      );

    else {
      PromoCode pc = PromoCode.fromMap(promo.data());

      if(pc.dateExpiration.compareTo(DateTime.now()) < 0){
        Get.defaultDialog(
            title: 'Warning',
            middleText: 'Date promo expired',
            textConfirm: 'OK',
            confirmTextColor: Colors.white,
            onConfirm: () => Get.back(),
            buttonColor: Get.theme.primaryColor
        );
      } else {
        CartController cartController = Get.find();
        Get.defaultDialog(
            title: 'Success',
            middleText: 'Promo code inserted',
            textConfirm: 'OK',
            confirmTextColor: Colors.white,
            onConfirm: () {
              cartController.promoCode.value = pc;
              Get.back();
              Get.back();
            },
            buttonColor: Get.theme.primaryColor
        );
      }
    }

    checkingPromo.value = false;

  }

}