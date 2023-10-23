import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:green_taxi/views/otp_verification_screen.dart';

import '../widget/green_Intro_widget.dart';
import '../widget/login_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final countryPicker = const  FlCountryCodePicker();

  CountryCode countryCode = const CountryCode(name: 'India', code: 'In', dialCode: '+91');

  onSubmit(String? input){
    // Get.to(()=>OtpVerificationScreen(countryCode.dialCode+input!));

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Container(
        width: Get.width,
        height: Get.height,
        child:SingleChildScrollView (
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

        greenIntroWidget(),

          const SizedBox(height: 50,),

          loginWidget(context ,countryCode, () async {
            final code = await countryPicker.showPicker(context: context);
            // Null check
            if (code != null) countryCode = code;
            setState(() {

            });
          },onSubmit),
        ],
      ),
    ),
      ),
    );

  }
}
