import 'package:brickart_flutter/API/juno_api.dart';
import 'package:brickart_flutter/controller/cart_controller.dart';
import 'package:brickart_flutter/controller/login_controller.dart';
import 'package:brickart_flutter/models/juno/charge/billing_charge.dart';
import 'package:brickart_flutter/models/juno/charge/charge.dart';
import 'package:brickart_flutter/models/juno/credit_card.dart';
import 'package:brickart_flutter/models/juno/credit_card_token.dart';
import 'package:brickart_flutter/models/juno/juno_token.dart';
import 'package:brickart_flutter/util/credit_card_util.dart';
import 'package:brickart_flutter/util/date_format.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class PaymentInformationController extends GetxController {
  CartController cartController = Get.find();
  LoginController loginController = Get.find();
  JunoAPI junoAPI = JunoAPI(false);

  var isLoading = false.obs;

  var analyzingCard = false.obs;
  var processingPayment = false.obs;

  var creditCard = CreditCard().obs;
  var cardToken = CreditCardToken().obs;

  var cardNumuber = ''.obs;

  var installments = ['1x', '2x', '3x'].obs;
  var installmentSelectedPosition = 0.obs;

  JunoToken _junoToken;

  var cardTokens = [].obs;

  @override
  void onInit() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(loginController.userLog.uid)
        .collection('card_token')
        .snapshots()
        .listen((value) {
      cardTokens.clear();
      QuerySnapshot querySnapshot = value;
      querySnapshot.docs.forEach((element) {
        CreditCardToken tk = CreditCardToken.fromMap(element.data());
        cardTokens.add(tk);
      });
      print(cardTokens);
    });

    FirebaseFirestore.instance
        .collection('users')
        .doc(loginController.userLog.uid)
        .collection('card_token')
        .where('selected', isEqualTo: true)
        .snapshots()
        .listen((event) {
      if (event.docs.length > 0) {
        cardToken.value = CreditCardToken.fromMap(event.docs.first.data());
      }
    });
    super.onInit();
  }

  bool get isValidNumberCard => isValidCard(creditCard.value.cardNumber);
  String get _cardBrand => brandCard(cardNumuber.value);

  bool get visa => _cardBrand == 'VISA' ? true : false;
  bool get masterCard => _cardBrand == 'MASTER CARD' ? true : false;
  bool get americanExpress => _cardBrand == 'AMERICAN EXPRESS' ? true : false;
  bool get dinersClub => _cardBrand == 'DINERS CLUB' ? true : false;
  bool get discover => _cardBrand == 'DISCOVER' ? true : false;
  bool get enRoute => _cardBrand == 'EN ROUTE' ? true : false;
  bool get hiperCard => _cardBrand == 'HIPER CARD' ? true : false;
  bool get amex => _cardBrand == 'amex' ? true : false;

  String validateName(String value) {
    if (GetUtils.isNullOrBlank(value)) {
      return 'Digite o nome do titular do cartão';
    }
    return null;
  }

  String validateCpf(String value) {
    if (GetUtils.isNullOrBlank(value)) {
      return 'Digite o CPF do titular do cartão';
    } else if (!GetUtils.isCpf(value)) {
      return 'Digite um CPF válido';
    }
    return null;
  }

  String validateNumberCard(String value) {
    if (GetUtils.isNullOrBlank(value)) {
      return 'Digite o número do cartão';
    } else if (!isValidNumberCard) {
      return 'Número de cartão inválido';
    }
    return null;
  }

  String validateExpirationDate(String value) {
    if (GetUtils.isNullOrBlank(value)) {
      return 'Digite a data de validade do cartão';
    } else if (value.length < 5) {
      return 'Digite a data corretamente';
    }
    return null;
  }

  String validateCVV(String value) {
    if (GetUtils.isNullOrBlank(value)) {
      return 'Digite o código de segurança do cartão';
    } else if (value.length < 3) {
      return 'Digite a data corretamente';
    }
    return null;
  }

  setDataExpiration(String value) {
    if (value.length > 2) {
      creditCard.value.expirationMonth = value.substring(0, 2);
      if (value.length == 5) {
        creditCard.value.expirationYear = value.substring(3, 5);
      }
    }
  }

  getHashCard() async {
    analyzingCard.value = true;
    CreditCardToken cardTokenNew = CreditCardToken();
    creditCard.value.brand = _cardBrand;
    if (_junoToken == null) {
      _junoToken = await junoAPI.tokenOAuth();
      if (_junoToken == null) {
        return;
      }
    }

    String hashCard = await junoAPI.getHashCardGenerator(creditCard.value);

    cardTokenNew =
        await junoAPI.tokenizarCard(hashCard, creditCard.value, _junoToken);

    if (cardTokenNew != null) {
      cardToken.value = cardTokenNew;
      Get.back();
    }
    analyzingCard.value = false;
  }

  completeOrder() async {
    processingPayment.value = true;
    if (_junoToken == null) {
      _junoToken = await junoAPI.tokenOAuth();
      if (_junoToken == null) {
        return;
      }
    }

    CartController cartController = Get.find();
    int installmentValue = int.parse(
        installments[installmentSelectedPosition.value].replaceAll('x', ''));

    Charge charge = Charge();
    charge.description = 'Compra  ${DateTime.now().toIso8601String()}';
    charge.amount = installmentValue < 2 ? cartController.total : null;
    charge.totalAmount = installmentValue > 1 ? cartController.total : null;
    charge.dueDate = returnsFormattedDateAPI(DateTime.now());
    charge.installments = installmentValue;
    charge.paymentTypes = [];
    charge.paymentTypes.add('CREDIT_CARD');
    charge.paymentAdvance = true;

    BillingCharge billingCharge = BillingCharge();
    billingCharge.name = cardToken.value.holderName;
    billingCharge.document =
        cardToken.value.document.replaceAll('.', '').replaceAll('-', '');

    String chargeId =
        await junoAPI.createCharge(_junoToken, charge, billingCharge);

    if (chargeId == null) {
      processingPayment.value = false;
      return;
    }
    bool payment = await junoAPI.payCharge(_junoToken, chargeId,
        cartController.address.value, cardToken.value.creditCardId);

    if (payment) {
      Get.offAllNamed('/confirme_order');
    }

    processingPayment.value = false;
  }

  selectCard(String creditCardId) async {
    CreditCardToken cdSelectedFalse =
        cardTokens.where((element) => element.selected == true).first;

    if (cdSelectedFalse != null) {
      cdSelectedFalse.selected = false;
      await _updateTokenFirestore(cdSelectedFalse);
    }

    CreditCardToken cdSelected = cardTokens
        .where((element) => element.creditCardId == creditCardId)
        .first;
    cdSelected.selected = true;

    await _updateTokenFirestore(cdSelected);
  }

  _updateTokenFirestore(CreditCardToken token) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(loginController.userLog.uid)
        .collection('card_token')
        .doc(token.creditCardId)
        .set(token.toMap());
  }

  deleteCard(String creditCardId) async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(loginController.userLog.uid)
        .collection('card_token')
        .doc(creditCardId)
        .delete();
  }
}
