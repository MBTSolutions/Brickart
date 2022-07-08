import 'billing_charge.dart';
import 'charge.dart';

class ChargeDetail {
  Charge charge;
  BillingCharge billing;

  ChargeDetail({this.charge, this.billing});

  ChargeDetail.fromMap(Map<String, dynamic> map) {
    charge =
    map['charge'] != null ? new Charge.fromMap(map['charge']) : null;
    billing =
    map['billing'] != null ? new BillingCharge.fromMap(map['billing']) : null;
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.charge != null) {
      data['charge'] = this.charge.toMap();
    }
    if (this.billing != null) {
      data['billing'] = this.billing.toMap();
    }
    return data;
  }
}




