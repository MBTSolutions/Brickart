import '../screens/home.dart';
import '../screens/my_gallery_screen.dart';
import '../widgets/drawer_menu.dart';
import 'package:flutter/material.dart';

class PageViewBuild extends StatelessWidget {
  final PageController _pageController;

  PageViewBuild(PageController pageController)
      : _pageController = pageController ??
            PageController(
              initialPage: 0,
              keepPage: true,
            );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: DrawerMenu(),
        bottomNavigationBar: SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.11,
            child: BottomNavigationBar(
              currentIndex: 1,
              backgroundColor: Colors.white,
              onTap: (index) {
                if(index == 2) {
                  return;
                }
                print(index);
                _pageController.animateToPage(index,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.linearToEaseOut);
              },
              items: _bottomNavItems,
            ),
          ),
        ),
        body: SafeArea(
          child: PageView(
            controller: _pageController,
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              HomeScreen(),
              MyGalleryScreen(),
              //CollectionScreen(),
            ],
          ),
        ));
  }

  final _bottomNavItems = <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Image.asset(
        'assets/icons/home1.png',
        height: 40,
        width: 40,
      ),

      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Image.asset(
        'assets/icons/gallery.png',
        height: 40,
        width: 40,
      ),
      label: 'My Gallery',
    ),
    // BottomNavigationBarItem(
    //   icon: Image.asset(
    //     'assets/icons/paint-brush.png',
    //     height: 40,
    //     width: 40,
    //     color: Colors.grey,
    //   ),
    //   label: 'Collections',
    // ),
  ];
}
