import 'dart:math';

import 'package:brickart_flutter/bloc/register_bloc.dart';
import 'package:brickart_flutter/controller/login_controller.dart';
import 'package:brickart_flutter/screens/registration_screen.dart';
import 'package:brickart_flutter/screens/webview_progress_bar_FAQ.dart';
import 'package:brickart_flutter/widgets/text_form_field_basic.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../util/textstyle_constant.dart';
import '../widgets/appbar_listtile.dart';
import '../widgets/button_widget.dart';
import '../widgets/drawer_menu.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

import 'main_page_view.dart';
import 'package:brickart_flutter/models/user.dart' as UserModel;

final LoginController loginController = Get.find();

bool isSignIn = false;
FirebaseAuth _auth = FirebaseAuth.instance;
User _user;

addStringToSF() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('email', loginController.email);
  print('email stored' + loginController.email);
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  final formKey = GlobalKey<FormState>();
  //final LoginController loginController = Get.find();

  bool _isLoggedIn = false;
  GoogleSignInAccount _userObj;
  GoogleSignIn _googleSignIn = GoogleSignIn();

  var user = UserModel.User().obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static final FacebookLogin facebookSignIn = new FacebookLogin();
  bool isLoggedIn = false;
  Map userObj = {};

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          //resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: AppbarListTile(
              drawerKey: _drawerKey,
              title: '',
              isAR: false,
            ),
          ),
          key: _drawerKey,
          drawer: DrawerMenu(),
          body: SafeArea(
            child: Form(
              key: formKey,
              child: SizedBox.expand(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
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
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/pinkbrckart.png'),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          child: Text(
                            'Uma nova forma de mostrar e celebrar suas lembranças e histórias',
                            textAlign: TextAlign.center,
                            style: kloginRegisterPageSubtitle,
                          ),
                        ),
                      ),
                      AnimatedCrossFade(
                        duration: Duration(milliseconds: 700),
                        firstChild: Column(
                          children: [
                            Container(
                              margin:
                                  const EdgeInsets.only(top: 20, bottom: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  TextFormFieldBasic(
                                    'Email',
                                    'aaa@aaa.com.br',
                                    validator: validateEmail,
                                    onChanged: (value) =>
                                        loginController.email = value,
                                  ),
                                  TextFormFieldBasic(
                                    'Password',
                                    '***********',
                                    validator: validatePassword,
                                    obscureText: true,
                                    onChanged: (value) =>
                                        loginController.password = value,
                                  ),
                                  SizedBox(height: 24),
                                  Center(
                                    child: Text(
                                      'I forgot my password',
                                      style: TextStyle(
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 9,
                                        color: Color(0xffA1A4B1),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 40,
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: ButtonWidget(
                                      text: 'REGISTER',
                                      textColor: Get.theme.primaryColor,
                                      color: Colors.white,
                                      onPressed: () =>
                                          Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => Provider(
                                                  create: (context) =>
                                                      RegisterBloc(),
                                                  child: RegistrationScreen(),
                                                )),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Expanded(
                                    child: ButtonWidget(
                                      text: 'LOGIN',
                                      color: Get.theme.primaryColor,
                                      textColor: Colors.white,
                                      onPressed: () {
                                        FocusScope.of(context).unfocus();
                                        if (formKey.currentState.validate()) {
                                          print(loginController.email);
                                          loginController.signInWithEmail();
                                        }
                                        //authBloc.signInWithEmail().then((value) =>
                                        //Navigator.of(context)
                                        //.pushReplacementNamed('/home'));

                                        // addStringToSF();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'or use your social account to sign in',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xff5B5B5B),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 32),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  _widgetLogin(
                                      'assets/icons/instagram-small.png',
                                      'instagram'),
                                  _widgetLogin('assets/icons/google-small.png',
                                      'google'),
                                  _widgetLogin(
                                      'assets/icons/facebook-small.png',
                                      'facebook')
                                ],
                              ),
                            )
                          ],
                        ),
                        secondChild: Column(
                          children: [
                            SizedBox(
                              height: 130,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Get.theme.primaryColor,
                                  borderRadius: BorderRadius.circular(8)),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                    SizedBox(
                                      width: 12,
                                    ),
                                    Text(
                                      'Logging in...',
                                      style: TextStyle(color: Colors.white),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        crossFadeState: loginController.isLoading.value
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  _widgetLogin(String urlImage, String text) {
    return Column(
      children: <Widget>[
        IconButton(
            iconSize: 40,
            icon: Image.asset(urlImage),
            onPressed: () {
              FirebaseAuth auth = FirebaseAuth.instance;
              print(loginController.isGmailLogin);

              if (text == 'google') {
                //loginController.signInWithGoogle();
                //  if(!showGmailGif){
                //    WebViewScreenFAQ();
                //  }else{
                signInGmail();
              } else if (text == 'facebook') {
                print('facebook tapped');
                _login();
              } else {
                Get.snackbar(
                    'Login com $text', 'Funcionalidade não implmentada',
                    backgroundColor: Get.theme.primaryColor,
                    snackPosition: SnackPosition.BOTTOM,
                    colorText: Colors.white,
                    duration: Duration(seconds: 4));
              }
            }),
        Text(
          text,
          style: px9SnormWnormal,
        ),
      ],
    );
  }

  String validateEmail(String value) {
    if (GetUtils.isNullOrBlank(value)) {
      return 'Digite o email';
    } else if (!GetUtils.isEmail(value)) {
      return 'Email inválido';
    }
    return null;
  }

  String validatePassword(String value) {
    if (GetUtils.isNullOrBlank(value)) {
      return 'Senha não pode estar em branco';
    } else if (value.length < 6) {
      return 'Senha deve conter no mínimo 6 caracteres';
    } else {
      return null;
    }
  }

  Future<Null> _login() async {
    final FacebookLoginResult result = await facebookSignIn.logIn(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        {
          //   final FacebookAccessToken accessToken = result.accessToken;
          //   print('''
          //  Logged in!

          //  Token: ${accessToken.token}
          //  User id: ${accessToken.userId}
          //  Expires: ${accessToken.expires}
          //  Permissions: ${accessToken.permissions}
          //  Declined permissions: ${accessToken.declinedPermissions}
          //  ''');
          print("asasasasassssssssssssssssssssssssssssssssssssss");

          FacebookAuth.instance
              .login(permissions: ["public_profile", "email"]).then((value) {
            FacebookAuth.instance.getUserData().then((userData) {
              setState(() {
                isLoggedIn = true;
                userObj = userData;
                print(userObj);
                isSignIn = true;
                loginController.isGmailLogin = true.obs;
                loginController.userLog = userObj['users'];
                loginController.email = userObj['email'];
                loginController.fullName = userObj['name'];
                print(
                    "checking user id created from firestore:${userObj['id']}");
                Get.off(PageViewBuild(PageController(
                  initialPage: 0,
                  keepPage: true,
                )));
              });
            });
          });
          print("asasasasassssssssssssssssssssssssssssssssssssss");

          //   print("asasassasassssssssssssssssssssssssssssssssssssssssssssssssssssssssnvnvnvnnvnvnvn$credential");
          // var a = await _auth.signInWithCredential(credential);
          // final facebookresult = await FacebookAuth.instance.login();
          // final userData=await FacebookAuth.instance.getUserData();
          // final facebookCred =
          // FacebookAuthProvider.credential(facebookresult.token);
          // var a =
          // await FirebaseAuth.instance.signInWithCredential(facebookCred);
          // setState(() {
          //   isSignIn = true;
          //   loginController.isGmailLogin = true.obs;

          //   loginController.userLog = a.user;
          //   loginController.email = a.user.email;
          //   loginController.fullName = a.user.displayName;
          //   print('success');
          //   print(loginController.email);
          //   print(loginController.fullName);
          //   print("Checking");
          //   Get.off(PageViewBuild(PageController(
          //     initialPage: 0,
          //     keepPage: true,
          //   )));
          // });
          break;
        }
      case FacebookLoginStatus.cancelledByUser:
        print('Login cancelled by the user.');
        break;
      case FacebookLoginStatus.error:
        print('Something went wrong with the login process.\n'
            'Here\'s the error Facebook gave us: ${result.errorMessage}');
        break;
    }
  }

  signInGmail() async {
    // showGmailGif = true;
    // _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) async {
    //   if (account != null) {
    //     // user logged
    //     print('user is logged in gmail');
    //   } else {
    //     // user NOT logged
    //     print('user is not logged in gmail');
    //   }
    // });

    _googleSignIn.signIn().then((userData) {
      /*Important code from which we will use some parts*/

      setState(() async {
        _isLoggedIn = true;
        _userObj = userData;
        print(_userObj.email);
        print(_userObj.displayName);
        loginController.fullName = _userObj.displayName;
        loginController.isGmailLogin = true.obs;
        loginController.email = _userObj.email;
        loginController.userLog = _auth.currentUser;
        _userObj = await _googleSignIn.signIn();
        final GoogleSignInAuthentication googleSignInAuthentication =
            await _userObj.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        final UserCredential authResult =
            await _auth.signInWithCredential(credential);
        final User user = authResult.user;
        assert(!user.isAnonymous);
        assert(await user.getIdToken() != null);
        final User currentUser = _auth.currentUser;
        assert(user.uid == currentUser.uid);
        loginController.userLog = currentUser;
        print('signInWithGoogle succeeded: $user');
        print(loginController.isGmailLogin);
        print(loginController.userLog);
        print('checking uidd response of google:${user.uid}');

        Get.off(PageViewBuild(PageController(
          initialPage: 0,
          keepPage: true,
        )));
      });
    }).catchError((e) {
      print(e);
    });
  }
}
