import 'package:brickart_flutter/controller/cart_controller.dart';
import 'package:brickart_flutter/controller/login_controller.dart';

import 'package:brickart_flutter/screens/webview_progress_bar_FAQ.dart';
import 'package:brickart_flutter/screens/webview_progress_bar_T&C.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:flutter_facebook_login/flutter_facebook_login.dart';

import '../util/textstyle_constant.dart';


class DrawerMenu extends StatefulWidget {
  @override
  DrawerMenuStateful createState() =>   DrawerMenuStateful();
}



class   DrawerMenuStateful extends State<DrawerMenu> {
  final LoginController loginController = Get.find();
  final _key = UniqueKey();
  static final FacebookLogin facebookSignIn = new FacebookLogin();

  GoogleSignInAccount _userObj;
  GoogleSignIn _googleSignIn = GoogleSignIn();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  void initState(){
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    //final authBloc = Provider.of<AuthBloc>(context);
    //final drawerBloc = Provider.of<DrawerBloc>(context);

    return SafeArea(
      child: Container(
        padding:
            const EdgeInsets.only(left: 32, top: 64, bottom: 32, right: 32),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width * 0.75,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            colors: [
              Color(0xFFFA008D),
              Color(0xFFFA008D),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  Center(
                    child: Container(
                    //   child: Image.asset(
                    //     'assets/brickart_white.png',
                    //     color: Colors.white,
                    //   ),
                    //   height: 300,
                    //   width: 128,
                    //
                    //
                    //
                    //
                    //
                    // ),
                      width:  150,
                      height: 150,
                      decoration: BoxDecoration(
                        image:  DecorationImage(
                          image: AssetImage('assets/brickart_white.png'),
                          fit: BoxFit.fill,
                        ),
                      ),
                  ),),
                  SizedBox(
                    height: 42,
                  ),
                  // StreamBuilder<User>(
                  //     stream: drawerBloc.userProfile,
                  //     builder: (context, snapshot) {
                  //       var welcomeMessage = 'Welcome';
                  //       if (snapshot.data?.name != null) {
                  //         welcomeMessage = 'Welcome, ${snapshot.data?.name}';
                  //       }
                  //       return Text(
                  //         welcomeMessage,
                  //         style: drawerMenuTextStyle,
                  //       );
                  //     }),
                  _itemDrawer(
                        () => loginController.goToPageIfLogged('/edit_profile'),
                    '${loginController.userLog == null && loginController.isGmailLogin == false.obs ? 'Login' : 'Welcome, ${
                        loginController.isGmailLogin == true.obs ? loginController.fullName : loginController.user.value.name

                    }'}',
                  ),
                  _itemDrawer(
                    () => loginController.goToPageIfLogged('/edit_profile'),
                    'Edit profile',
                    style: kTextFieldHintText,
                  ),
                  SizedBox(height: 16),
                  _itemDrawer(null, 'Customer Service', news: '1'),
                  SizedBox(height: 16),
                  _itemDrawer(()=> Get.to( () => WebViewScreenFAQ()
                  ),
                    'Frequently Asked Questions',

                  ),


                  SizedBox(height: 16),
                  _itemDrawer(() => Get.offNamed('/orders'), 'Your Orders'),
                  SizedBox(height: 16),
                  _itemDrawer(() =>  Get.to( () =>

                  WebViewTermsConditions()), 'Terms & Conditions',),
                  // isLoading ? Center( child: CircularProgressIndicator(),)
                  //     : Stack(),
                  SizedBox(height: 16),
                  Divider(
                    color: Colors.white,
                    thickness: 3,
                    endIndent: 100,
                  ),
                  SizedBox(height: 16),
                  _itemDrawer(() => Get.offAllNamed('/home'), 'Home'),
                  SizedBox(height: 16),
                  _itemDrawer(() {
                    loginController.goToPageIfLogged('/my_galery');
                  }, ''),
                  // SizedBox(height: 16),
                  // _itemDrawer(null,
                  //     //() => loginController.goToPageIfLogged('/collections'),
                  //     'Collections'),
                  // SizedBox(height: 16),
                  // _itemDrawer(null, 'Augmented Reality'),
                  SizedBox(height: 16),
                  _itemDrawer(() {
                    CartController cartController = Get.find();
                    if(loginController.userLog != null && cartController.quantity < 3){
                      Get.snackbar('Atention',
                          'you must select at least 3 images',
                        backgroundColor: Get.theme.primaryColor,
                        snackPosition: SnackPosition.BOTTOM
                      );
                    }
                    else {
                      loginController.goToPageIfLogged('/cart');
                    }
                    },
                      'Shopping Cart'),
                  SizedBox(height: 16),
                  loginController.userLog == null && loginController.isGmailLogin == false.obs
                      ? Container()
                      : _itemDrawer(() async {
                    loginController.isGmailLogin = false.obs;

                    await loginController.auth.signOut();
                    await _googleSignIn.signOut().then((userData){
                      loginController.userLog = null;
                    });
                    await facebookSignIn.logOut();

                    Get.offNamed('/home');
                        }, 'Logout')
                ],
              ),
            ),
            Text(
              '@2019 Torus Comércio\nCNPJ 28.737.205/0001-73',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w600,
                fontFamily: 'Montserrat',
              ),
            ),
          ],
        ),
      ),
    );
  }

  _itemDrawer(Function onTap, String text,
      {String news, TextStyle style = drawerMenuTextStyle}) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            text,
            style: onTap != null ? style : drawerMenuTexDisabledtStyle,
          ),
          news != null
              ? Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.25),
                        offset: Offset(1, 1),
                      )
                    ],
                  ),
                  child: Center(
                    child: Text(
                      news,
                      style: TextStyle(
                        color: Get.theme.primaryColor,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
