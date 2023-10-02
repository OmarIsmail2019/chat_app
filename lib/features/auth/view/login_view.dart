import 'dart:developer';

import 'package:chat/features/auth/view_model/auth_google.dart';
import 'package:chat/features/layout/widgets/button_postion_widget.dart';
import 'package:chat/features/layout/widgets/image_position_widget.dart';
import 'package:chat/utils/api.dart';
import 'package:chat/utils/dialogs.dart';
import 'package:chat/utils/routes.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isAnimatedLogo = false;
  bool isAnimatedButton = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(milliseconds: 500),
      () {
        setState(() {
          isAnimatedLogo = true;
          isAnimatedButton = true;
        });
      },
    );
  }

  _loginWithGoogleFunc() {
    Dialogs.showProgressBar(context);
    signInWithGoogle(context).then(
      (user) async {
        Navigator.pop(context);
        if (user != null) {
          log('\nUser: ${user.user}');
          log('\nUserAdditionalUserInfo: ${user.additionalUserInfo}');
          if ((await APIs.userExist())) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              RoutesApp.layoutView,
              (route) => false,
            );
          } else {
            await APIs.createUser().then((value) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                RoutesApp.layoutView,
                (route) => false,
              );
            });
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Welcome to Chatting',
        ),
      ),
      body: Stack(
        children: [
          AppImagePositionWidget(
            isAnimatedLogo: isAnimatedLogo,
          ),
          ButtonPostionAnimationWidget(
            onPressed: () {
              _loginWithGoogleFunc();
            },
            isAnimatedButton: isAnimatedButton,
            size: size,
          ),
        ],
      ),
    );
  }
}
