class BillingCharge {
  String name;///Required
  String document;///Required
  String phone;
  String birthDate;
  bool notify;

  BillingCharge({this.name, this.document, this.phone, this.birthDate, this.notify});

  BillingCharge.fromMap(Map<String, dynamic> map) {
    name = map['name'];
    document = map['document'];
    phone = map['phone'];
    birthDate = map['birthDate'];
    notify = map['notify'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['document'] = this.document;
    data['phone'] = this.phone;
    data['birthDate'] = this.birthDate;
    data['notify'] = this.notify;
    return data;
  }
}