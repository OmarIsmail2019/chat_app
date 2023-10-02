

import 'package:chat/utils/colors.dart';
import 'package:flutter/material.dart';

class DefaultTextFormOfUser extends StatelessWidget {
  const DefaultTextFormOfUser({
    super.key,
    required this.sizeOf,
    required this.labelText,
    required this.initailValue,
    required this.prefix,
    this.validator,
    this.onSaved,
  });

  final Size sizeOf;
  final String labelText;
  final String initailValue;
  final IconData prefix;
  final String? Function(String?)? validator;
  final Function(String?)? onSaved;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      onSaved: onSaved,
      initialValue: initailValue,
      decoration: InputDecoration(
        prefixIcon: Icon(
          prefix,
          color: kAppBarColor,
        ),
        labelText: labelText,
        labelStyle: Theme.of(context).textTheme.labelLarge!.copyWith(
              fontSize: 20,
            ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.black,
          ),
          borderRadius: BorderRadius.circular(
            sizeOf.height * 0.04,
          ),
        ),
      ),
    );
  }
}