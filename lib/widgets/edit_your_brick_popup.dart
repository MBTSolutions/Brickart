 import 'dart:io';

import 'package:brickart_flutter/controller/cart_controller.dart';
import 'package:brickart_flutter/controller/my_galery_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';

import 'button_widget.dart';

class EditYourBrickPopup extends StatelessWidget {
  final CartController cartController = Get.find();
  final MyGaleryController myGaleryController = Get.find();

  final int index;
  EditYourBrickPopup(this.index);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Obx(() => Container(

        margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.10, top:MediaQuery.of(context).size.height * 0.60, ),

          child:Center(

        child: Container(
          width: 252,
          height: 353,
          color: Colors.transparent,
          child: Row(
            children: [
              Column(
                children: [
                  InkWell(
                    onTap:
                        cartController.gettingShipValue.value ?
                            null :
                        () {
                      if(cartController.myGaleryPhotos[index].quantity.value > 1){
                        cartController.myGaleryPhotos[index].quantity.value--;
                        var changed = cartController.myGaleryPhotos[index];
                        cartController.myGaleryPhotos[index] = changed;
                        cartController.getSheepValue();
                      }
                    },
                    child: ClipOval(
                      child: Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Center(
                              child: Icon(
                                Icons.remove_circle,
                                color: Get.theme.primaryColor,
                                size: 40,)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 12,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 40,
                      color: Colors.white,
                      child: Center(
                        child: Text(
                            '${cartController.myGaleryPhotos[index]
                                .quantity.value} copy'),
                      ),
                    ),
                    SizedBox(height: 15,),
                    Row(
                      children: [
                        Expanded(
                          child: ButtonWidget(
                            color: Colors.white,
                            text: 'Edit',
                            textColor: Get.theme.primaryColor,
                            onPressed: () async {
                                File croppedFile = await ImageCropper.cropImage(
                                    sourcePath: cartController.myGaleryPhotos[index].imagePath,


                                    aspectRatioPresets: [
                                      CropAspectRatioPreset.square,
                                      // CropAspectRatioPreset.ratio3x2,
                                      // CropAspectRatioPreset.original,
                                      // CropAspectRatioPreset.ratio4x3,
                                      // CropAspectRatioPreset.ratio16x9
                                    ],
                                    androidUiSettings: AndroidUiSettings(

                                        toolbarTitle: 'Adjust Your Brick',
                                        toolbarColor: Get.theme.primaryColor,
                                        cropFrameColor: Get.theme.primaryColor,
                                        toolbarWidgetColor: Colors.white,
                                        cropGridColor: Get.theme.primaryColor,
                                        initAspectRatio: CropAspectRatioPreset.original,
                                        lockAspectRatio: false,
                                        activeControlsWidgetColor: Get.theme.primaryColor,
                                        statusBarColor: Get.theme.primaryColor,
                                    ),
                                    iosUiSettings: IOSUiSettings(
                                      minimumAspectRatio: 1.0,
                                    )
                                );

                                cartController.updateImageCart(index, croppedFile);
                                Get.back();
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ButtonWidget(
                              color: Get.theme.primaryColor,
                              text: 'Remove',
                              textColor: Colors.white,
                              onPressed: () {
                                Get.back();
                                cartController.myGaleryPhotos.removeAt(index);
                                myGaleryController.checkItensCart();
                              }
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ButtonWidget(
                            color: Colors.white,
                            text: 'Go Back',
                            onPressed: ()=> Get.back(),
                            textColor: Get.theme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12,),
              Column(
                children: [
                  InkWell(
                    onTap: cartController.gettingShipValue.value ?
                    null : () {
                      cartController.myGaleryPhotos[index].quantity.value++;
                      var changed = cartController.myGaleryPhotos[index];
                      cartController.myGaleryPhotos[index] = changed;
                      cartController.getSheepValue();

                      },
                    child: ClipOval(



                      child: Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Center(
                              child: Icon(
                                Icons.add_circle,
                                color: Get.theme.primaryColor,
                                size: 40,),),
                        ),




                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

      ))
      ),

    );
  }
}
