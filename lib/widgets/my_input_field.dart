import 'package:flutter/material.dart';

class MyInputField extends StatelessWidget {
  final bool isEmailOrCpfField;
  final bool isPasswordField;
  final String label;
  final String placeholder;
  final Function onChange;
  const MyInputField({
    super.key,
    required this.placeholder,
    required this.label,
    this.isPasswordField = false,
    this.isEmailOrCpfField = false,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16)),
          boxShadow: [
            BoxShadow(
              blurRadius: 32,
              color: Colors.black.withOpacity(.1),
            )
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          TextField(
            obscureText: isPasswordField,
            onChanged: ((value) => onChange(value)),
            decoration: InputDecoration(
                hintText: placeholder,
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(0)),
          ),
        ],
      ),
    );
  }
}
