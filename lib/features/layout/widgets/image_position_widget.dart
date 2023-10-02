import 'package:flutter/material.dart';

class AppImagePositionWidget extends StatelessWidget {
  const AppImagePositionWidget({
    super.key,
    required this.isAnimatedLogo,
  });

  final bool isAnimatedLogo;

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(seconds: 2),
      top: MediaQuery.sizeOf(context).height * .13,
      width: MediaQuery.sizeOf(context).width * 0.5,
      right: isAnimatedLogo
          ? MediaQuery.sizeOf(context).width * 0.25
          : -MediaQuery.sizeOf(context).width * 0.25,
      child: Image.asset('assets/app_icon/chat.png'),
    );
  }
}
