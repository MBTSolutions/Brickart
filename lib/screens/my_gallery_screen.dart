import 'package:brickart_flutter/controller/login_controller.dart';
import 'package:brickart_flutter/util/route_guard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:get/get.dart';

import '../util/textstyle_constant.dart';
import '../widgets/all_photos.dart';

import '../widgets/bottom_cart_widget.dart';
import '../widgets/drawer_menu.dart';

class MyGalleryScreen extends StatefulWidget {
  @override
  _MyGalleryScreenState createState() => _MyGalleryScreenState();
}

class _MyGalleryScreenState extends State<MyGalleryScreen> {
  LoginController loginController = Get.find();
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  int selectedCategory = 0;
  PageController _pageController;
  final List<String> galleryCategory = [
    'All photos',

  ];

  @override
  void initState() {
    _pageController = PageController(initialPage: 0, keepPage: true);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: loginController,
        builder: (LoginController loginController) {
          if (loginController.userLog == null) {
            navigateToLogin(context);
            return Scaffold();
          } else {
            return Scaffold(
              backgroundColor: Color(0xfff5f5f5),
              appBar: AppBar(
                automaticallyImplyLeading: false,
                centerTitle: true,
                // title: AppbarListTile(
                //   drawerKey: _drawerKey,
                //   title: 'My Gallery',
                //   isAR: true,
                // ),
                title: SafeArea(
                  // child: ListTile(
                  //   leading: GestureDetector(
                  //     onTap: () {
                  //       _drawerKey.currentState.openDrawer();
                  //     },
                  //     child: Container(
                  //       margin: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.02),
                  //       child: Image.asset('assets/icons/hamburger.png'),
                  //       // height: 40,
                  //       // width: 40,
                  //     ),
                  //   ),
                  //   title: Container(
                  //     margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.09),
                  //
                  //     child:Center(
                  //     child: Text(
                  //       'Brickart',
                  //       style: kAppBarTitleTextStyle,
                  //     ),
                  //   ),
                  //   ),
                  //   trailing: GestureDetector(
                  //     // onTap: () {
                  //     //   Navigator.of(context)
                  //     //       .push(MaterialPageRoute(builder: (context) => FAQScreen()));
                  //     // },
                  //     child: Opacity(
                  //         opacity: 1,
                  //         child: GestureDetector(
                  //           child:Container(
                  //             // width: 100,
                  //             // height: 45,
                  //             child:MaterialButton(
                  //             child: Image.asset('assets/icons/chat.png'),
                  //             onPressed: () {
                  //
                  //               FlutterOpenWhatsapp.sendSingleMessage("+5511992156335", "Hello I want to enter my order...");
                  //               print("Container was tapped");
                  //
                  //               //    child: Text('Running on: $_platformVersion\n'),
                  //
                  //
                  //             },
                  //
                  //
                  //           ),),
                  //         )
                  //     ),
                  //  ),
                  // ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        GestureDetector(
                          onTap: () {
                            _drawerKey.currentState.openDrawer();
                          },
                          child: Container(
                            child: Image.asset('assets/icons/hamburger.png'),

                          ),
                        ),
                        Center(child:Container(

                          child: Text(
                            'My Gallery',
                            style: kAppBarTitleTextStyle,
                          ),

                        ),),

                        GestureDetector(

                          child: Opacity(
                              opacity: 1,
                              child: GestureDetector(
                                onTap: () {

                                  FlutterOpenWhatsapp.sendSingleMessage("+5511992156335", "Hello I want to enter my order...");
                                  print("Container was tapped");

                                },
                                child:Container(


                                  child: Image.asset('assets/icons/chat.png'),



                                ),
                              )
                          ),
                        ),



                      ],

                    )
                ),
              ),
              key: _drawerKey,
              drawer: DrawerMenu(),
              body: SafeArea(
                child: SizedBox.expand(
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey[400], offset: Offset(1, 1)),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: galleryCategory.length,
                            itemBuilder: (context, index) => GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedCategory = index;
                                  _pageController.jumpToPage(selectedCategory);
                                });
                              },
                              child: Container(
                                height: 48,
                                color: Colors.white,
                                width: 100,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(
                                      height: 1,
                                    ),
                                    Text(
                                      galleryCategory[index],
                                      style: categoryStyle,
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Container(
                                      height: 2,
                                      width: 60,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                        color: index == selectedCategory
                                            ? Theme.of(context).primaryColor
                                            : Colors.transparent,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: PageView(
                          controller: _pageController,
                          onPageChanged: (page) {
                            setState(() {
                              selectedCategory = page;
                            });
                          },
                          children: <Widget>[
                            AllPhotosView(),
                            // Container(
                            //   child: Center(
                            //     child: Text('Favorites'),
                            //   ),
                            // ),
                            // SocialView(
                            //   iconAsset:
                            //       'assets/icons/instagram-monocromatic.png',
                            //   text:
                            //       'Conect your Instagram account and give life to your best pictures!',
                            //   buttonIcon: 'assets/icons/instagram-white.png',
                            //   buttonText: 'Connect to Instagram',
                            //   buttonColor: Theme.of(context).primaryColor,
                            // ),
                            // SocialView(
                            //   iconAsset:
                            //       'assets/icons/facebook-monocromatic.png',
                            //   text:
                            //       'Conect your Facebook account and give life to your best pictures!',
                            //   buttonIcon: 'assets/icons/facebook-white.png',
                            //   buttonText: 'Connect to Facebook',
                            //   buttonColor: Color(0xff3A5A98),
                            // ),
                          ],
                        ),
                      ),
                      BottomCartWidget(),
                    ],
                  ),
                ),
              ),
            );
          }
        });
  }
}
