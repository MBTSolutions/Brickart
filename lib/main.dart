import 'package:brickart_flutter/bloc/auth_bloc.dart';
import 'package:brickart_flutter/bloc/drawer_bloc.dart';
import 'package:brickart_flutter/bloc/edit_profile_bloc.dart';
import 'package:brickart_flutter/controller/cart_controller.dart';
import 'package:brickart_flutter/controller/login_controller.dart';
import 'package:brickart_flutter/screens/edit_profile.dart';
import 'package:brickart_flutter/screens/faq.dart';
import 'package:brickart_flutter/screens/main_page_view.dart';
import 'package:brickart_flutter/screens/order_confirmed_screen.dart';
import 'package:brickart_flutter/screens/registration_screen.dart';
import 'package:brickart_flutter/screens/shopping_cart.dart';
import 'package:brickart_flutter/screens/your_order_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );

  runApp(MultiProvider(
    providers: [
      Provider(create: (context) => AuthBloc()),
      Provider(create: (context) => DrawerBloc())
    ],
    child: App(),
  ));
}

class App extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Container(
            color: Colors.white,
            child: Center(
              child: Text(
                  'Sorry, something went wrong. Please, contact support for more information.'),
            ),
          );
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {

          Get.put(LoginController());
          Get.put(CartController());

          return MyApp();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Container(
          color: Colors.white,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primaryColor: Color(0xFFFA008D),
        scaffoldBackgroundColor: Color(0xffffffff),
        appBarTheme: Theme.of(context).appBarTheme.copyWith(
              elevation: 10,
              color: Color(0xffffffff),
              brightness: Brightness.light,
            ),
        textTheme: Theme.of(context).textTheme.apply(
              fontFamily: 'Poppins',
            ),
      ),
      getPages: [
        GetPage(name: '/login', page: () => LoginScreen()),
        GetPage(name: '/register', page: () => RegistrationScreen()),
        GetPage(name: '/edit_profile', page: () => EditProfile()),
        GetPage(name: '/home', page: () => PageViewBuild(PageController(
          initialPage: 0,
          keepPage: true,
        ))),
        GetPage(name: '/my_galery', page: () => PageViewBuild(PageController(
          initialPage: 1,
          keepPage: true,
        ))),
        GetPage(name: '/collections', page: () => PageViewBuild(PageController(
          initialPage: 2,
          keepPage: true,
        ))),
        GetPage(name: '/cart', page: () => ShoppingCartScreen()),
        GetPage(name: '/faq', page: () => FAQScreen()),
        GetPage(name: '/orders', page: () => YourOrderScreen()),
        GetPage(name: '/confirme_order', page: () => OrderConfirmedScreen())
      ],
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegistrationScreen(),
        '/edit_profile': (context) => Provider(
              create: (context) => EditProfileBloc(),
              child: EditProfile(),
            ),
        '/home': (context) => PageViewBuild(PageController(
              initialPage: 0,
              keepPage: true,
            )),
        '/my_gallery': (context) => PageViewBuild(PageController(
              initialPage: 1,
              keepPage: true,
            )),
        '/collections': (context) => PageViewBuild(PageController(
              initialPage: 2,
              keepPage: true,
            )),
        '/cart': (context) => ShoppingCartScreen(),
        '/faq': (context) => FAQScreen(),
        '/orders': (context) => YourOrderScreen(),
      },

      //initialRoute: '/login',
      home: PageViewBuild(PageController(
        initialPage: 0,
        keepPage: true,
      )),
    );
  }
}
