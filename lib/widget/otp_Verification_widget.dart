import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:green_taxi/untlis/app_constants.dart';
import 'package:green_taxi/widget/pinput_widget.dart';
import 'package:green_taxi/widget/text_widget.dart';


    Widget  otpVerificationWidget(){
  return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Expanded(
        child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textWidget(text: AppConstants.phoneVerification, fontWeight: FontWeight.normal, color: Colors.blue, textWidget: ''),
              textWidget(text: AppConstants.enterOTP,
                  fontsize: 22,fontWeigh: FontWeight.bold, fontWeight: FontWeight.normal, color: Colors.green, textWidget: ''),


              const SizedBox(
                height: 40,
              ),

              Container(
                width: Get.width,
                  height: 50,
                  child: RoundedWithShadow()),

              const SizedBox(
                height:40 ,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal:20 ),
                child:  RichText(
                    textAlign: TextAlign.start,
                    text:TextSpan(
                        style: GoogleFonts.poppins(color: Colors.black,fontSize:12),
                        children: [
                          TextSpan(
                            text: AppConstants.resendCode +" ",
                          ),
                          TextSpan(
                            text: " 10 seconds",
                            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                          ),


                ]
                    ),
              ),


              ),
            ]
           ),
      ),

  );

}