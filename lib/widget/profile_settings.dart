import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:green_taxi/widget/green_Intro_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geocoding/geocoding.dart' as geoCoding;

class ProfileSettingScreen extends StatefulWidget {
  const ProfileSettingScreen({super.key});

  @override
  State<ProfileSettingScreen> createState() => _ProfileSettingScreenState();
}

class _ProfileSettingScreenState extends State<ProfileSettingScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController homeController = TextEditingController();
  TextEditingController businessController = TextEditingController();
  TextEditingController shopController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  // AuthController authController = Get.find<AuthController>();

  final ImagePicker _picker = ImagePicker();
  File? selectedImage;

  getImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      selectedImage = File(image.path);
      setState(() {});
    }
  }

 late LatLng homeAddress;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: Get.height * 0.3,
              child: Stack(
                children: [
                  greenIntroWidgetWithoutLogos(title: ''),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: InkWell(
                      onTap: () {
                        getImage(ImageSource.camera);
                      },
                      child: selectedImage == null
                          ? Container(
                              width: 100,
                              height: 100,
                              margin: EdgeInsets.only(bottom: 2),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0x99FFFFFF)),
                              child: Center(
                                child: Icon(
                                  Icons.camera_alt_outlined,
                                  size: 40,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          : Container(
                              width: 100,
                              height: 100,
                              margin: EdgeInsets.only(bottom: 5),
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: FileImage(selectedImage!),
                                    fit: BoxFit.fill,
                                  ),
                                  shape: BoxShape.circle,
                                  color: Color(0x99FFFFFF)),
                              child: Center(
                                child: Icon(
                                  Icons.camera_alt_outlined,
                                  size: 40,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      style: GoogleFonts.poppins(fontSize: 14,fontWeight: FontWeight.w400,color: Colors.black),
                      decoration: InputDecoration(
                        hintText: 'Name',
                        hintStyle: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        prefix: Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Icon(
                            Icons.person_outline,
                            color: Colors.green,
                          ),
                        ),

                      ),
                    ),
                  ),

            //       TextFieldWidget('Name', Icons.person_outlined, nameController),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: homeController,
                      readOnly: true,
                      onTap: () async {
                        String selectedPlace = await showGoogleAutoComplete();
                        homeController.text = selectedPlace;
                        setState(() {
                        });
                      },
                      style: GoogleFonts.poppins(fontSize: 14,fontWeight: FontWeight.w400,color: Colors.black),
                      decoration: InputDecoration(
                        hintText: 'Home Address',
                        hintStyle: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        prefix: Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Icon(
                            Icons.home_outlined,
                            color: Colors.green,
                          ),
                        ),

                      ),
                    ),
                  ),


                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: businessController,
                      readOnly: true,
                      onTap: () async {
                        String selectedPlace = await showGoogleAutoComplete();
                        businessController.text = selectedPlace;
                        setState(() {
                        });
                      },
                      style: GoogleFonts.poppins(fontSize: 14,fontWeight: FontWeight.w400,color: Colors.black),
                      decoration: InputDecoration(
                        hintText: 'Business Address',
                        hintStyle: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        prefix: Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Icon(
                            Icons.business_center_outlined,
                            color: Colors.green,
                          ),
                        ),

                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: shopController,
                      readOnly: true,
                      onTap: () async {
                        String selectedPlace = await showGoogleAutoComplete();
                        shopController.text = selectedPlace;
                        setState(() {
                        });
                      },
                      style: GoogleFonts.poppins(fontSize: 14,fontWeight: FontWeight.w400,color: Colors.black),
                      decoration: InputDecoration(
                        hintText: 'Shopping Center',
                        hintStyle: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        prefix: Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Icon(
                            Icons.shopping_cart_outlined,
                            color: Colors.green,
                          ),
                        ),

                      ),
                    ),
                  ),
                  // const SizedBox(
                  //   height: 10,
                  // ),

                  // TextFieldWidget(
                  //     'Home Address',
                  //     Icons.home_outlined,
                  //     homeController,
                  //         (String? input){
                  //       if(input!.isEmpty) {
                  //         return 'Home';
                  //       }
                  //       return null;
                  //     },onTap: () async{
                  //   String place = await showGoogleAutoComplete();
                  //  LatLng homeAddress = await buildLatLngFromAddress();
                  //   homeController.text = place ;
                  //   // setState(() {
                  //   // });
                  // },
                  //     readOnly: true
                  //
                  // ),



                  // const SizedBox(
                  //   height: 10,
                  // ),
                  // TextFieldWidget('Business Address', Icons.card_travel, businessController),
                  // const SizedBox(
                  //   height: 10,
                  // ),
                  // TextFieldWidget('Shopping', Icons.shopping_cart_outlined, shopController),
                  // const SizedBox(
                  //   height: 10,
                  // ),
                  const SizedBox(
                    height: 25,
                  ),
                  greenButton('Update', () {}),
                ],
              ),
            ),




    ]
    ),
      ),
    );
  }
  static const kGoogleApiKey = "AIzaSyBt0XXMqrIAoo-tec72ZeRgnpQF4bkm4Tw";
  Future<String> showGoogleAutoComplete() async {

    Prediction? p = await PlacesAutocomplete.show(
      offset: 0,
      radius: 1000,
      strictbounds: false,
      region: "us",
      language: "en",
      context: context,
      mode: Mode.overlay,
      apiKey: kGoogleApiKey,
      components: [new Component(Component.country, "in")],
      types: ["(cities)"],
      hint: "Search City",
    );

    return p!.description!;
  }
}

TextFieldWidget(
    String title, IconData iconData, TextEditingController controller, Function validator,{Function? onTap, bool readOnly=false}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.black),
      ),
      const SizedBox(
        height: 6,
      ),
      Container(
        width: Get.width,
        // height: 50,
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                spreadRadius: 1,
                blurRadius: 1,
              )
            ],
            borderRadius: BorderRadius.circular(8)),
        child: TextFormField(
          readOnly: readOnly,
          onTap: () => onTap!(),
          validator: (input) => validator(input),
          // controller: controller,
          // style: GoogleFonts.poppins(
          //     fontSize: 14,
          //     fontWeight: FontWeight.w600,
          //     color: Colors.black),
          decoration: InputDecoration(
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Icon(
                iconData,
                color: Colors.green,
              ),
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    ],
  );
}



Widget greenButton(String title, Function onPressed) {
  return MaterialButton(
    minWidth: Get.width,
    height: 50,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
    color: Colors.green,
    onPressed: () => onPressed(),
    child: Text(
      title,
      style: GoogleFonts.poppins(
          fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
    ),
  );
}



