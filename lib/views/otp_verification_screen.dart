import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:green_taxi/widget/green_Intro_widget.dart';
import 'package:green_taxi/widget/otp_Verification_widget.dart';
class OtpVerificationScreen extends StatefulWidget {
  // final String? phoneNumber;
  // OtpVerificationScreen(this.phoneNumber);


  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [



            Stack(
              children: [
                greenIntroWidget(),

                Positioned(
                  top: 60,
                  left: 30,
                  child: InkWell(
                    onTap: (){
                      Get.back();
                    },
                    child: Container(
                      width:45,
                      height: 45,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0x8AFFFFFF),
                      ),
                      child: Icon(Icons.arrow_back,
                        color: Colors.greenAccent,size: 20,),
                    ),
                  ),
                )
              ],
            ),

            SizedBox(
                height: 50),


            otpVerificationWidget(),



          ],
        ),
      ),
    );
  }
}
