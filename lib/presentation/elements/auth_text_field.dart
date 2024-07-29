import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../configurations/front_end_configs.dart';

class AuthTextField extends StatelessWidget {
  final String hint;
  final bool isPasswordField;
  final bool visible;
  final Function(String) validator;
  final TextEditingController controller;
  final VoidCallback onPwdTap;
  final bool cVisible;
  final int lines;
  bool isNumberField;
  final TextInputType keyBoardType;

  AuthTextField(
      {required this.hint,
      this.isNumberField = false,
      required this.validator,
      required this.controller,
      required this.onPwdTap,
      this.isPasswordField = false,
      this.visible = true,
      this.lines = 1,
      this.keyBoardType = TextInputType.text,
      this.cVisible = false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        validator: (val) => validator(val!),
        controller: controller,
        keyboardType: keyBoardType,
        maxLines: lines,
        inputFormatters: isNumberField
            ? [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(9),
              ]
            : null,
        obscureText: !visible,
        style: const TextStyle(
            color: Colors.black,
            fontSize: 15,
            letterSpacing: 0.5,
            fontWeight: FontWeight.w500),
        cursorColor: FrontEndConfigs.kGreyColor.withOpacity(0.2),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 17, horizontal: 15),
          hintText: hint,
          hintStyle: TextStyle(
            color: FrontEndConfigs.kGreyColor.withOpacity(0.6),
            fontSize: 15,
            letterSpacing: 0.5,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xffBEBEBE)),
            borderRadius: BorderRadius.circular(7),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xffBEBEBE)),
            borderRadius: BorderRadius.circular(7),
          ),
        ));
  }
}
