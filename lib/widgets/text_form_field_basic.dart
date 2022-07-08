import 'package:brickart_flutter/util/textstyle_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class TextFormFieldBasic extends StatelessWidget {
  final String label;
  final String hint;
  final Color colorText;
  final bool autocorrect;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final int maxLength;
  final Function validator;
  final Function onChanged;
  final TextEditingController controller;
  final TextInputType typeText;
  final TextCapitalization textCapitalization;
  final List inputFormatters;
  final Widget suffixIcon;
  final bool promoCode;

  TextFormFieldBasic(this.label, this.hint,
      {this.colorText = Colors.black,
      this.autocorrect = false,
      this.obscureText = false,
      this.enabled = true,
      this.readOnly = false,
      this.maxLength,
      this.typeText = TextInputType.text,
      this.validator,
      this.onChanged,
      this.controller,
      this.textCapitalization = TextCapitalization.none,
      this.inputFormatters,
      this.suffixIcon,
      this.promoCode});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 3),
      child: TextFormField(
        style: TextStyle(color: colorText),
        validator: validator,
        autocorrect: autocorrect,
        obscureText: obscureText,
        enabled: enabled,
        onChanged: onChanged,
        textAlign: promoCode == false ? TextAlign.center : TextAlign.start,
        inputFormatters: inputFormatters,


        decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Get.theme.primaryColor),
            ),
            labelText: label,
            labelStyle: kTextFieldLabel,
            hintText: hint,
            hintStyle: kTextFieldHintText,
            suffixIcon: suffixIcon),
        controller: controller,
        readOnly: readOnly,
        keyboardType: typeText,
        maxLength: maxLength,
        textCapitalization: textCapitalization,
      ),
    );
  }
}
