import 'dart:io';
import 'dart:typed_data';

import 'package:brickart_flutter/controller/cart_controller.dart';
import 'package:brickart_flutter/models/photos_my_galery.dart';
import 'package:brickart_flutter/util/photo_manager_utils.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';

class MyGaleryController extends GetxController {
  CartController _cartController = Get.find();
  
  var getingPhotos = false.obs;
  var allPhotos = <PhotosMyGalery>[].obs;

  int page = 0;

  @override
  void onInit() async {
    allPhotos.clear();
    super.onInit();
  }

  getAllPhotos(int pageSize) async {
    try {
      getingPhotos.value = true;
      if (page == 0) {
        allPhotos.value = [];
      }

      List list = await PhotoManagerUtils.getPhotos(page: page, pageSize: pageSize);

      if(list != null) {
        await Future.forEach(list, (element) async {
          PhotosMyGalery myGalery = PhotosMyGalery();
          myGalery.id = element.id;
          myGalery.image = await _getFutureImage(element);
          myGalery.imagePath = await _imagePath(element);
          myGalery.lowQuality.value = await _imageLowQuality(element);
          allPhotos.add(myGalery);
        });
      }
      checkItensCart();
      getingPhotos.value = false;
    }catch(e){
      print(e);
    }
  }

  selectPhoto(int index, PhotosMyGalery photo){
    var changed = photo;
    changed.isSelected.value =! changed.isSelected.value;
    
    if(changed.isSelected.value){
      changed.quantity .value = 1;
      _cartController.myGaleryPhotos.add(changed);
    }
    else {
      changed.imageChanged = null;
      _cartController.myGaleryPhotos.removeWhere((item) =>
      item.id == changed.id);
    }
    allPhotos[index] = changed;
  }

  Future<Uint8List> _getFutureImage(AssetEntity entity) async {
    return await entity.thumbDataWithSize(200, 200);
  }

  checkItensCart() {
    allPhotos.forEach((PhotosMyGalery photosMyGalery) {
      photosMyGalery.isSelected.value = false;
    });

    _cartController.myGaleryPhotos.forEach((PhotosMyGalery element) {
      allPhotos.forEach((PhotosMyGalery photo) {
        var changed = photo;
        if(photo.id == element.id)
          changed.isSelected.value = true;
        photo = changed;
      });
    });
  }

  Future<bool> _imageLowQuality(AssetEntity entity) async {
    File file = await entity.file;

    int length = await file.length();

    ///1000000 == 1MB
    if(length < 1200)
      return true;
    return false;
  }

  Future<String> _imagePath(AssetEntity entity) async {
    File file = await entity.file;
    return file.path;
  }

}