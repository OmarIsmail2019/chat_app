import 'package:flutter/material.dart';

class ButtonPostionAnimationWidget extends StatelessWidget {
  const ButtonPostionAnimationWidget({
    super.key,
    required this.isAnimatedButton,
    required this.size,
    required this.onPressed,
  });

  final bool isAnimatedButton;
  final Size size;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(seconds: 2),
      bottom: isAnimatedButton ? size.height * .13 : -size.height * .13,
      left: size.width * 0.05,
      width: size.width * 0.9,
      height: size.height * 0.065,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white24,
          shape: const StadiumBorder(),
        ),
        onPressed: onPressed,
        icon: Image.asset(
          'assets/app_icon/google.png',
          height: size.height * .05,
        ),
        label: Text(
          'Sign in with Google',
          style: Theme.of(context).textTheme.labelLarge!.copyWith(
                fontSize: 20,
              ),
        ),
      ),
    );
  }
}
