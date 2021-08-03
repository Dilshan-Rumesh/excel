import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  const RoundedButton({
    Key key,
    this.text,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      width: size.width * 0.5,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(17),
        child: FlatButton(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 40),
          color: Colors.green,
          onPressed: onPressed,
          child: Text(
            text,
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
