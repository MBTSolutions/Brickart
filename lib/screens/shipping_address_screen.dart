import 'package:brickart_flutter/API/correios_api.dart';
import 'package:brickart_flutter/controller/login_controller.dart';
import 'package:brickart_flutter/controller/shipping_address_controller.dart';
import 'package:brickart_flutter/models/shipping_address.dart';
import 'package:brickart_flutter/util/masks.dart';
import 'package:brickart_flutter/widgets/app_bar_back.dart';
import 'package:brickart_flutter/widgets/text_form_field_basic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../widgets/button_widget.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

int statusCodeSuccess;
final LoginController loginController = Get.find();

Future<Correios> CorreiosData(String zipCode) async {
  final response = await http
      .get(Uri.parse('https://viacep.com.br/ws/' + zipCode + '/json'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.

    statusCodeSuccess = response.statusCode;
    print(statusCodeSuccess);
    return Correios.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class Correios {
  final String uf;
  final String localidade;
  final String logradouro;
  final String bairro;

  Correios({
    this.uf,
    this.localidade,
    this.logradouro,
    this.bairro,
  });

  factory Correios.fromJson(Map<String, dynamic> json) {
    return Correios(
      uf: json['uf'],
      localidade: json['localidade'],
      logradouro: json['logradouro'],
      bairro: json['bairro'],
    );
  }
}

class ShippingAddressScreen extends StatefulWidget {
  @override
  _ShippingAddressScreenState createState() => _ShippingAddressScreenState();
}

class _ShippingAddressScreenState extends State<ShippingAddressScreen> {
  final formKey = GlobalKey<FormState>();
  final _shippingAddressController = ShippingAddressController();

  Future<Correios> correios;

  String neighborhoodString;
  final LoginController loginController = Get.find();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    correios =
        CorreiosData(_shippingAddressController.newShippingAddress.zipCode);
    // emailController.text = "dfdffddf";
    //
    //
    // neighborhoodController.text = "";
    // emailController.text = "jkjkjkjkj";
  }

  // void _fetchCorreios(String _shippingAddressController.newShippingAddress
  //     .zipCode) async {
  //   // final Correios fetchCorreios = await  CorreiosData(_shippingAddressController
  //   //     .newShippingAddress
  //   //     .zipCode);
  //   // final String res = fetchCorreios.bairro;
  //   // setState(() {
  //   //   neighborhoodString = res;
  //   // });
  // }

  @override
  Widget build(BuildContext context) {
    _shippingAddressController.onInit();

    ShippingAddress address = _shippingAddressController.newShippingAddress;
    print("sddsds" +
        _shippingAddressController.newShippingAddress.email.toString());
    // fullNameController.text = address.fullName;
    // documentController.text = address.document;
    _shippingAddressController.emailController.text =
        _shippingAddressController.newShippingAddress.email;
    //  whatsAppNumberController.text = address.whatsAppNumber;
    //  zipCodController.text = address.zipCode;
    //  addressController.text = address.address;
    //  addresNumberController.text = address.addressNumber;
    //  extentionController.text = address.extention;
    //  neighborhoodController.text = address.neighborhood;
    //  cityController.text = address.city;
    //  stateController.text = address.state;

    return Obx(() => Scaffold(
          appBar: AppBarBack(
            title: 'Shipping Address',
          ),
          body: SafeArea(
            child: Form(
              key: formKey,
              child: Stack(
                children: [
                  Positioned(
                    child: Opacity(
                      opacity:
                          _shippingAddressController.addingShippingAddress.value
                              ? 0.2
                              : 1.0,
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              color: Colors.white,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 32),
                              child: ListView(
                                children: <Widget>[
                                  SizedBox(
                                    height: 21,
                                  ),
                                  TextFormFieldBasic(
                                    'Full Name',
                                    'your name',
                                    controller: _shippingAddressController
                                        .fullNameController,
                                    onChanged: (value) {
                                      _shippingAddressController
                                          .newShippingAddress.fullName = value;
                                    },
                                    validator: _nameValidator,
                                  ),
                                  TextFormFieldBasic(
                                    'Document',
                                    'your cpf',
                                    controller: _shippingAddressController
                                        .documentController,
                                    onChanged: (value) {
                                      _shippingAddressController
                                          .newShippingAddress.document = value;
                                    },
                                    inputFormatters: <TextInputFormatter>[
                                      maskCpf
                                    ],
                                    validator: _documentValidator,
                                  ),
                                  TextFormFieldBasic(
                                    'Email',
                                    'aaa@aaa.com.br',
                                    controller: _shippingAddressController
                                        .emailController,
                                    onChanged: (value) {
                                      _shippingAddressController
                                          .newShippingAddress.email = value;
                                    },
                                    validator: _emailValidator,
                                    typeText: TextInputType.emailAddress,
                                  ),
                                  TextFormFieldBasic(
                                    'Whatsapp Number',
                                    '(xx) xxxxx-xxxx',
                                    controller: _shippingAddressController
                                        .whatsAppNumberController,
                                    onChanged: (value) {
                                      _shippingAddressController
                                          .newShippingAddress
                                          .whatsAppNumber = value;
                                    },
                                    inputFormatters: <TextInputFormatter>[
                                      maskCellPhone
                                    ],
                                    validator: _whatsAppValidator,
                                    typeText: TextInputType.phone,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.25,
                                        child: TextFormFieldBasic(
                                          'Zip Code',
                                          'xxxxx-xxx',
                                          controller: _shippingAddressController
                                              .zipCodController,
                                          onChanged: (value) async {
                                            _shippingAddressController
                                                .newShippingAddress
                                                .zipCode = value;

                                            if (_shippingAddressController
                                                    .newShippingAddress
                                                    .zipCode
                                                    .length ==
                                                9) {
                                              print('enough values entered');
                                              final Correios fetchCorreios =
                                                  await CorreiosData(
                                                      _shippingAddressController
                                                          .newShippingAddress
                                                          .zipCode);
                                              final String neighborhood =
                                                  fetchCorreios.bairro;
                                              final String state =
                                                  fetchCorreios.uf;
                                              final String street =
                                                  fetchCorreios.logradouro;
                                              final String city =
                                                  fetchCorreios.localidade;

                                              setState(() {
                                                _shippingAddressController
                                                    .neighborhoodController
                                                    .text = neighborhood;
                                                _shippingAddressController
                                                    .cityController.text = city;
                                                _shippingAddressController
                                                    .stateController
                                                    .text = state;
                                                _shippingAddressController
                                                    .addressController
                                                    .text = street;
                                              });
                                            }
                                          },
                                          inputFormatters: <TextInputFormatter>[
                                            maskZipCode
                                          ],
                                          typeText: TextInputType.number,
                                          validator: _zipCodeValidator,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 14,
                                      ),
                                       Expanded(
                                                                                child: TextFormFieldBasic(
                                    'adresss',
                                  'Rua um dois três',
                                    controller: _shippingAddressController
                                                .addressController,
                                    onChanged: (value) {
                                      _shippingAddressController
                                            .newShippingAddress.address = value;
                                          
                                          _shippingAddressController
                                                .addressController.text=_shippingAddressController
                                            .newShippingAddress.address  ;
                                            print('ashbvhagshyujasfhj,sfhyafsjfasjhfvsahvb${_shippingAddressController
                                                .addressController.text}');
                                    },
                                      validator: _addressValidator,
                                    typeText: TextInputType.text,
                                  ),
                                       ),
                                      // Expanded(
                                      //   child: TextFormFieldBasic(
                                      //     'Address',
                                      //     'Rua um dois três',
                                      //     controller: _shippingAddressController
                                      //         .addressController,
                                      //     onChanged: (value) {
                                      //       // _shippingAddressController
                                      //       //     .newShippingAddress
                                      //       //     .address = value;
                                      //           print('VALUE:$value');
                                      //       print(
                                      //           '${_shippingAddressController.newShippingAddress.address}');
                                      //       _shippingAddressController
                                      //               .addressController.text =
                                      //          value;
                                      //     },
                                      //     validator: _addressValidator,
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                  Row(
                                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Expanded(
                                        child: TextFormFieldBasic(
                                          'Address Number',
                                          'Number 34',
                                          controller: _shippingAddressController
                                              .addresNumberController,
                                          onChanged: (value) {
                                            _shippingAddressController
                                                .newShippingAddress
                                                .addressNumber = value;
                                          },
                                          validator: _addressNumberValidator,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 14,
                                      ),
                                      Expanded(
                                        child: TextFormFieldBasic(
                                          'Extention',
                                          'extention',
                                          controller: _shippingAddressController
                                              .extentionController,
                                          onChanged: (value) {
                                            _shippingAddressController
                                                .newShippingAddress
                                                .extention = value;
                                          },
                                          validator: _extentionValidator,
                                        ),
                                      ),
                                    ],
                                  ),
                                  TextFormFieldBasic(
                                    'Neighborhood',
                                    'Jardim um dois três',
                                    controller: _shippingAddressController
                                        .neighborhoodController,
                                    onChanged: (value) {
                                      _shippingAddressController
                                          .newShippingAddress
                                          .neighborhood = value;
                                    },
                                    validator: _neighborhoodValidator,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: TextFormFieldBasic(
                                          'City',
                                          'São Paulo',
                                          controller: _shippingAddressController
                                              .cityController,
                                          onChanged: (value) {
                                            _shippingAddressController
                                                .newShippingAddress
                                                .city = value;
                                          },
                                          validator: _cityValidator,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 16,
                                      ),
                                      Expanded(
                                        child: TextFormFieldBasic(
                                          'State',
                                          'São Paulo',
                                          controller: _shippingAddressController
                                              .stateController,
                                          onChanged: (value) {
                                            _shippingAddressController
                                                .newShippingAddress
                                                .state = value;
                                          },
                                          validator: _stateValidator,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 50,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: ButtonWidget(
                                  textColor: Colors.white,
                                  color: Theme.of(context).primaryColor,
                                  onPressed: () {
                                    if (validate()) {
                                      _shippingAddressController
                                          .saveOrUpdateShippingAddress();
                                    } else
                                      Get.snackbar('Warning', 'Check the form',
                                          backgroundColor:
                                              Get.theme.primaryColor,
                                          colorText: Colors.white);
                                  },
                                  text: 'ADD SHIPPING ADDRESS',
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    child: Opacity(
                      opacity:
                          _shippingAddressController.addingShippingAddress.value
                              ? 1.0
                              : 0.0,
                      child: Container(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  bool validate() {
    return formKey.currentState.validate();
  }

  String _nameValidator(String value) {
    if (GetUtils.isNullOrBlank(value)) {
      return 'Full name is empty';
    }
    return null;
  }

  String _documentValidator(String value) {
    if (GetUtils.isNullOrBlank(value)) {
      return 'Document name is empty';
    } else if (!GetUtils.isCpf(value.replaceAll('-', '').replaceAll('-', ''))) {
      return 'Document invalid';
    }
    return null;
  }

  String _emailValidator(String value) {
    if (GetUtils.isNullOrBlank(value))
      return 'Email is empty';
    else if (!GetUtils.isEmail(value)) return 'Invalid email';
    return null;
  }

  String _whatsAppValidator(String value) {
    if (GetUtils.isNullOrBlank(value))
      return 'Whatsapp number is empty';
    else if (!GetUtils.isPhoneNumber(
        '+55${value.replaceAll('(', '').replaceAll(')', '').replaceAll('-', '').trim()}'))
      return 'Invalid phone';
    return null;
  }

  String _zipCodeValidator(String value) {
    if (GetUtils.isNullOrBlank(value)) return 'Zip code is empty';
    return null;
  }

  String _addressValidator(String value) {
    if (GetUtils.isNullOrBlank(value)) return 'Address is empty';
    return null;
  }

  String _addressNumberValidator(String value) {
    if (GetUtils.isNullOrBlank(value)) return 'Address number is empty';
    return null;
  }

  String _extentionValidator(String value) {
    if (GetUtils.isNullOrBlank(value)) return 'Extention is empty';
    return null;
  }

  String _neighborhoodValidator(String value) {
    if (GetUtils.isNullOrBlank(value)) return 'Neighborhood is empty';
    return null;
  }

  String _cityValidator(String value) {
    if (GetUtils.isNullOrBlank(value)) return 'City is empty';
    return null;
  }

  String _stateValidator(String value) {
    if (GetUtils.isNullOrBlank(value)) return 'State is empty';
    return null;
  }
}
