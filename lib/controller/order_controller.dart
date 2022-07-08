import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:brickart_flutter/controller/cart_controller.dart';
import 'package:brickart_flutter/controller/login_controller.dart';
import 'package:brickart_flutter/models/order/order.dart';
import 'package:brickart_flutter/models/order/order_itens.dart';
import 'package:brickart_flutter/models/photos_my_galery.dart';
import 'package:brickart_flutter/util/alerts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

class OrderController extends GetxController {
  CartController cartController = Get.find();
  LoginController loginController = Get.find();

  var isLoading = false.obs;
  var completingOrder = false.obs;
  var order = Order().obs;
  String orderId;
  List<OrderItens> listImagesOrder;
  var myOrdersList = [].obs;

  @override
  void onInit() async {
    order.value = null;
    completingOrder.value = true;
    int max = 9999999;
    orderId = new Random().nextInt(max).toString();
    await _uploadFilesOrder();
    completingOrder.value = false;
    super.onInit();
  }

  _saveOrder() async {
    try {
      order.value = Order();
      order.value.addPrice = cartController.product.value.additionalPrice;
      order.value.addQuantity = cartController.quantity.value -
          cartController.product.value.mimimunOrderQuantity;
      order.value.date = DateTime.now();
      order.value.discount = cartController.promoCode.value.promoValue;
      order.value.fullAmout = cartController.total;
      order.value.minPrice = cartController.product.value.price;
      order.value.minQuantity =
          cartController.product.value.mimimunOrderQuantity;
      order.value.orderId = orderId;
      order.value.itens = listImagesOrder;
      order.value.quantity = cartController.quantity.value;

      return FirebaseFirestore.instance
          .collection('users')
          .doc(loginController.userLog.uid)
          .collection('orders')
          .doc()
          .set(order.value.toMap());
    } catch (e) {
      alertSnack('Erro', 'Não foi possível salvar o pedido');
    }
  }

  Future<bool> _uploadFilesOrder() async {
    try {
      listImagesOrder = [];

      await Future.forEach(cartController.myGaleryPhotos, (element) async {
        PhotosMyGalery photos = element;

        String url = await _uploadImage(
            photos.imageChanged != null ? photos.imageChanged : photos.image,
            photos.id);

        OrderItens orderItens = OrderItens();
        orderItens.url = url;
        orderItens.quantity = photos.quantity.value;
        orderItens.lowQuality = photos.lowQuality.value;

        listImagesOrder.add(orderItens);
      });

      await _saveOrder();
      return true;
    } catch (e) {
      alertSnack('Erro', 'Não foi possível armazenar os arquivos');
      return false;
    }
  }

  Future<String> _uploadImage(Uint8List image, String imgId) async {
    try {
      var storageReference = FirebaseStorage.instance.ref()
          .child('orders')
          .child(loginController.userLog.uid)
          .child(orderId)
          .child(imgId);

      var uploadTask = storageReference.putData(image);

      var dowurl = await (await uploadTask).ref.getDownloadURL();
      return dowurl.toString();
    } catch (e) {
      alertSnack('Erro', 'Erro ao armazenar os arquivos');
      return null;
    }
  }

  getMyOrders() async {
    try {
      FirebaseFirestore.instance
          .collection('users')
          .doc(loginController.userLog.uid)
          .collection('orders')
          .snapshots()
          .listen((event) {
        List list = event.docs;
        myOrdersList.value = [];

        list.forEach((element) {
          QueryDocumentSnapshot queryDocumentSnapshot = element;

          Order order = Order.fromMap(queryDocumentSnapshot.data());
          myOrdersList.add(order);

          print(element);
        });
        print(event);
      });
    } catch (e) {
      alertSnack('Erro', 'Erro ao pesquisar os pedidos');
    }
  }
}
