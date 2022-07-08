import 'package:brickart_flutter/controller/promo_code_controller.dart';
import 'package:brickart_flutter/widgets/app_bar_back.dart';
import 'package:brickart_flutter/widgets/button_widget.dart';
import 'package:brickart_flutter/widgets/text_form_field_basic.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AddPromoCodeScreen extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  final promoCodeController = PromoCodeController();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      resizeToAvoidBottomInset: true,
        appBar: AppBarBack(title: 'Promo Code',
          ),

        body: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 1,

            child:Column(

            mainAxisAlignment: MainAxisAlignment.start,


            children: [

              Container(
                //
//                 width:MediaQuery.of(context).size.width * 1,
//                 height:MediaQuery.of(context).size.height * 0.35,
                color: Colors.red,

                  child:Image.asset('assets/images/buzz-img.png',),

                //fit: BoxFit.fill,),

              ),
              SizedBox(height: 20,),

              Center(
                child:Container(
                  child: Text('Qual o seu cupom de desconto', style: TextStyle(fontFamily: 'Poppins', color: Colors.black, fontWeight: FontWeight.bold),),
                ),
              ),
              Center(
                child:Container(
           //     margin: EdgeInsets.only(left: 20,),

                  child: Text('POR FAVOR , ADICIONAR UM CUPOM DE DESCONTO', style: TextStyle(fontFamily: 'Poppins', color: Colors.grey),),
                ),),

              Center(
                child:Container(
                  //     margin: EdgeInsets.only(left: 20,),

                  child: Text('PARA AVANÇAR', style: TextStyle(fontFamily: 'Poppins', color: Colors.grey, fontWeight: FontWeight.normal),),
                ),),



              Form(

                key: formKey,
                child: SafeArea(
                  child: Stack(
                    children: [
                      Positioned(
                        child: Opacity(
                          opacity: promoCodeController.checkingPromo.value ? 0.3 : 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [

                              Center(
                                child:Container(
                                  width: 150,
                                  child:
                                  TextFormFieldBasic(
                                    '',
                                    'Cupom de desconto',
                                    promoCode: false,

                                    onChanged: (value) {
                                      promoCodeController.promoCode.value = value;
                                    },

                                    enabled: promoCodeController.checkingPromo.value
                                        ? false
                                        : true,
                                    textCapitalization: TextCapitalization.characters,
                                    validator: _promoCodeValidator,
                                  ),
                                ),
                              ),



                              SizedBox(height:30),
                              Container(
                                width: MediaQuery.of(context).size.width * 1,

                                child:ButtonWidget(
                                  color: Get.theme.primaryColor,
                                  text: 'Apply',
                                  textColor: Colors.white,
                                  onPressed: promoCodeController
                                      .isNotEmptyPromoCode &&
                                      !promoCodeController.checkingPromo.value
                                      ? _applyCode
                                      : null,
                                ),),
                            ],
                          ),

                        ),
                      ),
                      SizedBox(height:70),

                      promoCodeController.checkingPromo.value
                          ? Positioned(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Checking your code'),
                              SizedBox(
                                height: 12,
                              ),
                              CircularProgressIndicator(),
                            ],
                          ),
                        ),
                      )
                          : Container()
                    ],
                  ),
                ),
              ),]

        ),),), ));



  }

  _applyCode() {
    if(formKey.currentState.validate()) {
      promoCodeController.verifyPromoCode();
    }
  }

  String _promoCodeValidator(String value) {
    if(GetUtils.isNullOrBlank(value)){
      return 'Digite o cupom';
    }
    else if(!GetUtils.hasMatch(value, r'^\w+$')){
      return 'Valores inválidos (!@#%&*.,)';
    }
    return null;
  }
}
