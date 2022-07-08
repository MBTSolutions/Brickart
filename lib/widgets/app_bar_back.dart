import 'package:brickart_flutter/util/textstyle_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppBarBack extends PreferredSize {

  @override
  Size get preferredSize => Size.fromHeight(100); // set height of your choice

  final String title;
  AppBarBack({this.title = 'App Bar Back'});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      child: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Get.theme.primaryColor,),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: Text(
          title,
          style: kAppBarTitleTextStyle,
        ),
      ),
    );
  }
}
