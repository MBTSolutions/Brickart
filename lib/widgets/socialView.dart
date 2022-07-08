import '../util/textstyle_constant.dart';
import 'package:flutter/material.dart';

class SocialView extends StatelessWidget {
  final Color buttonColor;
  final String iconAsset;
  final String text;
  final String buttonIcon;
  final String buttonText;
  const SocialView({
    this.buttonColor,
    this.text,
    this.buttonIcon,
    this.buttonText,
    this.iconAsset,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Image.asset(
              iconAsset,
              fit: BoxFit.contain,
              width: 160,
              height: 160,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              text,
              textAlign: TextAlign.center,
              style: kTextFieldLabel.copyWith(
                color: Color(0xff5B5B5B),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              height: 52,
              decoration: BoxDecoration(
                color: buttonColor,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    buttonIcon,
                    width: 25,
                    height: 25,
                  ),
                  SizedBox(width: 8,),
                  Text(
                    buttonText,
                    style: connectSocialText,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
