
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';

import '../util/textstyle_constant.dart';
import 'package:flutter/material.dart';

class AppbarListTile extends StatelessWidget {
  const AppbarListTile({
    Key key,
    @required this.title,
    @required GlobalKey<ScaffoldState> drawerKey,
    @required this.isAR,
  })  : _drawerKey = drawerKey,
        super(key: key);

  final GlobalKey<ScaffoldState> _drawerKey;
  final String title;
  final bool isAR;
  @override
  Widget build(BuildContext context) {
    return Row(
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

        Container(
            child:Text(
             this.title,
             style: kAppBarTitleTextStyle,)),

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
      // leading: GestureDetector(
      //   onTap: () {
      //     _drawerKey.currentState.openDrawer();
      //   },
      //   child: Container(
      //     child: Image.asset('assets/icons/hamburger.png'),
      //     height: 40,
      //     width: 40,
      //   ),
      // ),
     // Center(
     //    child: Text(
     //      title,
     //      style: kAppBarTitleTextStyle,
     //    ),
     //  // ),
     //  trailing:  Opacity(
     //    opacity: 1,
     //    child: GestureDetector(
     //      onTap: () {
     //        // if (!isAR)
     //        //   Get.to(FAQScreen());
     //      },
     //      child: isAR
     //          ?
     //      MaterialButton(
     //        child: Image.asset('assets/icons/chat.png'),
     //        // height: 45,
     //        // minWidth: 45,
     //
     //        onPressed: () {
     //          print("Container was tapped");
     //
     //
     //          FlutterOpenWhatsapp.sendSingleMessage("+55 11 91050-0594", "Hello");
     //          //    child: Text('Running on: $_platformVersion\n'),
     //
     //
     //        },
     //      )
     //
     //          :  MaterialButton(
     //        child: Image.asset('assets/icons/chat.png'),
     //        onPressed: () {
     //          print("Container was tapped");
     //
     //          FlutterOpenWhatsapp.sendSingleMessage("+55 11 91050-0594", "Hello");
     //
     //          //    child: Text('Running on: $_platformVersion\n'),
     //
     //
     //        },
     //      ),
     //
     //    ),

          // child: Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //
          //     GestureDetector(
          //       onTap: () {
          //         _drawerKey.currentState.openDrawer();
          //       },
          //       child: Container(
          //         child: Image.asset('assets/icons/hamburger.png'),
          //
          //       ),
          //     ),
          //     Center(child:Container(
          //
          //       child: Text(
          //         'My Gallery',
          //         style: kAppBarTitleTextStyle,
          //       ),
          //
          //     ),),
          //
          //     GestureDetector(
          //
          //       child: Opacity(
          //           opacity: 1,
          //           child: GestureDetector(
          //             onTap: () {
          //
          //               FlutterOpenWhatsapp.sendSingleMessage("+5511992156335", "Hello I want to enter my order...");
          //               print("Container was tapped");
          //
          //             },
          //             child:Container(
          //
          //
          //               child: Image.asset('assets/icons/chat.png'),
          //
          //
          //
          //             ),
          //           )
          //       ),
          //     ),
          //
          //
          //
          //   ],
          //
          // )

    );
  }
}
