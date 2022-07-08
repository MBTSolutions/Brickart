import 'dart:typed_data';

import 'package:get/get.dart';

class PhotosMyGalery extends GetObserver{
  String id;
  Uint8List image;
  Uint8List imageChanged;
  String imagePath;
  var isSelected = false.obs;
  var lowQuality = false.obs;
  var quantity = 0.obs;
}