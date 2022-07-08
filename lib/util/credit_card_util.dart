
import 'package:credit_card_validate/credit_card_validate.dart';
import 'package:get/get.dart';

bool isValidCard(String cardNum){
  if(cardNum == null)
    return false;
  return CreditCardValidator.isCreditCardValid(cardNumber: cardNum);
}

String brandCard(String cardNum){
  if(GetUtils.isNullOrBlank(cardNum))
    return '';
  else if (cardNum.startsWith('4')) {
    return 'VISA';
  }
  else if (cardNum.startsWith('51') || cardNum.startsWith('52')
      || cardNum.startsWith('53') || cardNum.startsWith('54')
      || cardNum.startsWith('55')) {
    return 'MASTER CARD';
  } else if (cardNum.startsWith('34') || cardNum.startsWith('37')) {
    return 'AMERICAN EXPRESS';
  } else if (cardNum.startsWith('30') ||
      cardNum.startsWith('36') || cardNum.startsWith('38')) {
    return 'DINERS CLUB';
  } else if (cardNum.startsWith('6011') || cardNum.startsWith('65')) {
    return 'DISCOVER';
  } else if (cardNum.startsWith('20') || cardNum.startsWith('21')) {
    return 'EN ROUTE';
  } else if (cardNum.startsWith('6062')) {
    return 'HIPER CARD';
  } else if (cardNum.startsWith('50')) {
    return 'Aura';
  } else {
    return '';
  }
}