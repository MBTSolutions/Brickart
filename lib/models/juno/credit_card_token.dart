class CreditCardToken {
  String creditCardId;
  String last4CardNumber;
  String expirationMonth;
  String expirationYear;
  String holderName;
  String document;
  String brand;
  bool selected;

  CreditCardToken(
      {
        this.creditCardId,
        this.last4CardNumber,
        this.expirationMonth,
        this.expirationYear,
        this.holderName,
        this.document,
        this.brand,
        this.selected
      });

  CreditCardToken.fromMap(Map<String, dynamic> map) {
    creditCardId = map['creditCardId'];
    last4CardNumber = map['last4CardNumber'];
    expirationMonth = map['expirationMonth'];
    expirationYear = map['expirationYear'];
    holderName = map['holderName'];
    document = map['document'];
    brand = map['brand'];
    selected = map['selected'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['creditCardId'] = this.creditCardId;
    data['last4CardNumber'] = this.last4CardNumber;
    data['expirationMonth'] = this.expirationMonth;
    data['expirationYear'] = this.expirationYear;
    data['holderName'] = this.holderName;
    data['document'] = this.document;
    data['brand'] = this.brand;
    data['selected'] = this.selected;
    return data;
  }
}
