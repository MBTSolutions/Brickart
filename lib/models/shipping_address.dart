class ShippingAddress {
  String fullName;
  String document;
  String email;
  String whatsAppNumber;
  String zipCode;
  String address;
  String addressNumber;
  String extention;
  String neighborhood;
  String city;
  String state;

  ShippingAddress({
    this.fullName,
    this.document,
    this.email,
    this.whatsAppNumber,
    this.zipCode,
    this.address,
    this.addressNumber,
    this.extention,
    this.neighborhood,
    this.city,
    this.state,
  });

  ShippingAddress.fromMap(Map<dynamic, dynamic> map) {
    fullName = map['fullName'];
    document = map['document'];
    email = map['email'];
    whatsAppNumber = map['whatsAppNumber'];
    zipCode = map['zipCode'];
    address = map['address'];
    addressNumber = map['addressNumber'];
    extention = map['extention'];
    neighborhood = map['neighborhood'];
    city = map['city'];
    state = map['state'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fullName'] = this.fullName;
    data['document'] = this.document;
    data['email'] = this.email;
    data['whatsAppNumber'] = this.whatsAppNumber;
    data['zipCode'] = this.zipCode;
    data['address'] = this.address;
    data['addressNumber'] = this.addressNumber;
    data['extention'] = this.extention;
    data['neighborhood'] = this.neighborhood;
    data['city'] = this.city;
    data['state'] = this.state;
    return data;
  }
}
