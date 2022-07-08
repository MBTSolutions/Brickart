import 'package:flutter/material.dart';

class ArenaView extends StatelessWidget {
  const ArenaView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xffE5E5E5),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 5,
          crossAxisSpacing: 5,
        ),
        itemBuilder: (context, index) => Container(
          child: Image.asset(
            'assets/gridimage/image${index + 1}.png',
            fit: BoxFit.cover,
          ),
        ),
        itemCount: 9,
      ),
    );
  }
}
