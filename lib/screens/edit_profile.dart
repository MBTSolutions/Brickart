import 'package:brickart_flutter/bloc/auth_bloc.dart';
import 'package:brickart_flutter/bloc/edit_profile_bloc.dart';
import 'package:brickart_flutter/models/auth_status.dart';
import 'package:brickart_flutter/models/user.dart';
import 'package:brickart_flutter/util/route_guard.dart';
import 'package:brickart_flutter/widgets/text_form_field_basic.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../widgets/appbar_listtile.dart';

import '../util/textstyle_constant.dart';
import '../widgets/button_widget.dart';
import '../widgets/drawer_menu.dart';
import 'package:flutter/material.dart';

class EditProfile extends StatelessWidget {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  Widget profilePicture(String url) {
    print(url);
    if (url == null) {
      return Icon(
        Icons.person,
        size: 80,
        color: Color(0xffB9B7B7),
      );
    } else {
      return Center(
        child: CircleAvatar(
            radius: 60.0,
            backgroundColor: Color(0xffdadada),
            backgroundImage: NetworkImage(
              url,
            )),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final editProfileBloc = Provider.of<EditProfileBloc>(context);

    return StreamBuilder<AuthStatus>(
        stream: Provider.of<AuthBloc>(context).authStatus,
        builder: (context, snapshot) {
          if (snapshot?.data == AuthStatus.signedOut) {
            navigateToLogin(context);
            return Scaffold();
          } else {
            return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                centerTitle: true,
                title: AppbarListTile(
                  drawerKey: _drawerKey,
                  title: 'Edit Profile',
                  isAR: false,
                ),
              ),
              key: _drawerKey,
              drawer: DrawerMenu(),
              body: SafeArea(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: StreamBuilder<User>(
                            stream: editProfileBloc.userProfile,
                            builder: (context, snapshot) {
                              return ListView(
                                children: <Widget>[
                                  Container(
                                    margin: const EdgeInsets.only(
                                        top: 45, bottom: 35),
                                    height: 114,
                                    width: 114,
                                    decoration: BoxDecoration(
                                      color: Color(0xffdadada),
                                      shape: BoxShape.circle,
                                    ),
                                    child: profilePicture(
                                        snapshot.data?.profilePicture),
                                  ),
                                  Text(
                                    'Hello, ${snapshot.data?.name}',
                                    textAlign: TextAlign.center,
                                    style: homeTitle,
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Text(
                                    'How\'s your day so far?',
                                    textAlign: TextAlign.center,
                                    style: homeSubTitle,
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                      top: 20,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        TextFormFieldBasic(
                                          'Full Name',
                                          "**************",
                                          controller: TextEditingController(
                                              text: snapshot.data?.name),
                                          onChanged:
                                              editProfileBloc.fullName.add,
                                          validator: (value) {
                                            return editProfileBloc
                                                    .isFullNameValid.value
                                                ? null
                                                : 'Field must contains full name';
                                          },
                                        ),
                                        TextFormFieldBasic(
                                          'Email',
                                          'aaa@aaa.com.br',
                                          colorText: Colors.grey,
                                          readOnly: true,
                                          controller: TextEditingController(
                                              text: snapshot.data?.email),
                                        ),
                                        TextFormFieldBasic(
                                          'Mobile Phone',
                                          '(11) 99000-0000',
                                          typeText: TextInputType.phone,
                                          onChanged: editProfileBloc.mobile.add,
                                          validator: (value) {
                                            return editProfileBloc
                                                    .isMobileValid.value
                                                ? null
                                                : 'Mobile phone not valid';
                                          },
                                          controller: TextEditingController(
                                              text: snapshot.data?.mobilePhone),
                                        ),
                                        TextFormFieldBasic(
                                          'Change Password',
                                          '***********',
                                          onChanged:
                                              editProfileBloc.password.add,
                                          validator: (value) {
                                            return editProfileBloc
                                                    .isPasswordValid.value
                                                ? null
                                                : 'Password should have at least 6 characters';
                                          },
                                          obscureText: true,
                                        ),
                                        TextFormFieldBasic(
                                          'Confirm Password Change',
                                          '***********',
                                          obscureText: true,
                                          onChanged: editProfileBloc
                                              .passwordConfirmation.add,
                                          validator: (value) {
                                            return editProfileBloc
                                                    .isPasswordConfirmationValid
                                                    .value
                                                ? null
                                                : 'Confirmation should match password field';
                                          },
                                        ),
                                        SizedBox(
                                          height: 66,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 29, right: 30, bottom: 27),
                      child: ButtonWidget(
                          color: Get.theme.primaryColor,
                          textColor: Colors.white,
                          text: 'Confirm Changes'.toUpperCase(),
                          onPressed: () {
                            if (editProfileBloc.isFormValid.value) {
                              editProfileBloc
                                  .updateProfile()
                                  .then(
                                      (value) => print('Updated with success'))
                                  .catchError((error) => print(error));
                            } else {
                              print('Invalid form');
                            }
                          }),
                    ),
                  ],
                ),
              ),
            );
          }
        });
  }
}
