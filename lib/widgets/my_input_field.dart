import 'package:flutter/material.dart';

class MyInputField extends StatelessWidget {
  final bool isEmailOrCpfField;
  final bool isPasswordField;
  final Widget prefixIcon;
  final String label;
  final String placeholder;
  final int maxLen;
  final Function onChange;
  final String? Function(String?)? validateFunction;
  const MyInputField({
    super.key,
    required this.placeholder,
    required this.label,
    this.isPasswordField = false,
    this.isEmailOrCpfField = false,
    required this.onChange,
    required this.validateFunction,
    this.maxLen = 0,
    this.prefixIcon = const SizedBox.shrink(),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
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
          TextFormField(
            maxLines: isPasswordField ? 1 : null,
            maxLength: maxLen == 0 ? null : maxLen,
            obscureText: isPasswordField,
            onChanged: ((value) => onChange(value)),
            validator: validateFunction,
            decoration: InputDecoration(
                prefixIcon: isPasswordField
                    ? const Icon(
                        Icons.lock,
                        color: Color(0xFF0A6D92),
                      )
                    : prefixIcon,
                labelText: label,
                labelStyle: const TextStyle(color: Color(0xFF0A6D92)),
                hintText: placeholder,
                border: InputBorder.none,
                errorStyle: const TextStyle(
                    color: Colors.red, fontWeight: FontWeight.bold),
                contentPadding: const EdgeInsets.all(0)),
          )
        ],
      ),
    );
  }
}
