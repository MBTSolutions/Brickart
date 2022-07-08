import 'package:brickart_flutter/screens/main_page_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brickart_flutter/models/user.dart' as UserModel;
class LoginController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;

  User userLog;

  var user = UserModel.User().obs;

  var isLoading = false.obs;
  var isGmailLogin = false.obs;

  String fullName;
  String email;
  String password;

  @override
  void onInit() async {
    FirebaseAuth.instance.authStateChanges().listen((event) async {
      userLog = event;
      if (userLog != null) {
        DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userLog.uid)
            .get();

        user.value = UserModel.User.fromMap(documentSnapshot.data());
      } else {
        user.value = null;
      }
    });
    _checkLogin();
    super.onInit();
  }

  _checkLogin() {
    try {
      userLog = auth.currentUser;
    } catch (e) {
      print(e);
    }
  }

  signInWithEmail() async {
    try {
      isLoading.value = true;
      await auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        userLog = value.user;
      });

      await Future.delayed(Duration(seconds: 4));

      email = '';
      password = '';

      Get.off(PageViewBuild(PageController(
        initialPage: 0,
        keepPage: true,
      )));

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Erro', e.toString(),
          backgroundColor: Get.theme.primaryColor,
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          duration: Duration(seconds: 4));
    }
  }

  registerUser() async {
    isLoading.value = true;

    var result = await auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) async {
      userLog = value.user;

      user.value = UserModel.User();

      user.value.createdAt = DateTime.now();
      user.value.email = userLog.email;
      user.value.name = fullName;
      user.value.profilePicture = 'empty';

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userLog.uid)
          .set(user.value.toMap());
      Get.offAllNamed('/home');
      isLoading.value = false;
      print(value);
    }).catchError((onError) {
      isLoading.value = false;
      Get.snackbar('Erro', onError.toString(),
          backgroundColor: Get.theme.primaryColor,
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          duration: Duration(seconds: 6));
    });

    print(result);
  }

  goToPageIfLogged(String route) {
    if (userLog == null && isGmailLogin == false.obs  ) {
      print("route to the login");

      Get.toNamed('/login');
    }
    else {
      print("route to any");

      Get.offAllNamed(route);
    }
  }
}
