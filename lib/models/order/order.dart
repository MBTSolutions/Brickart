import 'package:brickart_flutter/models/order/order_itens.dart';

class Order {
  double addPrice;
  int addQuantity;
  DateTime date;
  double discount;
  double fullAmout;
  double minPrice;
  int minQuantity;
  String orderId;
  int quantity;
  List<OrderItens> itens;

  Order({
    this.addPrice,
    this.addQuantity,
    this.date,
    this.discount,
    this.fullAmout,
    this.minPrice,
    this.minQuantity,
    this.orderId,
    this.quantity,
    this.itens,
  });

  Order.fromMap(Map<String, dynamic> map) {
    addPrice = map['add_price'].toDouble();
    addQuantity = map['add_quantity'];
    date = map['date'].toDate();
    discount = map['discount'].toDouble();
    fullAmout = map['full_amount'].toDouble();
    minPrice = map['min_price'].toDouble();
    minQuantity = map['min_quantity'];
    orderId = map['order_id'];
    quantity = map['quantity'];
    if (map['images'] != null) {
      itens = [];
      map['images'].forEach((v) {
        itens.add(new OrderItens.fromMap(v));
      });
    }
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['add_price'] = this.addPrice;
    data['add_quantity'] = this.addQuantity;
    data['date'] = this.date;
    data['discount'] = this.discount;
    data['full_amount'] = this.fullAmout;
    data['min_price'] = this.minPrice;
    data['min_quantity'] = this.minQuantity;
    data['order_id'] = this.orderId;
    data['quantity'] = this.quantity;
    if (this.itens != null) {
      data['images'] = this.itens.map((v) => v.toMap()).toList();
    }
    return data;
  }
}
