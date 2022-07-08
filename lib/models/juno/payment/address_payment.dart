class AddressPayment {
  String street;///Required
  String number;///Required
  String complement;
  String neighborhood;
  String city;///Required
  String state;///Required (U.F)
  String postCode;///Required(12345000)

  AddressPayment(
      {this.street,
        this.number,
        this.complement,
        this.neighborhood,
        this.city,
        this.state,
        this.postCode});

  AddressPayment.fromMap(Map<String, dynamic> map) {
    street = map['street'];
    number = map['number'];
    complement = map['complement'];
    neighborhood = map['neighborhood'];
    city = map['city'];
    state = map['state'];
    postCode = map['postCode'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['street'] = this.street;
    data['number'] = this.number;
    data['complement'] = this.complement;
    data['neighborhood'] = this.neighborhood;
    data['city'] = this.city;
    data['state'] = this.state;
    data['postCode'] = this.postCode;
    return data;
  }
}