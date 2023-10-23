import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:green_taxi/views/add_payment_card_screen.dart';
import 'package:green_taxi/widget/green_Intro_widget.dart';



class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {

  String cardNumber = '55555 55555 55555 44444';
  String expiryDate = '12/55';
  String cardHolderName = 'Uttar Pradesh';
  String cvvCode = '123';
  bool isCvvFocused = false ;
  bool useGlassMorphism = false ;
  bool useBackgroundImage = false ;
  OutlineInputBorder? border;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void iniState(){
    border = OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey.withOpacity(0.7),
        width: 2.0,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: Get.width,
        height: Get.height,
        child: Stack(
          children: <Widget>[
            greenIntroWidgetWithoutLogos(title: 'My Card'),

            Positioned(
              top:120,
              left: 0,
              right: 0,
              bottom: 80,
              child: ListView.builder(
                shrinkWrap: true,
                itemBuilder: (ctx,i)=> CreditCardWidget(
                  cardBgColor: Colors.black,
                  cardNumber: cardNumber,
                  expiryDate: expiryDate,
                  cardHolderName: cardHolderName,
                  cvvCode: cvvCode,
                  bankName:'',
                  showBackView: isCvvFocused,
                  obscureCardNumber: true,
                  obscureCardCvv:true,
                  isHolderNameVisible:true,
                  isSwipeGestureEnabled:true,
                  onCreditCardWidgetChange:
                      (CreditCardBrand creditCardBrand){},

                ),itemCount: 10,),

            ),

            Positioned(
              bottom: 10,
              right: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("Add new card",style: GoogleFonts.poppins(fontSize: 18,fontWeight: FontWeight.w500,color: Colors.green),
                  ),

                  SizedBox(width: 10,),

                  FloatingActionButton(onPressed: (){

                    Navigator.push(context, MaterialPageRoute(builder: (context)=>AddPaymentCardScreen()));

                  },child: Icon(Icons.arrow_forward,color: Colors.white,),backgroundColor: Colors.green,
                  )
                ],
              ),
              ),
            ],
        ),
        ),


    );
  }
}




