class Charge {
  ///Obrigatório
  String description;
  List<String> references;

  ///Obrigatório amount ou totalAmount, no amount
  double totalAmount;///Valor total da transação. Requer uso do parâmetro installments. Se utilizado, não deverá ser utilizado amount.
  double amount;///Valor total da parcela. O valor será aplicado para cada parcela. Se utilizado, não deverá ser utilizado totalAmount
  String dueDate;///yyyy-MM-dd
  int installments;///Número de parcelas.
  int maxOverdueDays;
  int fine;
  String interest;
  String discountAmount;
  int discountDays;
  List<String> paymentTypes;///Tipos de pagamento permitidos BOLETO e CREDIT_CARD. Para checkout transparente, deve receber obrigatoriamente o tipo CREDIT_CARD.
  bool paymentAdvance;
  String feeSchemaToken;
  Null split;

  Charge(
      {this.description,
        this.references,
        this.totalAmount,
        this.amount,
        this.dueDate,
        this.installments,
        this.maxOverdueDays,
        this.fine,
        this.interest,
        this.discountAmount,
        this.discountDays,
        this.paymentTypes,
        this.paymentAdvance = true,
        this.feeSchemaToken,
        this.split});

  Charge.fromMap(Map<String, dynamic> map) {
    description = map['description'];
    references = map['references'].cast<String>();
    totalAmount = map['totalAmount'];
    amount = map['amount'];
    dueDate = map['dueDate'];
    installments = map['installments'];
    maxOverdueDays = map['maxOverdueDays'];
    fine = map['fine'];
    interest = map['interest'];
    discountAmount = map['discountAmount'];
    discountDays = map['discountDays'];
    paymentTypes = map['paymentTypes'].cast<String>();
    paymentAdvance = map['paymentAdvance'];
    feeSchemaToken = map['feeSchemaToken'];
    split = map['split'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['references'] = this.references;
    data['totalAmount'] = this.totalAmount;
    data['amount'] = this.amount;
    data['dueDate'] = this.dueDate;
    data['installments'] = this.installments;
    data['maxOverdueDays'] = this.maxOverdueDays;
    data['fine'] = this.fine;
    data['interest'] = this.interest;
    data['discountAmount'] = this.discountAmount;
    data['discountDays'] = this.discountDays;
    data['paymentTypes'] = this.paymentTypes;
    data['paymentAdvance'] = this.paymentAdvance;
    data['feeSchemaToken'] = this.feeSchemaToken;
    data['split'] = this.split;
    return data;
  }
}