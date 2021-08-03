import 'package:first_dgapp/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';

class RoundedPasswordInputField extends StatelessWidget {
  final Function onChanged;
  final String hintText;
  final IconData icon;
  const RoundedPasswordInputField({
    Key key,
    this.hintText,
    this.icon,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldWidget(
      child: TextField(
        obscureText: true,
        // autofocus: true,
        onChanged: onChanged,
        decoration: InputDecoration(
            border: InputBorder.none,
            icon: Icon(
              icon,
              color: Color(0XFFB0BEC5),
            ),
            hintText: hintText),
      ),
    );
  }
}
