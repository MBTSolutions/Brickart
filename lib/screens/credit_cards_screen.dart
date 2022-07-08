import 'package:brickart_flutter/controller/payment_information_controller.dart';
import 'package:brickart_flutter/models/juno/credit_card_token.dart';
import 'package:brickart_flutter/screens/payment_information_screen.dart';
import 'package:brickart_flutter/widgets/app_bar_back.dart';
import 'package:brickart_flutter/widgets/basic_circular_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreditCardsScreen extends StatelessWidget {
  final PaymentInformationController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    controller.cardTokens.listen((element) {
      if (controller.cardTokens.isEmpty) {
        Get.back();
        Get.to(PaymentInformationScreen());
      }
    });

    return Obx(() => Scaffold(
          appBar: AppBarBack(title: 'Credits Cards',),
          body: controller.isLoading.value
              ? Center(child: BasicCircularProgressIndicator())
              : ListView.builder(
                  itemCount: controller.cardTokens.length,
                  itemBuilder: (snapshot, index) {
                    CreditCardToken token = controller.cardTokens[index];

                    return ListTile(
                      leading: Icon(
                        Icons.credit_card,
                        color: Get.theme.primaryColor,
                      ),
                      onTap: () {
                        Get.defaultDialog(
                          title: 'Cofirm',
                          middleText: 'Select this card?',
                          textConfirm: 'Yes',
                          onConfirm: () {
                            controller.selectCard(token.creditCardId);
                            Get.back();
                          },
                          confirmTextColor: Colors.white,
                          textCancel: 'No',
                          //onCancel: () => Get.back(),
                          cancelTextColor: Get.theme.primaryColor,
                          buttonColor: Get.theme.primaryColor,
                        );
                      },
                      onLongPress: () {
                        Get.defaultDialog(
                          title: 'Cofirm',
                          middleText: 'Delete this card?',
                          textConfirm: 'Yes',
                          onConfirm: () {
                            controller.deleteCard(token.creditCardId);
                            Get.back();
                          },
                          confirmTextColor: Colors.white,
                          textCancel: 'No',
                          //onCancel: () => Get.back(),
                          cancelTextColor: Get.theme.primaryColor,
                          buttonColor: Get.theme.primaryColor,
                        );
                      },
                      title: Text(token.brand == null
                          ? 'Não Identificado'
                          : token.brand),
                      subtitle: Text('xxxx-xxxx-xxxx-${token.last4CardNumber}'),
                      trailing: Icon(
                        token.selected
                            ? Icons.radio_button_checked
                            : Icons.radio_button_off,
                        color: Get.theme.primaryColor,
                      ),
                    );
                  },
                ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Get.back();
              Get.to(PaymentInformationScreen());
            },
            label: Text('New Card'),
            icon: Icon(Icons.credit_card),
            backgroundColor: Get.theme.primaryColor,
          ),
        ));
  }
}
