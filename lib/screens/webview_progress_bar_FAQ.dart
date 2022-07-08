import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../widgets/appbar_listtile.dart';
import '../widgets/drawer_menu.dart';
import 'package:webview_flutter/webview_flutter.dart';


class WebViewScreenFAQ extends StatefulWidget {
  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreenFAQ> {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  final formKey = GlobalKey<FormState>();

  bool isLoading=true;

  @override
  Widget build(BuildContext context) {

      return  Scaffold(
          //resizeToAvoidBottomPadding: false,
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
          body:   /*last thought to handle this, create a new screen, a new widget and new class and it should work*/
          ModalProgressHUD(
            inAsyncCall: isLoading,
            progressIndicator: Image.asset("assets/images/loadprogress.gif"),
            child: WebView(
              initialUrl: 'https://brickart.com.br/mobile_app/FAQ/',
              javascriptMode: JavascriptMode.unrestricted,
              onPageFinished: (finish) {
                setState(() {
                  print('webview finished dsdsds');
                  isLoading = false;
                });
              },
            ),));


  }
  }