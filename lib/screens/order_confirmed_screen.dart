import 'package:brickart_flutter/controller/order_controller.dart';
import 'package:brickart_flutter/util/date_format.dart';
import 'package:brickart_flutter/util/decimal_format.dart';
import 'package:brickart_flutter/widgets/appbar_listtile.dart';
import 'package:brickart_flutter/widgets/basic_circular_progress_indicator.dart';
import 'package:brickart_flutter/widgets/button_widget.dart';
import 'package:brickart_flutter/widgets/drawer_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderConfirmedScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  final OrderController orderController = OrderController();

  @override
  Widget build(BuildContext context) {
    orderController.onInit();

    return Obx(() => Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: AppbarListTile(
              drawerKey: _drawerKey,
              title: 'Brick do Timão',
              isAR: false,
            ),
          ),
          key: _drawerKey,
          drawer: DrawerMenu(),
          body: SafeArea(
            child: orderController.completingOrder.value
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Completing order...'),
                        SizedBox(
                          height: 8,
                        ),
                        BasicCircularProgressIndicator(),
                      ],
                    ),
                  )
                : orderController.order.value != null
                    ? Column(
                        children: [
                          Expanded(
                            child: ListView(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(30),
                                  child: Center(
                                      child: Text(
                                    'Order Confirmed',
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Get.theme.primaryColor),
                                  )),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(32, 0, 32, 0),
                                  child: Column(
                                    children: [
                                      returnRow(
                                          'Order date',
                                          returnsFormattedDate(orderController
                                                  .order.value.date ??
                                              new DateTime.now())),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      returnRow(
                                          'ID Payment Number', '123456789'),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      returnRow('ID Order Number',
                                          orderController.order.value.orderId),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      returnRow(
                                          'Full Amount',
                                          reaisFormat(orderController
                                                  .order.value.fullAmout ??
                                              0.0)),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      returnRow(
                                          'Payment Method', 'Credit Card'),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      returnRow('Delivery Estimate',
                                          'May 10th, 2019'),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      returnRow(
                                          'Contact', 'matheusfink@gmail.com'),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: ButtonWidget(
                                              text: 'PRINT RECEIPT',
                                              onPressed: () {},
                                              color: Get.theme.primaryColor,
                                              textColor: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 12,
                                      ),
                                      Text(
                                        'Você recerá um email dentro de 24h contendo as '
                                        'informações do pedido. Se necessário, pode nos conectar '
                                        'pelo chat de atendimento logo acima',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 11.5),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Divider(
                                  thickness: 2,
                                ),
                                Container(
                                    child: Center(
                                  child: Column(
                                    children: [
                                      Text(
                                        'Rate Us!',
                                        style: TextStyle(
                                            fontSize: 24,
                                            color: Get.theme.primaryColor,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        'Share your love and rate our app',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.star,
                                            color: Colors.yellow.shade600,
                                            size: 50,
                                          ),
                                          Icon(
                                            Icons.star,
                                            color: Colors.yellow.shade600,
                                            size: 50,
                                          ),
                                          Icon(
                                            Icons.star,
                                            color: Colors.yellow.shade600,
                                            size: 50,
                                          ),
                                          Icon(
                                            Icons.star,
                                            color: Colors.grey,
                                            size: 50,
                                          ),
                                          Icon(
                                            Icons.star,
                                            color: Colors.grey,
                                            size: 50,
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                )),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: ButtonWidget(
                                  color: Get.theme.primaryColor,
                                  textColor: Colors.white,
                                  onPressed: () => Get.offAllNamed('/home'),
                                  text: 'Go To Home',
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Não foi possível salvar o pedido ):'),
                            SizedBox(
                              height: 12,
                            ),
                            ButtonWidget(
                              color: Get.theme.primaryColor,
                              textColor: Colors.white,
                              onPressed: () => Get.offAllNamed('/home'),
                              text: 'Go To Home',
                              shape: 8,
                              elevation: 6,
                            ),
                          ],
                        ),
                      ),
          ),
        ));
  }

  returnRow(String description, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          description,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(value ?? 'text')
      ],
    );
  }
}
