class PromoCode {

  DateTime dateExpiration;
  double promoValue;
  String code;

  PromoCode({this.dateExpiration, this.promoValue = 0.0, this.code});

  PromoCode.fromMap(Map<dynamic, dynamic> map) {
    dateExpiration = map['dateExpiration'].toDate();
    promoValue = map['promoValue'].toDouble();
    code = map['code'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dateExpiration'] = this.dateExpiration;
    data['promoValue'] = this.promoValue;
    data['code'] = this.code;
    return data;
  }
}