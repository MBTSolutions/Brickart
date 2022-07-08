import 'package:brickart_flutter/controller/login_controller.dart';
import 'package:brickart_flutter/controller/my_galery_controller.dart';
import 'package:brickart_flutter/models/photos_my_galery.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';

import 'package:flutter/material.dart';

import 'low_res_overlaypopup.dart';

class AllPhotosView extends StatelessWidget {
   final loginController = Get.find<LoginController>();

  final MyGaleryController myGaleryController = Get.put(MyGaleryController());
  AllPhotosView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    myGaleryController.onInit();

    return SafeArea(
      child: FutureBuilder(
        future: PhotoManager.requestPermission(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot?.data == true) {
              myGaleryController.page = 0;
              myGaleryController.getAllPhotos(20);
              return Obx(() =>
              myGaleryController.getingPhotos.value &&
                  myGaleryController.page <= 0  ?
              Center(
                child: CircularProgressIndicator(),) :
              myGaleryController.allPhotos.length <= 0 ?
              Center(
                child: Text('no photo found'),) :
              Column(
                children: [
                  Expanded(child: _GridView()),
                  myGaleryController.getingPhotos.value ?
                      Container(
                        child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      ),
                      ) :
                  Container(
              )
                  ,

                ],
              )


              );
            } else {
              return Container(
                child: Center(
                  child: Text('You have no access to photos'),
                ),
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class _GridView extends StatelessWidget {
  final ScrollController _scrollController = new ScrollController();
  final MyGaleryController myGaleryController = Get.find();
  @override
  Widget build(BuildContext context) {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        myGaleryController.page++;
        myGaleryController.getAllPhotos(20);
      }
    });

    return GridView.builder(
      controller: _scrollController,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 5,
        crossAxisSpacing: 5,
      ),

      itemBuilder: (context, index) {

        PhotosMyGalery photo = myGaleryController.allPhotos[index];

        return GestureDetector(
        onLongPress: () {
        },
        onTap: () {

          if(photo.lowQuality.value && !photo.isSelected.value){
            showGeneralDialog(
              context: Get.context,
              barrierDismissible: true,
              barrierLabel: MaterialLocalizations.of(context)
                  .modalBarrierDismissLabel,
              barrierColor: Colors.black45,
              transitionDuration: const Duration(milliseconds: 200),
              pageBuilder: (BuildContext buildContext, Animation animation,
                  Animation secondaryAnimation) {
                return LowResolutionPopup(index, photo);
              },
            );
            return;
          }
          myGaleryController.selectPhoto(index, photo);
        },
        child: Obx(() =>
        photo.image == null ?
        Container() :
        photo.lowQuality.value &&
            !photo.isSelected.value
            ?
        Container(
          width: 200,
          height: 200,
          color: Colors.grey,
          child: Opacity(
            opacity: 0.3,
            child: Image.memory(
              photo.image,
              fit: BoxFit.cover,
            ),
          ),
        ):
        photo.isSelected.value ?
        Container(
          width: 200,
          height: 200,
          color: Get.theme.primaryColor,
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Opacity(
              opacity: 0.8,
              child: Stack(
                children: [
                  Positioned(
                    child: Container(
                      width: 200,
                      height: 200,
                      child: Image.memory(
                        myGaleryController.allPhotos[index].image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 5,
                    right: 5,
                    child: ClipOval(
                      child: Container(
                        color: Get.theme.primaryColor,
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ) : 
        Image.memory(
          photo.image,
          fit: BoxFit.cover,
        )),
      );},
      itemCount: myGaleryController.allPhotos.length,
    );
  }
}

/*Container(
              child: FutureBuilder(
                future: myGaleryController.allPhotos[index].entity
                    .thumbDataWithSize(200, 200),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return index == 2
                        ? Container(
                            width: 200,
                            height: 200,
                            color: Colors.grey,
                            child: Opacity(
                              opacity: 0.5,
                              child: Image.memory(
                                snapshot.data,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : myGaleryController.allPhotos[index].isSelected.value
                            ? Container(
                                width: 200,
                                height: 200,
                                color: Get.theme.primaryColor,
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Opacity(
                                    opacity: 0.8,
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Image.memory(
                                                  snapshot.data,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 5,
                                          right: 5,
                                          child: ClipOval(
                                            child: Container(
                                              color: Get.theme.primaryColor,
                                              child: Icon(
                                                Icons.check,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : Image.memory(
                                snapshot.data,
                                fit: BoxFit.cover,
                              );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            )*/

/*FutureBuilder(
            future: myGaleryController.allPhotos[index].thumbDataWithSize(200, 200),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return myGaleryController.isSelected(index) ?
                Container(
                    width: 200,
                    height: 200,
                    color: Colors.pink,
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Opacity(
                        opacity: 0.7,
                        child: Stack(
                          children: [
                            Positioned(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Image.memory(
                                      snapshot.data,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              bottom: 5,
                              right: 5,
                              child: ClipOval(
                                  child: Container(
                                      color: Get.theme.primaryColor,
                                      child: Icon(
                                        Icons.check,
                                        color: Colors.white,
                                      ))),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ) : Image.memory(
                    snapshot.data,
                    fit: BoxFit.cover,
                  );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          )*/

// index % 2 == 0
//               ? showGeneralDialog(
//                   context: context,
//                   barrierDismissible: true,
//                   barrierLabel: MaterialLocalizations.of(context)
//                       .modalBarrierDismissLabel,
//                   barrierColor: Colors.black45,
//                   transitionDuration: const Duration(milliseconds: 200),
//                   pageBuilder: (BuildContext buildContext, Animation animation,
//                       Animation secondaryAnimation) {
//                     return LowResolutionPopup();
//                   },
//                 )
//               : showGeneralDialog(
//                   context: context,
//                   barrierDismissible: true,
//                   barrierLabel: MaterialLocalizations.of(context)
//                       .modalBarrierDismissLabel,
//                   barrierColor: Colors.black45,
//                   transitionDuration: const Duration(milliseconds: 200),
//                   pageBuilder: (BuildContext buildContext, Animation animation,
//                       Animation secondaryAnimation) {
//                     return PopupDialog();
//                   },
//                 );
