import 'package:brickart_flutter/controller/cart_controller.dart';
import 'package:brickart_flutter/controller/login_controller.dart';
import 'package:brickart_flutter/models/shipping_address.dart';
import 'package:brickart_flutter/models/user.dart' as UserModel;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShippingAddressController extends GetxController {
  CartController _cartController = Get.find();
  LoginController _loginController = Get.find();
  final emailController = TextEditingController();
  final fullNameController = TextEditingController();
  final documentController = TextEditingController();
  // final emailController = TextEditingController();
  final whatsAppNumberController = TextEditingController();
  final zipCodController = TextEditingController();
  final addressController = TextEditingController();
  final addresNumberController = TextEditingController();
  final extentionController = TextEditingController();
  final neighborhoodController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  var addingShippingAddress = false.obs;

  var newShippingAddress = ShippingAddress();

  @override
  void onInit() {
    if (_cartController.address.value != null) {
      newShippingAddress = _cartController.address.value;
    }
    super.onInit();
  }

  saveOrUpdateShippingAddress() async {
    addingShippingAddress.value = true;
    print("Email Address is this:${newShippingAddress.email}");
    emailController.text = newShippingAddress.email.toString();
    User user = _loginController.userLog;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('address')
        .doc('1')
        .set(newShippingAddress.toMap());
    print('debug');
    addingShippingAddress.value = false;
    UserModel.User userModel = _loginController.user.value;
    Get.back();
    print('1');
    newShippingAddress.address = addressController.text;
    print(
        'ADDRESS CONTOLLER:${newShippingAddress.address == null ? "Empty" : newShippingAddress.address}');
    userModel.address = newShippingAddress.address;
    print('2');
    userModel.addressNumber = newShippingAddress.addressNumber;
    print('12');
    userModel.city = '${newShippingAddress.city} (${newShippingAddress.state})';
    print('22');
    userModel.disctrict = newShippingAddress.neighborhood;
    print('32');
    userModel.document = newShippingAddress.document;
    print('42');
    userModel.email = newShippingAddress.email;
    userModel.mobilePhone = newShippingAddress.whatsAppNumber;
    userModel.name = newShippingAddress.fullName;
    print('52');
    userModel.state = newShippingAddress.state;
    print('62');
    userModel.zipCode = newShippingAddress.zipCode;
    print('2');
    print("Email Address is this:${userModel.email}");
    // print('zipCode is this::${newShippingAddress.state}');
//  addingShippingAddress.value = false;
    
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .update(userModel.toMap());
    print("Email Address is this:${userModel.email}");

    print("Email Address is this3:${userModel.email}");
    // _cartController.onClose();

    // Get.back();
  }
}
