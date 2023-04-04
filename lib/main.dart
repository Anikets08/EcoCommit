import 'package:camera/camera.dart';
import 'package:ecocommit/firebase_options.dart';
import 'package:ecocommit/screens/camera.dart';
import 'package:ecocommit/screens/congratulations.dart';
import 'package:ecocommit/screens/home.dart';
import 'package:ecocommit/screens/onboarding.dart';
import 'package:ecocommit/screens/signin.dart';
import 'package:ecocommit/screens/signup.dart';
import 'package:ecocommit/screens/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

late List<CameraDescription> cameras;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  cameras = await availableCameras();
  runApp(const MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EcoCommit',
      theme: ThemeData(fontFamily: GoogleFonts.montserrat().fontFamily),
      navigatorKey: navigatorKey,
      initialRoute: "/",
      debugShowCheckedModeBanner: false,
      routes: {
        "/": (context) => const SplashScreen(),
        "/onboarding": (context) => const OnBoardingScreen(),
        "/signin": (context) => const SigninScreen(),
        "/signup": (context) => const SignupScreen(),
        "/home": (context) => const HomeScreen(),
        "/camera": (context) => const CameraScreen(),
        "/congratulations": (context) => const CongratulationsScreen(),
      },
    );
  }
}
