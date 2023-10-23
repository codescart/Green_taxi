// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:green_taxi/controller/auth_controller.dart';
import 'package:green_taxi/views/decision_screen/decission_screen.dart';
import 'package:green_taxi/views/driver/profile_setup.dart';
import 'package:green_taxi/views/home.dart';
import 'package:green_taxi/views/login_screen.dart';
import 'package:green_taxi/views/otp_verification_screen.dart';
import 'package:green_taxi/views/payments_screen.dart';
import 'package:green_taxi/widget/profile_settings.dart';


Future<void> main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // AuthController authController = Get.put(AuthController());
    // authController.decideRoute();

    final  textTheme = Theme.of(context).textTheme;

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
    textTheme: GoogleFonts.poppinsTextTheme(textTheme),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home:  DriverProfileSetup(),
    );
  }
}

