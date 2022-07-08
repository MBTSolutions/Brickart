import 'address_payment.dart';

class BillingPayment {
  String email;///Required
  AddressPayment address;///Required
  bool delayed;///Required

  BillingPayment({this.email, this.address, this.delayed});

  BillingPayment.fromMap(Map<String, dynamic> map) {
    email = map['email'];///Required
    address =
    map['address'] != null ? new AddressPayment.fromMap(map['address']) : null;
    delayed = map['delayed'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    if (this.address != null) {
      data['address'] = this.address.toMap();
    }
    data['delayed'] = this.delayed;
    return data;
  }
}