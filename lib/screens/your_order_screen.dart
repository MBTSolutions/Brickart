import 'package:brickart_flutter/bloc/auth_bloc.dart';
import 'package:brickart_flutter/controller/order_controller.dart';
import 'package:brickart_flutter/models/auth_status.dart';
import 'package:brickart_flutter/models/order/order.dart';
import 'package:brickart_flutter/util/date_format.dart';
import 'package:brickart_flutter/util/decimal_format.dart';
import 'package:brickart_flutter/util/route_guard.dart';
import 'package:brickart_flutter/widgets/basic_circular_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../util/textstyle_constant.dart';
import '../widgets/appbar_listtile.dart';
import '../widgets/drawer_menu.dart';

class YourOrderScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  final orderController = OrderController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthStatus>(
        stream: Provider.of<AuthBloc>(context).authStatus,
        builder: (context, snapshot) {
          if (snapshot?.data == AuthStatus.signedOut) {
            navigateToLogin(context);
            return Scaffold();
          } else {
            orderController.getMyOrders();

            return Obx(() => Scaffold(
                  backgroundColor: Color(0xffE5E5E5),
                  appBar: AppBar(
                    automaticallyImplyLeading: false,
                    centerTitle: true,
                    title: AppbarListTile(
                      drawerKey: _drawerKey,
                      title: 'Your Order',
                      isAR: false,
                    ),
                  ),
                  key: _drawerKey,
                  drawer: DrawerMenu(),
                  body: SafeArea(
                    child: orderController.isLoading.value
                        ? Center(
                            child: BasicCircularProgressIndicator(),
                          )
                        : orderController.myOrdersList.length > 0
                            ? ListView.builder(
                                itemBuilder: (context, index) => OrderCards(
                                    orderController.myOrdersList[index]),
                                itemCount: orderController.myOrdersList.length,
                              )
                            : Center(
                                child: Text('No orders'),
                              ),
                  ),
                ));
          }
        });
  }
}

class OrderCards extends StatelessWidget {
  final Order order;
  OrderCards(this.order);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      // child: GFAccordion(
      //   //titleContainerHeight: 120,
      //   titlePadding: EdgeInsets.symmetric(horizontal: 10),
      //   titleChild: Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: <Widget>[
      //       Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //         children: <Widget>[
      //           Text('ID Order Number', style: bottomAppBarTextStyle),
      //           Text('Order Status', style: bottomAppBarTextStyle),
      //         ],
      //       ),
      //       Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //         children: <Widget>[
      //           Text(order.orderId, style: px12BoldBlack),
      //           Text('Completed', style: px12BoldBlack),
      //         ],
      //       ),
      //       Text(returnsDateFormattedWithTime(order.date),
      //           style: TextStyle(
      //             color: Color(0xff303030),
      //             fontSize: 9,
      //           )),
      //       Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //         children: <Widget>[
      //           Text('Full Amount', style: px12BoldBlack),
      //           Text(reaisFormat(order.fullAmout), style: homeSubTitle),
      //         ],
      //       ),
      //     ],
      //   ),
      //   expandedTitlebackgroundColor: Colors.white,
      //   collapsedTitlebackgroundColor: Colors.white,
      //   contentChild: Container(
      //     height: 310,
      //     child: Column(
      //       crossAxisAlignment: CrossAxisAlignment.start,
      //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //       children: <Widget>[
      //         Container(
      //           height: 115,
      //           child: ListView.builder(
      //             scrollDirection: Axis.horizontal,
      //             itemBuilder: (context, index) => Container(
      //               margin: const EdgeInsets.only(right: 14),
      //               child: Image.network(order.itens[index].url),
      //               // Image.asset(
      //               //     'assets/collectionImage/img${index + 1}.png'),
      //             ),
      //             itemCount: order.itens.length,
      //           ),
      //         ),
      //         Row(
      //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //           children: <Widget>[
      //             Text('Order date ', style: px12BoldBlack),
      //             Text(returnsFormattedDate(order.date),
      //                 style: px12NormalBlack),
      //           ],
      //         ),
      //         Row(
      //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //           children: <Widget>[
      //             Text('ID Payment Number ', style: px12BoldBlack),
      //             Text('123456789', style: px12NormalBlack),
      //           ],
      //         ),
      //         Row(
      //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //           children: <Widget>[
      //             Text('Payment Method ', style: px12BoldBlack),
      //             Text('Credit Card', style: px12NormalBlack),
      //           ],
      //         ),
      //         Row(
      //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //           children: <Widget>[
      //             Text('Contact ', style: px12BoldBlack),
      //             Text('matheusfink@gmail.com', style: px12NormalBlack),
      //           ],
      //         ),
      //         Row(
      //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //           children: <Widget>[
      //             Text('Full Amount ', style: px12BoldBlack),
      //             Text(reaisFormat(order.fullAmout), style: px12NormalBlack),
      //           ],
      //         ),
      //       ],
      //     ),
      //   ),
      //   collapsedIcon: Container(
      //     height: 16,
      //     width: 16,
      //     decoration: BoxDecoration(
      //       shape: BoxShape.circle,
      //       color: Theme.of(context).primaryColor,
      //     ),
      //     child: Center(
      //       child: Icon(
      //         Icons.expand_more,
      //         color: Colors.white,
      //         size: 16,
      //       ),
      //     ),
      //   ),
      //   expandedIcon: Container(
      //     height: 16,
      //     width: 16,
      //     decoration: BoxDecoration(
      //       shape: BoxShape.circle,
      //       color: Theme.of(context).primaryColor,
      //     ),
      //     child: Center(
      //       child: Icon(
      //         Icons.expand_less,
      //         color: Colors.white,
      //         size: 16,
      //       ),
      //     ),
      //   ),
      // ),
      child: Container(),
    );
  }
}
