import 'dart:async';
import 'package:brickart_flutter/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void navigateToLogin(BuildContext context) {
  @override
  void run() {
    scheduleMicrotask(() {
      //Get.offAllNamed('/login');
      Get.offAll(LoginScreen());
    });
  }

  run();
}
