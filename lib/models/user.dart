class User {
  String address="";
  String addressNumber;
  String city;
  DateTime createdAt;
  String disctrict;
  String document;
  String email;
  String mobilePhone;
  String name;
  String profilePicture;
  String state;
  String zipCode;

  User({
    this.address,
    this.addressNumber,
    this.city,
    this.createdAt,
    this.disctrict,
    this.document,
    this.email,
    this.mobilePhone,
    this.name,
    this.profilePicture,
    this.state,
    this.zipCode,
  });

  User.fromMap(Map<String, dynamic> map) {
    address = map['address'];
    addressNumber = map['address_number'];
    city = map['city'];
    createdAt = map['created_at'].toDate();
    disctrict = map['district'];
    document = map['document'];
    email = map['email'];
    mobilePhone = map['mobile_phone'];
    name = map['name'];
    profilePicture = map['profile_picture'];
    state = map['state'];
    zipCode = map['zip_code'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['address_number'] = this.addressNumber;
    data['city'] = this.city;
    data['created_at'] = this.createdAt;
    data['district'] = this.disctrict;
    data['document'] = this.document;
    data['email'] = this.email;
    data['mobile_phone'] = this.mobilePhone;
    data['name'] = this.name;
    data['profile_picture'] = this.profilePicture;
    data['state'] = this.state;
    data['zip_code'] = this.zipCode;
    return data;
  }
}
