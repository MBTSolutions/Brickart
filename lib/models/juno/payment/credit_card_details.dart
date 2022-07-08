class CreditCardDetails {
  ///informar o creditCardId gerado pela tokenização, ou o hash, apenas um.
  String creditCardId;
  String creditCardHash;

  CreditCardDetails({this.creditCardId, this.creditCardHash});

  CreditCardDetails.fromMap(Map<String, dynamic> map) {
    creditCardId = map['creditCardId'];
    creditCardHash = map['creditCardHash'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['creditCardId'] = this.creditCardId;
    data['creditCardHash'] = this.creditCardHash;
    return data;
  }
}