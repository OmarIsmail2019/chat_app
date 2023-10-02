import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../utils/colors.dart';

class ElevatedButtonWidget extends StatelessWidget {
  const ElevatedButtonWidget({
    super.key,
    required this.sizeOf,
    required this.onPressed,
  });

  final Size sizeOf;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: kTextColor,
        shape: const StadiumBorder(),
        fixedSize: Size(
          sizeOf.width * 0.4,
          sizeOf.height * 0.05,
        ),
      ),
      onPressed: onPressed,
      icon: const Icon(
        FontAwesomeIcons.pen,
        size: 20,
      ),
      label: const Text(
        'Update',
        style: TextStyle(
          fontSize: 20,
        ),
      ),
    );
  }
}