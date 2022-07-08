class PaymentInformation {

  String nameCardHolder;
  String cardNumber;
  DateTime expirationDate;
  int cvv;

  PaymentInformation({
      this.nameCardHolder,
    this.cardNumber,
    this.expirationDate,
    this.cvv});

  PaymentInformation.fromMap(Map<dynamic, dynamic> map) {
    nameCardHolder = map['nameCardHolder'];
    cardNumber = map['cardNumber'];
    expirationDate = map['expirationDate'];
    cvv = map['cvv'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nameCardHolder'] = this.nameCardHolder;
    data['cardNumber'] = this.cardNumber;
    data['expirationDate'] = this.expirationDate;
    data['cvv'] = this.cvv;
    return data;
  }

}