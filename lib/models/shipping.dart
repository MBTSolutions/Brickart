class Shipping {
  int internalProduceTimeInDays;
  bool isAllowFreeFrieght;
  double freeShipping;
  double weight;
  int format;
  double length;
  double height;
  double width;
  double diameter;
  String selfhand;
  String noticeOfReceipt;
  int postOfficeServiceType;

  Shipping({
    this.internalProduceTimeInDays,
    this.isAllowFreeFrieght,
    this.freeShipping,
    this.weight,
    this.format,
    this.length,
    this.height,
    this.width,
    this.diameter,
    this.selfhand,
    this.noticeOfReceipt,
    this.postOfficeServiceType
});

  Shipping.fromMap(Map<dynamic, dynamic> map) {
    internalProduceTimeInDays = map['internalProduceTimeInDays'];
    isAllowFreeFrieght = map['IsAllowFreeFrieght'];
    freeShipping = map['freeShipping'].toDouble();
    weight = map['weight'].toDouble();
    format = map['format'];
    length = map['length'].toDouble();
    height = map['height'].toDouble();
    width = map['width'].toDouble();
    diameter = map['diameter'].toDouble();
    selfhand = map['selfhand'];
    noticeOfReceipt = map['noticeOfReceipt'];
    postOfficeServiceType = map['postOfficeServicType'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['internalProduceTimeInDays'] = this.internalProduceTimeInDays;
    data['freeShipping'] = this.freeShipping;
    data['IsAllowFreeFrieght'] = this.isAllowFreeFrieght;
    data['weight'] = this.weight;
    data['format'] = this.format;
    data['length'] = this.length;
    data['height'] = this.height;
    data['width'] = this.width;
    data['diameter'] = this.diameter;
    data['selfhand'] = this.selfhand;
    data['noticeOfReceipt'] = this.noticeOfReceipt;
    data['postOfficeServicType'] = this.postOfficeServiceType;
    return data;
  }
}