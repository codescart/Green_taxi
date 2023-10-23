//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:get/get.dart';
// import 'package:green_taxi/models/user_model/user_model.dart';
// import 'package:green_taxi/widget/profile_settings.dart';
// import '../views/home.dart';
// import 'package:path/path.dart' as Path;
//
//  class AuthController extends GetxController {
//
//    String userUid = '';
//    var verId = '';
//    int? resendTokenId;
//    bool phoneAuthCheck = false;
//    dynamic credentials;
//
//    var isProfileUploading = false.obs;
//
//    var selectedImage;
//

 // phoneAuth(String phone) async {
 //   try {
 //     credentials = null;
 //     await FirebaseAuth.instance.verifyPhoneNumber(
 //       phoneNumber: phone,
 //       timeout: const Duration(seconds: 60),
 //       verificationCompleted: (PhoneAuthCredential credential) async {
 //         log('completed');
 //         credentials = credential;
 //         await FirebaseAuth.instance.signInWithCredential(credential);
 //       },
 //       forceResendingToken: resendTokenId,
 //       verificationFailed: (FirebaseAuthException e) {
 //         log('Failed');
 //         if (e.code == 'invalid-phone-number') {
 //           debugPrint('The provided phone number is not value.');
 //         }
 //       },
 //       codeSent: (String verificationId, int? resendToken) async {
 //         log('Code sent');
 //         verId = verificationId;
 //         resendTokenId = resendToken;
 //       },
 //       codeAutoRetrievalTimeout: (String verificationId) {},
 //       //
 //     );
 //   } catch (e) {
 //     log("Error accrued $e");
 //   }
 // }

 // verifyOtp(String otpNumber) async {
 //   log("Called");
 //   PhoneAuthCredential credential = PhoneAuthProvider.credential(
 //       verificationId: verId, smsCode: otpNumber);
 //   log("longedIn");
 //   await FirebaseAuth.instance.
 //   signInWithCredential(credential).then((value) {
 //     //decideRoute();
 //   });
 // }
 //
 //
 //  decideRoute() {
 //    User?user = FirebaseAuth.instance.currentUser;
 //    if (user != null) {
 //      FirebaseFirestore.instance.collection('users')
 //          .doc(user.uid).get()
 //          .then((value) {
 //        if (value.exists) {
 //          Get.to(() => HomeScreen());
 //        } else {
 //          Get.to(() => ProfileSettingScreen());
 //        }
 //      });
 //    }
 //  }
 //
 //
 //  uploadImage(FileImage) async {
 //    String imageUrl = '';
 //    var image;
 //    String fileName = Path.basename(image.path);
 //    var reference = FirebaseStorage.instance
 //        .ref()
 //        .child('users/$fileName');
 //    UploadTask uploadTask = reference.putFile(image);
 //    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
 //    await taskSnapshot.ref.getDownloadURL().then(
 //          (value) {
 //        imageUrl = value;
 //        print("Download URL:$value");
 //      },
 //    );
 //    return imageUrl;
 //  }
 //
 //  storeUserInfo(FileselectedImage,String name,String home,String business,String shop,) async {
 //    String url = await uploadImage(selectedImage);
 //    String uid = FirebaseAuth.instance.currentUser!.uid;
 //    FirebaseFirestore.instance.collection('users').doc(uid).set({
 //      'image': url,
 //      'name': name,
 //      'home_address': home,
 //      'business_address': business,
 //      'shopping_address': shop,
 //    }).then((value) {
 //      isProfileUploading(false);
 //
 //      Get.to(() => HomeScreen());
 //    });
 //  }
 //
 //  var myUser = UserModel().obs;
 //
 //  getUserInfo(){
 //    String uid = FirebaseAuth.instance.currentUser!.uid;
 //    FirebaseFirestore.instance.collection('users').doc(uid).snapshots().listen((event){
 //
 //      myUser.value =UserModel.fromJson(event.data()!);
 //    });
 //  }
 // }
//     Future<String> showGoogleAutoComplete( BuildContext context) async {
//     const kGoogleApiKey = "AIzaSyBt0XXMqrIAoo-tec72ZeRgnpQF4bkm4Tw";
//     Prediction? p = await PlacesAutocomplete.show(
//       offset: 0,
//       radius: 1000,
//       strictbounds: false,
//       region: "us",
//       language: "en",
//       context: context,
//       mode: Mode.overlay,
//       apiKey: kGoogleApiKey,
//       components: [new Component(Component.country, "in")],
//       types: ["(cities)"],
//       hint: "Search City",
//     );
//
//     return p!.description!;
//   }
 //  }
