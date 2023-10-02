import 'dart:developer';

import 'package:chat/features/layout/widgets/image_position_widget.dart';
import 'package:chat/utils/api.dart';
import 'package:chat/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashViewBody extends StatefulWidget {
  const SplashViewBody({super.key});

  @override
  State<SplashViewBody> createState() => _SplashViewBodyState();
}

class _SplashViewBodyState extends State<SplashViewBody> {
  bool isAnimatedImage = false;
  bool isAnimatedText = false;
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          systemNavigationBarColor: Colors.white,
        ),
      );
      setState(() {
        isAnimatedImage = true;
        isAnimatedText = true;
      });
    });

    Future.delayed(const Duration(seconds: 5), () {
      if (APIs.auth.currentUser != null) {
        log('\n User: ${APIs.auth.currentUser}');
        // function to navigate to the layout
        Navigator.pushNamedAndRemoveUntil(
          context,
          RoutesApp.layoutView,
          (route) => false,
        );
      } else {
        // function to navigate to the login
        Navigator.pushNamedAndRemoveUntil(
          context,
          RoutesApp.loginView,
          (route) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            AppImagePositionWidget(
              isAnimatedLogo: isAnimatedImage,
            ),
            AnimatedPositioned(
              top: MediaQuery.sizeOf(context).height * .45,
              width: MediaQuery.sizeOf(context).width * 0.35,
              right: isAnimatedText
                  ? MediaQuery.sizeOf(context).width * 0.25
                  : MediaQuery.sizeOf(context).width * -0.25,
              duration: const Duration(seconds: 3),
              child: Text(
                'We Chat',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 40,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
