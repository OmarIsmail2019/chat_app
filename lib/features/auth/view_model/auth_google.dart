import 'dart:developer';
import 'dart:io';

import 'package:chat/utils/api.dart';
import 'package:chat/utils/dialogs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<UserCredential?> signInWithGoogle(context) async {
  // Trigger the authentication flow
  try {
    await InternetAddress.lookup('google.com');
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await APIs.auth.signInWithCredential(credential);
  } on Exception catch (e) {
    log('\n signinGoogle: $e');
    Dialogs.showSnackBar(context, 'Something went wrong please check internet');
    return null;
  }
}
