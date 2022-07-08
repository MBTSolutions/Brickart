import 'package:brickart_flutter/controller/login_controller.dart';
import 'package:brickart_flutter/util/route_guard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screens/shopping_cart.dart';
import '../util/textstyle_constant.dart';
import '../widgets/appbar_listtile.dart';
import '../widgets/arena.dart';
import '../widgets/bottom_cart_widget.dart';
import '../widgets/drawer_menu.dart';
import '../widgets/most_ordered.dart';

class CollectionScreen extends StatefulWidget {
  @override
  _CollectionScreenState createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  LoginController loginController = Get.find();
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  int selectedCategory = 0;
  PageController _pageController;
  final List<String> galleryCategory = [
    'Most Ordered',
    'Torcida',
    'Arena',
    'Frases do Timão'
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
                title: AppbarListTile(
                  drawerKey: _drawerKey,
                  title: 'Collections',
                  isAR: true,
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
                              onTap: () => setState(() {
                                selectedCategory = index;
                                _pageController.jumpToPage(selectedCategory);
                              }),
                              child: Container(
                                width: 100,
                                height: 48,
                                color: Colors.white,
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
                                        borderRadius:
                                            BorderRadius.all(Radius.circular(20)),
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
                              ///switch between page also change the bottom bar of category
                              selectedCategory = page;
                            });
                          },
                          children: <Widget>[
                            MostOrdered(),
                            ArenaView(),
                            MostOrdered(),
                            ArenaView(),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Get.to(ShoppingCartScreen()),
                        child: BottomCartWidget(),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        }
        );
  }
}
