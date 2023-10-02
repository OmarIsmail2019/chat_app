import 'package:chat/features/auth/view/login_view.dart';
import 'package:chat/features/chatting/view/chat_view.dart';
import 'package:chat/features/layout/model/user_model.dart';
import 'package:chat/features/layout/view/layout_screen.dart';
import 'package:chat/features/spalsh/view/splash_view.dart';
import 'package:flutter/material.dart';

class RoutesApp {
  static const String splashView = '/';
  static const String loginView = '/login';
  static const String layoutView = '/layout';
  static const String chatView = '/chat';
}

UserModel? userModel;

class RoutesAppGenerator {
  static Route<dynamic> getRoutesApp(RouteSettings settings) {
    switch (settings.name) {
      case RoutesApp.splashView:
        return MaterialPageRoute(builder: (context) => const SplashView());
      case RoutesApp.loginView:
        return MaterialPageRoute(builder: (context) => const LoginScreen());
      case RoutesApp.layoutView:
        return MaterialPageRoute(builder: (context) => const LayOutScreen());
      case RoutesApp.chatView:
        return MaterialPageRoute(
            builder: (context) => ChatView(
                  userModel: userModel!,
                ));
      // case RoutesAppApp.layout:
      //   return MaterialPageRoute(builder: (context) => const LayOut());
      // case RoutesAppApp.editProfile:
      //   return MaterialPageRoute(builder: (context) => const EditProfileView());
      default:
        return unDefineRoute();
    }
  }

  static Route<dynamic> unDefineRoute() {
    return MaterialPageRoute(
        builder: (context) => Scaffold(
            appBar: AppBar(
              title: const Text('Not Found'),
            ),
            body: const Center(
              child: Text('Not Found'),
            )));
  }
}
