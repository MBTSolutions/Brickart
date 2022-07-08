class OrderItens {
  String url;
  int quantity;
  bool lowQuality;

  OrderItens({this.url, this.quantity, this.lowQuality});

  OrderItens.fromMap(Map<String, dynamic> map) {
    url = map['url'];
    quantity = map['quantity'];
    lowQuality = map['lowQuality'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['quantity'] = this.quantity;
    data['lowQuality'] = this.lowQuality;
    return data;
  }
}
