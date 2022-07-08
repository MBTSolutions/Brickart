import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

var maskCard = new MaskTextInputFormatter(
    mask: '#### #### #### ####', filter: {"#": RegExp(r'[0-9]')});

var maskExpirationDate = new MaskTextInputFormatter(
    mask: '##/##', filter: {"#": RegExp(r'[0-9]')});

var maskCVV =
    new MaskTextInputFormatter(mask: '###', filter: {"#": RegExp(r'[0-9]')});

var maskCellPhone = new MaskTextInputFormatter(
    mask: '(##) #####-####', filter: {"#": RegExp(r'[0-9]')});

var maskZipCode = new MaskTextInputFormatter(
    mask: '#####-###', filter: {"#": RegExp(r'[0-9]')});

var maskCpf = new MaskTextInputFormatter(
    mask: '###.###.###-##', filter: {"#": RegExp(r'[0-9]')});
