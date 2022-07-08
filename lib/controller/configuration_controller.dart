import 'package:brickart_flutter/models/product.dart';
import 'package:brickart_flutter/models/shipping.dart';
import 'package:get/get.dart';

class ConfigurationController extends GetxController {
  var product = Product().obs;
  var shipping = Shipping().obs;

  @override
  void onInit() {
    super.onInit();
  }
}
