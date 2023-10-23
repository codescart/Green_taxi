import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:green_taxi/widget/green_Intro_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geocoding/geocoding.dart' as Path;

class DriverProfileSetup extends StatefulWidget {
  const DriverProfileSetup({super.key});

  @override
  State<DriverProfileSetup> createState() => DriverProfileSetupState();
}

class DriverProfileSetupState extends State<DriverProfileSetup> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final ImagePicker _picker = ImagePicker();
  File? selectedImage;

  var text;

  getImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      selectedImage = File(image.path);
      setState(() {});
    }
  }


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
                    greenIntroWidgetWithoutLogos(title: 'Let Get Started!'),
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
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFieldWidget(
                          'Name', Icons.person_outline,nameController,(String? input){
                            if(input!.isEmpty){
                              return'';
                            }
                            if(input.length<5){
                              return'';
                            }
                            return null;
                      }),
                      const SizedBox(height: 10,),
                      TextFieldWidget(
                          'Email', Icons.email, emailController,(String? input){
                            if(input!.isEmpty){
                              return'';
                            }
                            if(!input.isEmail){
                              return'';
                            }
                            return null;

                      },onTap: ()async{

                      },readOnly: false),

                      const SizedBox(height: 35,),
                      greenButton('Submit', (){}),
              ]
                 ),
                ),
              ),
        ]),
      ),
    );
  }
}

TextFieldWidget(
    String title, IconData iconData, TextEditingController controller, Function validator,{Function? onTap, bool readOnly=false }) {
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
          controller: controller,
          style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black),
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



