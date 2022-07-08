import 'package:brickart_flutter/controller/login_controller.dart';
import 'package:brickart_flutter/widgets/appbar_listtile.dart';
import 'package:brickart_flutter/widgets/text_form_field_basic.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../util/textstyle_constant.dart';
import '../widgets/button_widget.dart';
import '../widgets/drawer_menu.dart';

class RegistrationScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  final LoginController loginController = Get.find();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      //resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: AppbarListTile(
              drawerKey: _drawerKey,
              title: 'Brickart',
              isAR: false,
            ),
          ),
          key: _drawerKey,
          drawer: DrawerMenu(),
          body: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: ListView(
                children: <Widget>[
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 22, top: 32),
                      height: 73,
                      width: 250,
                      child: Image.asset(
                        'assets/logo-brickart.png',
                        fit: BoxFit.fill,
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
                  Container(
                    margin: const EdgeInsets.only(top: 32, bottom: 16),
                    child: Column(
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TextFormFieldBasic(
                          'Full Name',
                          '************',
                          validator: (value) {
                            if (GetUtils.isNullOrBlank(value)) {
                              return 'Field must contains full name';
                            } else {
                              return null;
                            }
                          },
                          enabled: !loginController.isLoading.value,
                          onChanged: (value) {
                            loginController.fullName = value;
                          },
                        ),
                        TextFormFieldBasic(
                          'Email',
                          "aaa@aaa.com.br",
                          validator: (value) {
                            if (!GetUtils.isEmail(value)) {
                              return 'Email not valid';
                            } else {
                              return null;
                            }
                          },
                          enabled: !loginController.isLoading.value,
                          onChanged: (value) {
                            loginController.email = value;
                          },
                        ),
                        TextFormFieldBasic(
                          'Password',
                          '***********',
                          validator: (value) {
                            if (GetUtils.isNullOrBlank(value) ||
                                value.toString().length < 6) {
                              return 'Password should have at least 6 characters';
                            } else {
                              return null;
                            }
                          },
                          enabled: !loginController.isLoading.value,
                          onChanged: (value) {
                            loginController.password = value;
                          },
                          obscureText: true,
                        ),

                      ],
                    ),
                  ),
                  ButtonWidget(
                    textColor: Colors.white,
                    color: Theme.of(context).primaryColor,
                    text: 'REGISTER',
                    onPressed:
                    loginController.isLoading.value ? null : register,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  loginController.isLoading.value
                      ? Center(child: CircularProgressIndicator())
                      : Container()
                ],
              ),
            ),
          ),
        ));
  }

  register() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    loginController.registerUser();
  }
}
