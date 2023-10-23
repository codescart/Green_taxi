import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:green_taxi/widget/green_Intro_widget.dart';
import 'package:green_taxi/widget/my_button.dart';
class DecisionScreen extends StatelessWidget {
  const DecisionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        width: double.infinity,
        child: Column(
          children: [
            greenIntroWidget(),

            const SizedBox(height: 50,),

            DecisionButton(
              'assets/driver.png',
              'Login As Driver',
                (){},
              Get.width*0.8
            ),
            const SizedBox(height: 20,),
            DecisionButton(
                'assets/customer.png',
                'Login As User',
                    (){},
                Get.width*0.8
            ),

          ],

        ),
      ),
    );
  }
}
