import 'package:chat/firebase_options.dart';
import 'package:chat/utils/colors.dart';
import 'package:chat/utils/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.immersiveSticky,
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) {
    _initializeFirebase();
    runApp(const MyApp());
  });
}

Future<void> _initializeFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat',
      theme: ThemeData.light().copyWith(
        appBarTheme: AppBarTheme(
          iconTheme: const IconThemeData(
            color: kTextColor,
            size: 22,
          ),
          elevation: 7,
          centerTitle: true,
          backgroundColor: kAppBarColor,
          shadowColor: kShadowColor,
          titleTextStyle: GoogleFonts.aladin(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: kTextColor,
          ),
        ),
        scaffoldBackgroundColor: Colors.white,
        
        textTheme: GoogleFonts.aladinTextTheme(),
      ),
      onGenerateRoute: RoutesAppGenerator.getRoutesApp,
      initialRoute: RoutesApp.splashView,
    );
  }
}
