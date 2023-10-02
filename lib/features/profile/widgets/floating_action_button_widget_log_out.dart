import 'package:chat/utils/api.dart';
import 'package:chat/utils/colors.dart';
import 'package:chat/utils/dialogs.dart';
import 'package:chat/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FloatingActionButtonLogOutWidget extends StatelessWidget {
  const FloatingActionButtonLogOutWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      backgroundColor: kAppBarColor,
      icon: const Icon(FontAwesomeIcons.arrowRightFromBracket),
      onPressed: () async {
        Dialogs.showProgressBar(context);
        await APIs.auth.signOut().then((value) async {
          await GoogleSignIn().signOut().then((value) {
            // to hide progress indicator
            Navigator.pop(context);

            // to go home screen
            Navigator.pop(context);

            // to navigate to splsh screen
            Navigator.pushNamedAndRemoveUntil(
              context,
              RoutesApp.splashView,
              (route) => false,
            );
          });
        });
      },
      label: const Text(
        'LogOut',
        style: TextStyle(
          fontSize: 20,
        ),
      ),
    );
  }
}
