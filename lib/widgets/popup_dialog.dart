import '../util/textstyle_constant.dart';
import 'package:flutter/material.dart';

import 'button_widget.dart';

class PopupDialog extends StatelessWidget {
  const PopupDialog({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Stack(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width - 20,
              height: MediaQuery.of(context).size.height - 100,
              color: Colors.white,
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: ListView(
                        children: <Widget>[
                          Image.asset(
                            'assets/images/popup.png',
                            fit: BoxFit.fitWidth,
                            height: 250,
                            width: double.infinity,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Arena final Libertadores 2019',
                            style: kTextFieldLabel,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum d',
                            textAlign: TextAlign.justify,
                            style:
                                homeSubTitle.copyWith(color: Color(0xff4B4B4B)),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            'Photo by',
                            style: px12NormalBlack.copyWith(
                                color: Color(0xff4B4B4B)),
                          ),
                          Text(
                            'James McAvoy',
                            style: drawerMenuTextStyle.copyWith(
                                color: Color(0xff4B4B4B)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ButtonWidget(
                    textColor: Colors.white,
                    color: Theme.of(context).primaryColor,
                    text: 'SELECIONAR FOTO',
                  )
                ],
              ),
            ),
            Positioned(
                top: -10,
                right: -10,
                child: IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    })),
          ],
        ),
      ),
    );
  }
}
