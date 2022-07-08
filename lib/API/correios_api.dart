import 'dart:convert';

import 'package:brickart_flutter/controller/cart_controller.dart';
import 'package:brickart_flutter/models/correios.dart';
import 'package:brickart_flutter/models/shipping.dart';
import 'package:brickart_flutter/models/shipping_address.dart';
import 'package:brickart_flutter/util/alerts.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:xml2json/xml2json.dart';

class CorreiosAPI extends GetxController {
  /*
   Serviços:
   04014 SEDEX à vista
   04510 PAC à vista
   04782 SEDEX 12 ( à vista)
   04790 SEDEX 10 (à vista)
   04804 SEDEX Hoje à vista

   Formatos:
    1 – Formato caixa/pacote
    2 – Formato rolo/prisma
    3 – Envelope
   */

  static Future<Correios> getCorreios() async {
    try {
      var isLoading = false.obs;
      CartController cartController = Get.find();

      Shipping shipping = cartController.shipping.value;
      ShippingAddress shippingAddress = cartController.address.value;

      double weight = cartController.quantity.value * shipping.weight;

      var url = 'http://ws.correios.com.br/calculador/'
          'CalcPrecoPrazo.asmx/CalcPrecoPrazo?'
          'nCdEmpresa='
          '&sDsSenha='
          '&nCdServico=${shipping.postOfficeServiceType}'
          '&sCepOrigem=04626911'
          '&sCepDestino=${shippingAddress.zipCode.replaceAll('-', '')}'
          '&nVlPeso=$weight'
          '&nCdFormato=${shipping.format}'
          '&nVlComprimento=${shipping.length}'
          '&nVlAltura=${shipping.height}'
          '&nVlLargura=${shipping.width}'
          '&nVlDiametro=${shipping.diameter}'
          '&sCdMaoPropria=${shipping.selfhand}'
          '&nVlValorDeclarado=0'
          '&sCdAvisoRecebimento=${shipping.noticeOfReceipt}';

      isLoading.value = true;
      Dio dio = Dio();
      var response = await dio.get(url);
      isLoading.value = false;

      if (response.statusCode == 200) {
        Xml2Json xml2json = new Xml2Json();
        xml2json.parse(response.data);
        var jsondata = xml2json.toGData();
        var data = json.decode(jsondata);

        Correios correios =
            Correios.fromMap(data['cResultado']['Servicos']['cServico']);

        return correios;
      } else {
        alertSnack('Atenção', 'Não foi possível calcular o frete!');
        print('fail');
        return null;
      }
    } catch (e) {
      alertSnack('Atenção', 'Erro ao calcular o frete!');
      print(e);
      return null;
    }
  }
}
