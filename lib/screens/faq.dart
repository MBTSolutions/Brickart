import 'package:brickart_flutter/util/textstyle_constant.dart';
import 'package:get/get.dart';

import '../widgets/appbar_listtile.dart';

import '../widgets/button_widget.dart';
import '../widgets/drawer_menu.dart';
import 'package:flutter/material.dart';

class FAQScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: AppbarListTile(
          drawerKey: _drawerKey,
          title: 'FAQ',
          isAR: false,
        ),
      ),
      key: _drawerKey,
      drawer: DrawerMenu(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
          child: ListView(
            children: <Widget>[
              Container(
                height: 108,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      'Need Help?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontStyle: FontStyle.normal,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ButtonWidget(
                        textColor: Colors.white,
                        color: Theme.of(context).primaryColor,
                        text: 'ONLINE CHAT',
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                  children: <Widget>[
                    Text(
                      'Frequently Asked Questions',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontStyle: FontStyle.normal,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      'Veja algumas das principais perguntas abaixo',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        color: Color(0xff5B5B5B),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    _accordion(title: 'O que são os bricks?',
                      content:
                      'Todos os bricks são produzidos com um material plástico super leve e resistente.',),
                    _accordion(title: 'Existem tamanhos diferentes?',),
                    _accordion(title: 'Que adesivo é esse?',),
                    _accordion(title: 'O que são os bricks?',
                      content:
                      'Todos os bricks são produzidos com um material plástico super leve e resistente.',),
                    _accordion(title: 'Existem tamanhos diferentes?',),
                    _accordion(title: 'Que adesivo é esse?',),_accordion(title: 'O que são os bricks?',
                      content:
                      'Todos os bricks são produzidos com um material plástico super leve e resistente.',),
                    _accordion(title: 'Existem tamanhos diferentes?',),
                    _accordion(title: 'Que adesivo é esse?',),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _accordion({String title = 'title', String content = 'content'}){
    return Container();
    //GFAccordion(
    //       margin: const EdgeInsets.only(
    //           top: 0, bottom: 8, left: 0, right: 0),
    //       contentPadding: const EdgeInsets.only(
    //           left: 10, right: 10, top: 5, bottom: 5),
    //       titlePadding: const EdgeInsets.only(
    //           top: 0, bottom: 8, left: 16, right: 10),
    //       title: title,
    //       textStyle: faqTitle,
    //       content: content,
    //       collapsedTitlebackgroundColor: Color(0xffFAFAFC),
    //       expandedTitlebackgroundColor: Color(0xffFAFAFC),
    //       collapsedIcon: Icon(
    //         Icons.expand_more,
    //         color: Get.theme.primaryColor,
    //         size: 20,
    //       ),
    //       expandedIcon: Icon(
    //         Icons.expand_less,
    //         color: Get.theme.primaryColor,
    //         size: 20,
    //       ),
    //     )
  }
}
