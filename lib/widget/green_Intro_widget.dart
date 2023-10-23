import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:green_taxi/untlis/app_Colors.dart';
import 'package:green_taxi/widget/customshape_widget.dart';

Widget greenIntroWidget(){
  return Container(
      width: Get.width,
    decoration: BoxDecoration(
      image: DecorationImage(
          image: AssetImage("assets/widget.png"),
          fit: BoxFit.cover
      ),
    ),
    height: Get.height*0.7,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset('assets/icons.png'),
        const SizedBox(
          height: 10,
        ),
      ],
    ),

  );
}


Widget greenIntroWidgetWithoutLogos({required String title}){
  CustomClipper<Path>? clipper;
  return Container(
    width: Get.width,
    height: Get.height,
    // height: Get.height,
      margin: EdgeInsets.only(bottom: Get.height*0.06),
      // child: Center(
      //   child: Text("Profile Settings",style: GoogleFonts.poppins(
      //       fontSize: 24,fontWeight: FontWeight.w500,color: Color(0xFF00796B)),),
      // ),
    // height: Get.height*0.7,

  child:ClipPath(
      clipper: CustomShape(),
      child: Container(
        width:Get.width ,
        color: Colors.green,
        child: Padding(
          padding: const EdgeInsets.only(left: 60, top: 0,bottom: 60,right: 70),
          child: Center(
            child: Text(
              'Let Get Started!',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),

            ),
          ),
        ),
      ),
  ),

  );
}
