class Product {
  double price;
  double additionalPrice;
  double iOSImageSizeInpx;
  double imageSize;
  int mimimunOrderQuantity;
  double priceForMoq;

  Product({
    this.price,
    this.additionalPrice,
    this.iOSImageSizeInpx,
    this.imageSize,
    this.mimimunOrderQuantity,
    this.priceForMoq
  });

  Product.fromMap(Map<dynamic, dynamic> map) {
    price = map['price'].toDouble();
    additionalPrice = map['additionalPrice'].toDouble();
    iOSImageSizeInpx = map['iOSImageSizeInPx'].toDouble();
    imageSize = map['imageSize'].toDouble();
    mimimunOrderQuantity = map['mimimunOrderQuantity'];
    priceForMoq = map['priceForMoq'].toDouble();
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['price'] = this.price;
    data['additionalPrice'] = this.additionalPrice;
    data['iOSImageSizeInPx'] = this.iOSImageSizeInpx;
    data['imageSize'] = this.imageSize;
    data['mimimunOrderQuantity'] = this.mimimunOrderQuantity;
    data['priceForMoq'] = this.priceForMoq;
    return data;
  }
}