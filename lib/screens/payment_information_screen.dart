import 'package:brickart_flutter/controller/login_controller.dart';
import 'package:brickart_flutter/controller/payment_information_controller.dart';
import 'package:brickart_flutter/util/decimal_format.dart';
import 'package:brickart_flutter/util/masks.dart';
import 'package:brickart_flutter/widgets/app_bar_back.dart';
import 'package:brickart_flutter/widgets/basic_circular_progress_indicator.dart';
import 'package:brickart_flutter/widgets/text_form_field_basic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../util/textstyle_constant.dart';
import '../widgets/button_widget.dart';
import '../widgets/drawer_menu.dart';
final LoginController loginController = Get.find();

getEmailValuesSF() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Return String
  String stringValue = prefs.getString('email');
  return stringValue;
}

class PaymentInformationScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  final formKey = GlobalKey<FormState>();
  final PaymentInformationController controller = Get.find();

  final holderNameController = TextEditingController();
  final documentController = TextEditingController();
  final cardNumberController = TextEditingController();
  final expiratioDateController = TextEditingController();
  final cvvController = TextEditingController();


  @override
  Widget build(BuildContext context) {

    maskCpf.clear();
    maskCpf.clear();
    maskCard.clear();
    maskExpirationDate.clear();
    maskCVV.clear();

    return Obx(() => Scaffold(
          appBar: AppBarBack(
            title: 'Payment Information',
          ),
          key: _drawerKey,
          drawer: DrawerMenu(),
          body: SafeArea(
            child: AnimatedCrossFade(
              duration: Duration(seconds: 1),
              firstChild: Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: ListView(
                        children: <Widget>[
                          // Padding(
                          //   padding: const EdgeInsets.only(left: 14, top: 20),
                          //   child: Image.asset(
                          //     'assets/paymentcards.png',
                          //     height: 100,
                          //   ),
                          // ),
                          SizedBox(
                            height: 18,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                TextFormFieldBasic(
                                  'Nome do titular',
                                  'Nome como escrito no cartão',
                                  onChanged: (value) {
                                    controller.creditCard.value.holderName =
                                        value;
                                  },
                                  controller: holderNameController,
                                  textCapitalization:
                                      TextCapitalization.characters,
                                  validator: controller.validateName,
                                ),
                                TextFormFieldBasic(
                                  'CPF do titular',
                                  'CPF do titular no cartão',
                                  onChanged: (value) {
                                    controller.creditCard.value.document =
                                        value;
                                  },
                                  controller: documentController,
                                  inputFormatters: <TextInputFormatter>[
                                    maskCpf
                                  ],
                                  typeText: TextInputType.number,
                                  validator: controller.validateCpf,
                                ),
                                TextFormFieldBasic(
                                    'Card Number', 'xxxx xxxx xxxx xxxx',
                                    typeText: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      maskCard
                                    ], onChanged: (value) {
                                  controller.cardNumuber.value = value;
                                  controller.creditCard.value.cardNumber =
                                      value;
                                },
                                    controller: cardNumberController,
                                    validator: controller.validateNumberCard,
                                    suffixIcon: controller.masterCard
                                        ? imageAsset('mastercard.png')
                                        : controller.visa
                                            ? imageAsset('visa.png')
                                            : controller.americanExpress
                                                ? imageAsset(
                                                    'american_express.png')
                                                : controller.dinersClub
                                                    ? imageAsset(
                                                        'diners_club.png')
                                                    : controller.discover
                                                        ? imageAsset(
                                                            'discover.png')
                                                        : null),
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: TextFormFieldBasic(
                                        'Expiration Date',
                                        'mm/aa',
                                        inputFormatters: <TextInputFormatter>[
                                          maskExpirationDate
                                        ],
                                        controller: expiratioDateController,
                                        typeText: TextInputType.number,
                                        onChanged: (value) {
                                          controller.setDataExpiration(value);
                                        },
                                        validator:
                                            controller.validateExpirationDate,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 16,
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: TextFormFieldBasic(
                                          'CVV',
                                          '123',
                                          controller: cvvController,
                                          typeText: TextInputType.number,
                                          inputFormatters: <TextInputFormatter>[
                                            maskCVV
                                          ],
                                          onChanged: (value) {
                                            controller.creditCard.value
                                                .securityCode = value;
                                          },
                                          validator: controller.validateCVV,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                      child: Text(
                                    '',
                                    style: TextStyle(color: Colors.red),
                                  )),
                                ),
                               // SizedBox(height: 5),
                                Text(
                                  'Installments',
                                  style: kTextFieldLabel,
                                ),
                                SizedBox(height: 7),
                                Row(
                                  children: <Widget>[
                                    Container(
                                      width: 80,
                                      child: DropdownButton(
                                        value: controller.installments[
                                            controller
                                                .installmentSelectedPosition
                                                .value],
                                        items: controller.installments
                                            .map<DropdownMenuItem<String>>((e) {
                                          return DropdownMenuItem<String>(
                                            value: e,
                                            child: Text(e),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          controller.installmentSelectedPosition
                                                  .value =
                                              controller.installments
                                                  .indexOf(value);
                                          print(value);
                                        },
                                        icon: Container(
                                          width: 28,
                                          height: 26,
                                          color: Color(0xff606060),
                                          child: Icon(
                                            Icons.keyboard_arrow_down,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        '${controller.installments[controller.installmentSelectedPosition.value]} '
                                        'installment of '
                                        '${reaisFormat(controller.cartController.total / (controller.installmentSelectedPosition.value + 1))}',
                                        style: TextStyle(
                                          color: Color(0xff5B5B5B),
                                          fontSize: 12,
                                          fontWeight: FontWeight.normal,
                                          fontStyle: FontStyle.normal,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                               // SizedBox(height: 80),
                               //  Container(
                               //   // width: MediaQuery.of(context).size.width * 1,
                               //    child: Image.asset(
                               //      'assets/images/belowpayments.png',
                               //      // height: 26,
                               //      // width: 100,
                               //    ),
                               //  ),
                                // SizedBox(
                                //   height: 20,
                                // ),
                              ],
                            ),
                          ),
                          Container(
                            // width: MediaQuery.of(context).size.width * 1,
                            child: Image.asset(
                              'assets/images/belowpayments.png',
                              // height: 26,
                              // width: 100,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ButtonWidget(
                              textColor: Colors.white,
                              onPressed: () {
                                _addPaymentInformation();
                                //Get.to(OrderConfirmedScreen());
                              },
                              color: Theme.of(context).primaryColor,
                              text: 'ADD PAYMENT INFORMATION'),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              secondChild: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Analyzing Card'),
                    SizedBox(
                      height: 8,
                    ),
                    BasicCircularProgressIndicator()
                  ],
                ),
              ),
              crossFadeState: controller.analyzingCard.value
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
            ),
          ),
        ));
  }

  imageAsset(String image) {
    return Image.asset(
      'assets/images/$image',
      width: 30,
      height: 30,
    );
  }

  _addPaymentInformation() {
    if (!formKey.currentState.validate()) {
      return;
    }

    controller.getHashCard();
  }
}
