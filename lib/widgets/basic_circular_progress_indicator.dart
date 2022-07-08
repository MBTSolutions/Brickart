import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BasicCircularProgressIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Get.theme.primaryColor) ,);
  }
}
