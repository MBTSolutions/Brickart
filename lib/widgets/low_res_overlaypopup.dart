 import 'package:brickart_flutter/controller/my_galery_controller.dart';
import 'package:brickart_flutter/models/photos_my_galery.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'button_widget.dart';

class LowResolutionPopup extends StatelessWidget {

  final int index;
  final PhotosMyGalery photo;
  LowResolutionPopup(this.index, this.photo);

//  LowResolutionPopup({
//    Key key,
//  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Stack(
          children: <Widget>[
            Container(
              width: 252,
              height: 353,
              color: Colors.white,
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 42,
                        ),
                        Image.asset(
                          'assets/icons/warning.png',
                          height: 80,
                          width: 80,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 40,
                          child: Center(
                            child: Column(
                              children: <Widget>[
                                Text(
                                  'Warning!',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Low resolution',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'We\'ve detected this image as having low resolution. Thus, printing this picture might make your brick show some bluriness.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                  fontFamily: 'Montserrat',
                                  color: Color(0xff4B4B4B),
                                ),
                              ),
                              Text(
                                '\nDo you want to continue?',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                  fontFamily: 'Montserrat',
                                  color: Color(0xff4B4B4B),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ButtonWidget(
                          textColor: Theme.of(context).primaryColor,
                          color: Colors.white,
                          text: 'CANCEL',
                          onPressed: () => Get.back(),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ButtonWidget(
                          textColor: Colors.white,
                          color: Theme.of(context).primaryColor,
                          text: 'SELECIONAR FOTO',
                          onPressed: (){
                            Get.back();
                            MyGaleryController controller = Get.find();
                            controller.selectPhoto(index, photo);

                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
                top: -10,
                right: -10,
                child: IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    })),
          ],
        ),
      ),
    );
  }
}
