class Split {
  String recipientToken;
  int amount;
  int percentage;
  bool amountRemainder;
  bool chargeFee;

  Split(
      {this.recipientToken,
        this.amount,
        this.percentage,
        this.amountRemainder,
        this.chargeFee});

  Split.fromMap(Map<String, dynamic> map) {
    recipientToken = map['recipientToken'];
    amount = map['amount'];
    percentage = map['percentage'];
    amountRemainder = map['amountRemainder'];
    chargeFee = map['chargeFee'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['recipientToken'] = this.recipientToken;
    data['amount'] = this.amount;
    data['percentage'] = this.percentage;
    data['amountRemainder'] = this.amountRemainder;
    data['chargeFee'] = this.chargeFee;
    return data;
  }
}
