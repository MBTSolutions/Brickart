import 'dart:convert';

import 'package:brickart_flutter/controller/login_controller.dart';
import 'package:brickart_flutter/models/juno/charge/billing_charge.dart';
import 'package:brickart_flutter/models/juno/charge/charge.dart';
import 'package:brickart_flutter/models/juno/charge/charge_detail.dart';
import 'package:brickart_flutter/models/juno/credit_card.dart';
import 'package:brickart_flutter/models/juno/credit_card_token.dart';
import 'package:brickart_flutter/models/juno/juno_token.dart';
import 'package:brickart_flutter/models/juno/payment/address_payment.dart';
import 'package:brickart_flutter/models/juno/payment/billing_payment.dart';
import 'package:brickart_flutter/models/juno/payment/credit_card_details.dart';
import 'package:brickart_flutter/models/juno/payment/payment.dart';
import 'package:brickart_flutter/models/shipping_address.dart';
import 'package:brickart_flutter/util/alerts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart' as dioForm;
import 'package:get/get.dart';

class JunoAPI extends GetObserver {
  bool prod;
  JunoAPI(this.prod);

  var urlPadraoSandbox = 'https://sandbox.boletobancario.com/';
  var urlPadrao = 'https://api.juno.com.br/';

  ///Conta Glaidson
  var tokenPrivadoSandBox =
      '92F96488D73972CCDDC47F68F59ED1A070ACC3A3E652A9E571E2C011F9A2C794';
  var tokenPublicoSandBox =
      'C044CA53FD66E221CB6C445A6B25583DA3222FC93B12701A76A0CB6DEFE04EA5';

  var clientId = 'h900Xg2aSDXuj8Ne';
  var clientSecret = '}6Y7eSFlmx80[XzXgVf;eVa@iPR-IJAN';

  ///Conta
  // var tokenPrivadoSandBox =
  //     'D55AF5AA54F28CACFA590C285E3CCA111E36115B11C7883C94D98B8CC3D4EEB0';
  // var tokenPublicoSandBox =
  //     '5234E874114F2FB192A78DDFD5180498F949F429AD8DA6C9370F8533F27E531F';
  //
  // var tokenPrivadoProd =
  //     '82562E9160B20D0892F5028AADB5B10226830E1677307DA0DEE6C6B9E93D7945';
  // var tokenPublicoProd =
  //     '3DCE93D0FD6DC9B60F582D8B90403FB051DDA5E11AEF193CBD37A04D739238CC014B10AB9B67D81A';
  //
  // var CLIENT_ID = 'HNWy9I4TKjrPYOse';///Prod
  // var CLIENT_SECRET = 'p*5aRpY+3~:C|6MMzFEyZ[hge^Qs?nOF';

  Future<JunoToken> tokenOAuth() async {
    try {
      String authorization =
          'Basic ' + base64Encode(utf8.encode('$clientId:$clientSecret'));
      print(authorization);


      Map<String, dynamic> body = {'grant_type': 'client_credentials'};

      dioForm.Dio dio = dioForm.Dio();
      dio.options.headers['content-type'] = 'application/x-www-form-urlencoded';
      dio.options.headers['authorization'] = authorization;

      dioForm.FormData formData = dioForm.FormData.fromMap(body);

      var response = await dio.post(
          '${prod ? urlPadrao : urlPadraoSandbox}'
          'authorization-server/oauth/token',
          data: formData);

      if (response.statusCode == 200) {
        print('succes');

        JunoToken junoToken = JunoToken.fromMap(response.data);

        print(junoToken);

        return junoToken;
      } else {
        alertSnack('Atenção', 'Não foi possível gerar o token!');
        return null;
      }
    } catch (e) {
      alertSnack('Atenção', 'Erro gerar o token!');
      print(e);
      return null;
    }
  }

  getHashCardGenerator(CreditCard creditCard) async {
    try {
      var url =
          'https://us-central1-brickart-app-dev.cloudfunctions.net/getCardHash';

      Map<String, dynamic> body = {
        'data': {
          'publicToken': tokenPublicoSandBox,
          "environment": prod ? 'production' : "sandbox",
          "holderName": creditCard.holderName,
          "cardNumber": creditCard.cardNumber.replaceAll(' ', ''),
          "securityCode": creditCard.securityCode,
          "expirationMonth": creditCard.expirationMonth,
          "expirationYear": '20${creditCard.expirationYear}'
        }
      };

      dioForm.Dio dio = dioForm.Dio();
      dio.options.headers['content-type'] = 'application/json';

      var response = await dio.post(url, data: body);

      if (response.statusCode == 200) {
        String hash = response.data['result'];
        return hash;
      } else {
        alertSnack('Atenção', 'Não foi possível gerar o hash do cartão!');
      }
    } catch (e) {
      alertSnack('Atenção', 'Erro ao gerar o hash do cartão!');
      print(e);
    }
  }

  Future<CreditCardToken> tokenizarCard(
      String hash, CreditCard creditCard, JunoToken junoToken) async {
    try {
      Map<String, dynamic> body = {'creditCardHash': hash};

      dioForm.Dio dio = dioForm.Dio();
      dio.options.headers['content-type'] = 'application/json';
      dio.options.headers['x-api-version'] = 2;
      dio.options.headers['authorization'] = 'Bearer ${junoToken.accessToken}';
      dio.options.headers['x-resource-token'] = tokenPrivadoSandBox;

      var response = await dio.post(
          '${prod ? urlPadrao : urlPadraoSandbox}'
          'api-integration/credit-cards/tokenization',
          data: body);

      if (response.statusCode == 200) {
        CreditCardToken cardToken = CreditCardToken.fromMap(response.data);

        cardToken.holderName = creditCard.holderName;
        cardToken.document = creditCard.document;
        cardToken.brand = creditCard.brand;
        cardToken.selected = true;

        LoginController loginController = Get.find();

        QuerySnapshot qr = await FirebaseFirestore.instance
            .collection('users')
            .doc(loginController.userLog.uid)
            .collection('card_token')
            .where('selected', isEqualTo: true)
            .get();

        if (qr.docs.length > 0) {
          CreditCardToken tk = CreditCardToken.fromMap(qr.docs.first.data());
          tk.selected = false;
          await FirebaseFirestore.instance
              .collection('users')
              .doc(loginController.userLog.uid)
              .collection('card_token')
              .doc(tk.creditCardId)
              .set(tk.toMap());
        }

        await FirebaseFirestore.instance
            .collection('users')
            .doc(loginController.userLog.uid)
            .collection('card_token')
            .doc(cardToken.creditCardId)
            .set(cardToken.toMap());

        return cardToken;
      } else {
        alertSnack('Atenção', 'Não foi possível validar o cartão!');
        return null;
      }
    } catch (e) {
      if (e.response.data['details'][0]['message'] != null) {
        alertSnack('Atenção', e.response.data['details'][0]['message']);
      } else {
        alertSnack('Atenção', 'Erro ao validar o cartão!');
      }
      print(e);
      return null;
    }
  }

  Future<String> createCharge(
      JunoToken junoToken, Charge charge, BillingCharge billingCharge) async {
    try {
      dioForm.Dio dio = dioForm.Dio();
      dio.options.headers['content-type'] = 'application/json';
      dio.options.headers['x-api-version'] = 2;
      dio.options.headers['authorization'] = 'Bearer ${junoToken.accessToken}';
      dio.options.headers['x-resource-token'] = tokenPrivadoSandBox;

      ChargeDetail chargeDetail = ChargeDetail();
      // Charge charge = Charge();
      // BillingCharge billing = BillingCharge();

      // charge.description = 'Cobrança de teste2';
      // charge.totalAmount = 40.0;
      // charge.dueDate = returnsFormattedDateAPI(DateTime.now());
      // charge.installments = 3;
      // charge.paymentTypes = new List();
      // charge.paymentTypes.add('CREDIT_CARD');
      // charge.paymentAdvance = true;
      //
      // billing.name = 'Glaidson Montanhini';
      // billing.document = '36241094807';

      chargeDetail.charge = charge;
      chargeDetail.billing = billingCharge;

      String jsonEnvio = json.encode(chargeDetail.toMap());

      var response = await dio.post(
          '${prod ? urlPadrao : urlPadraoSandbox}'
          'api-integration/charges',
          data: jsonEnvio);

      if (response.statusCode == 200) {
        String chargeId = response.data['_embedded']['charges'][0]['id'];
        return chargeId;
      } else {
        alertSnack('Atenção', 'Não foi possível gerar a cobrança!');
        return null;
      }
    } catch (e) {
      if (e.response.data['details'][0]['message'] != null) {
        alertSnack('Atenção', e.response.data['details'][0]['message']);
      } else {
        alertSnack('Atenção', 'Erro ao gerar a cobrança!');
      }
      return null;
    }
  }

  Future<bool> payCharge(JunoToken junoToken, String chargeId,
      ShippingAddress address, String creditCardId) async {
    try {
      dioForm.Dio dio = dioForm.Dio();
      dio.options.headers['content-type'] = 'application/json';
      dio.options.headers['x-api-version'] = 2;
      dio.options.headers['authorization'] = 'Bearer ${junoToken.accessToken}';
      dio.options.headers['x-resource-token'] = tokenPrivadoSandBox;

      Payment payment = Payment();
      payment.chargeId = chargeId;
      payment.billing = BillingPayment();
      payment.billing.email = address.email;
      payment.billing.address = AddressPayment();
      payment.billing.address.street = address.address;
      payment.billing.address.number = address.addressNumber;
      payment.billing.address.city = address.city;
      payment.billing.address.state = address.state.toUpperCase();
      payment.billing.address.postCode = address.zipCode.replaceAll('-', '');
      payment.billing.delayed = false;
      payment.creditCardDetails = CreditCardDetails();
      payment.creditCardDetails.creditCardId = creditCardId;
      //payment.creditCardDetails.creditCardHash = creditCardHash;

      String jsonEnvio = json.encode(payment.toMap());

      var response = await dio.post(
          '${prod ? urlPadrao : urlPadraoSandbox}'
          'api-integration/payments',
          data: jsonEnvio);

      if (response.statusCode == 200) {
        print(response.data);
        return true;
      } else {
        alertSnack('Atenção', 'Não foi possível realizar o pagamento!');
        return false;
      }
    } catch (e) {
      if (e.response.data['details'][0]['message'] != null) {
        alertSnack('Atenção', e.response.data['details'][0]['message']);
      } else {
        alertSnack('Atenção', 'Erro ao realizar o pagamento!');
        print(e);
      }
      return false;
    }
  }
}
