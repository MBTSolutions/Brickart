import 'package:brickart_flutter/models/juno/payment/billing_payment.dart';
import 'package:brickart_flutter/models/juno/payment/credit_card_details.dart';

class Payment {
  String chargeId;///Required
  BillingPayment billing;///Required
  CreditCardDetails creditCardDetails;///Required

  Payment({this.chargeId, this.billing, this.creditCardDetails});

  Payment.fromMap(Map<String, dynamic> map) {
    chargeId = map['chargeId'];
    billing =
    map['billing'] != null ? new BillingPayment.fromMap(map['billing']) : null;
    creditCardDetails = map['creditCardDetails'] != null
        ? new CreditCardDetails.fromMap(map['creditCardDetails'])
        : null;
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['chargeId'] = this.chargeId;
    if (this.billing != null) {
      data['billing'] = this.billing.toMap();
    }
    if (this.creditCardDetails != null) {
      data['creditCardDetails'] = this.creditCardDetails.toMap();
    }
    return data;
  }
}






