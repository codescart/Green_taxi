import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show ByteData, Uint8List, rootBundle;
import 'package:google_maps_webservice/places.dart';
import 'package:green_taxi/views/payments_screen.dart';
import 'package:green_taxi/widget/profile_settings.dart';
import 'package:geocoding/geocoding.dart' as geoCoding;
import 'dart:ui' as ui;

import '../widget/text_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _mapStyle;

  // AuthController authController = Get.find<AuthController>();

  late LatLng destination;
  late LatLng source;
  final Set<Polyline> _polyline = {};

  Set<Marker> markers = Set<Marker>();
  List<String> list = <String>[
    '***** ***** ***** 1138',
    '***** ***** ***** 8601',
    '***** ***** ***** 1695',
    '***** ***** ***** 7179',
  ];

  @override
  void initState() {
    super.initState();

    // authController.getUserInfo();

    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });

    loadCustomMarker();
  }

  String dropdownValue = '***** ***** ***** 8601';
  final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  GoogleMapController? myMapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: buildDrawer(),
      body: Stack(
        children: [
          GoogleMap(
            markers: markers,
            polylines: _polyline,
            // mapType: MapType.terrain,
            zoomControlsEnabled: false,
            onMapCreated: (GoogleMapController controller) {
              myMapController = controller;
              myMapController!.setMapStyle(_mapStyle);
            },
            initialCameraPosition: _kGooglePlex,
          ),
          buildProfileTile(),
          buildTextField(),
          showSourceField ? buildTextFieldForSource() : Container(),
          buildCurrentLocationIcon(),
          buildNotificationIcon(),
          buildBottomSheet(),
        ],
      ),
    );
  }

  Widget buildProfileTile() {
    return Positioned(
      top: 40,
      left: 20,
      right: 20,
      child: Container(
        width: Get.width,
        height: Get.height * 0.15,
        padding: EdgeInsets.fromLTRB(10, 15, 0, 0),
        decoration: BoxDecoration(
          color: Colors.transparent,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('assets/person.png'),
                    fit: BoxFit.fill,
                  )),
            ),
            const SizedBox(
              width: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: 'Good Morning ',
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    ),
                    TextSpan(
                      text: 'Ajay',
                      style: TextStyle(
                          color: Color(0xFF2828B6),
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ]),
                ),
                Text(
                  "Where are you going?",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                )
              ],
            ),
          ],
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

  Future<LatLng> buildLatLngFromAddress(String place) async {
    List<geoCoding.Location> locations =
        await geoCoding.locationFromAddress(place);
    return LatLng(locations.first.latitude, locations.first.longitude);
  }

  TextEditingController destinationController = TextEditingController();
  TextEditingController _sourceController = TextEditingController();

  // TextEditingController destinationController = TextEditingController();

  bool showSourceField = false;
  bool showdriverlist = false;

  Widget buildTextField() {
    return Positioned(
      top: 160,
      left: 20,
      right: 20,
      child: Container(
        width: Get.width,
        height: 50,
        padding: EdgeInsets.only(left: 15),
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                spreadRadius: 4,
                blurRadius: 10,
              )
            ],
            borderRadius: BorderRadius.circular(8)),
        child: TextFormField(
          controller: destinationController,
          readOnly: true,
          onTap: () async {
            _polyline.clear();
            markers.clear();

            String selectedPlace = await showGoogleAutoComplete();

            // String selectedPlace = p!.description!;

            destinationController.text = selectedPlace;

            // setState(() {
            //   showSourceField = true;
            // });
            List<geoCoding.Location> locations =
                await geoCoding.locationFromAddress(selectedPlace);

            destination =
                LatLng(locations.first.latitude, locations.first.longitude);
            print(destination);
            print('destination');

            markers.add(Marker(
              markerId: MarkerId(selectedPlace),
              infoWindow: InfoWindow(
                title: 'Destination: $selectedPlace',
              ),
              position: destination,
              icon: BitmapDescriptor.fromBytes(markIcons),
            ));
            // await getPolyline(source,destination);

            myMapController!.animateCamera(CameraUpdate.newCameraPosition(
                CameraPosition(target: destination, zoom: 14)));

            setState(() {
              _sourceController.clear();
              showSourceField = true;
            });
          },
          style: GoogleFonts.poppins(
              fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
          decoration: InputDecoration(
            hintText: 'Search for a destination',
            hintStyle: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            suffixIcon: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Icon(
                Icons.search,
                color: Colors.blue,
              ),
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget buildTextFieldForSource() {
    return Positioned(
      top: 230,
      left: 20,
      right: 20,
      child: Container(
        width: Get.width,
        height: 50,
        padding: EdgeInsets.only(left: 15),
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                spreadRadius: 4,
                blurRadius: 10,
              )
            ],
            borderRadius: BorderRadius.circular(8)),
        child: TextFormField(
          controller: _sourceController,
          readOnly: true,
          onTap: () async {
            buildSourceSheet();
          },
          style: GoogleFonts.poppins(
              fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black),
          decoration: InputDecoration(
            hintText: ' From: ',
            hintStyle:
                GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
            suffixIcon: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Icon(
                Icons.search,
                color: Colors.blue,
              ),
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget buildCurrentLocationIcon() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 30, right: 8),
        child: CircleAvatar(
          radius: 20,
          backgroundColor: Colors.green,
          child: Icon(
            Icons.my_location,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget buildNotificationIcon() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 30, left: 8),
        child: CircleAvatar(
          radius: 20,
          backgroundColor: Colors.white,
          child: Icon(
            Icons.notifications,
            color: Color(0xFF1565C0),
          ),
        ),
      ),
    );
  }

  Widget buildBottomSheet() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: Get.width * 0.6,
        height: 30,
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                spreadRadius: 4,
                blurRadius: 10,
              ),
            ],
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(12), topLeft: Radius.circular(12))),
        child: Center(
          child: Container(
            width: Get.width * 0.4,
            height: 6,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  buildDrawerItem(
      {required String title,
      required Function onPressed,
      Color color = Colors.black,
      double fontSize = 20,
      FontWeight fontWeight = FontWeight.w500,
      double height = 44,
      bool isVisible = false}) {
    return SizedBox(
      height: height,
      child: ListTile(
        contentPadding: EdgeInsets.all(8),
        // minVerticalPadding: 8,
        dense: true,
        onTap: () => onPressed(),
        title: Row(
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                  fontSize: fontSize, fontWeight: fontWeight, color: color),
            ),
            const SizedBox(
              width: 5,
            ),
            isVisible
                ? CircleAvatar(
                    backgroundColor: Colors.green,
                    radius: 15,
                    child: Text(
                      '1',
                      style: GoogleFonts.poppins(color: Colors.white),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                  context as BuildContext,
                  MaterialPageRoute(
                      builder: (context) => ProfileSettingScreen()));
            },
            child: Container(
              height: 150,
              child: DrawerHeader(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: 80,
                      height: 70,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage("assets/person.png"),
                            fit: BoxFit.fill,
                          )),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Good Morning',
                          style: GoogleFonts.poppins(
                              color: Colors.black.withOpacity(0.28),
                              fontSize: 14),
                        ),
                        Text(
                          'Mark Novoak',
                          style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                buildDrawerItem(title: 'Payment History', onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>PaymentScreen()));
                }),
                buildDrawerItem(
                    title: 'Ride History', onPressed: () {}, isVisible: true),
                buildDrawerItem(title: 'Invite Friends', onPressed: () {}),
                buildDrawerItem(title: 'Promo Codes', onPressed: () {}),
                buildDrawerItem(title: 'Settings', onPressed: () {}),
                buildDrawerItem(title: 'Support', onPressed: () {}),
                buildDrawerItem(title: 'Log Out', onPressed: () {}),
              ],
            ),
          ),
          Spacer(),
          Divider(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Column(
              children: [
                buildDrawerItem(
                    title: 'Do more',
                    onPressed: () {},
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
                const SizedBox(
                  height: 20,
                ),
                buildDrawerItem(
                    title: 'Get food delivery',
                    onPressed: () {},
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.black.withOpacity(0.15),
                    height: 20),
                buildDrawerItem(
                    title: 'Make money driving',
                    onPressed: () {},
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.black.withOpacity(0.15),
                    height: 20),
                buildDrawerItem(
                    title: 'Rate us on store',
                    onPressed: () {},
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.black.withOpacity(0.15),
                    height: 20),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  late Uint8List markIcons;

  loadCustomMarker() async {
    markIcons = await loadAsset('assets/address.png', 100);
  }

  Future<Uint8List> loadAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetHeight: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  void drawPolyline() async {
    var polyline = await _getPolyLine();
    _polyline.add(polyline);
    setState(() {});
  }

  Future<Polyline> _getPolyLine() async {
    PolylineId id = PolylineId('poly');
    Polyline polyline = Polyline(
      width: 3,
      polylineId: id,
      points: await _getPolylineCoordinates(source, destination),
    );
    return polyline;
  }

  Future<List<LatLng>> _getPolylineCoordinates(
      LatLng pickupLatLng, LatLng dropLatLng) async {
    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      kGoogleApiKey,
      PointLatLng(pickupLatLng.latitude, pickupLatLng.longitude),
      PointLatLng(dropLatLng.latitude, dropLatLng.longitude),
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    print(polylineCoordinates);
    return polylineCoordinates;
  }

  void buildSourceSheet() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            width: Get.width,
            height: Get.height * 0.5,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8), topRight: Radius.circular(8)),
              color: Colors.white,
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Select Your Location",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Home Address",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(
                        'KDA,KOHAT',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w600),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Business Address",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () async {
                      String place = await showGoogleAutoComplete();
                      _sourceController.text = place;
                      source = await buildLatLngFromAddress(place);

                      List<geoCoding.Location> locations =
                          await geoCoding.locationFromAddress(place);

                      source = LatLng(
                          locations.first.latitude, locations.first.longitude);

                      if (markers.length >= 2) {
                        markers.remove(markers.last);
                      }

                      markers.add(Marker(
                        markerId: MarkerId(place),
                        infoWindow: InfoWindow(
                          title: 'Destination: $place',
                        ),
                        position: source,
                        // icon: BitmapDescriptor.fromBytes(markIcons),
                      ));
                      // _getPolyline(source,destination);
                      drawPolyline();

                      myMapController!.animateCamera(
                          CameraUpdate.newCameraPosition(
                              CameraPosition(target: source, zoom: 14)));
                      Navigator.pop(context);
                      setState(() {});
                      buildRideConfirmationSheet();
                    },
                    child: Container(
                      width: Get.width,
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              spreadRadius: 4,
                              blurRadius: 10,
                            ),
                          ]),
                      child: Row(
                        children: [
                          Text(
                            "Chakia Chandauli",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w600),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () async {
                      String place = await showGoogleAutoComplete();
                      _sourceController.text = place;

                      source = await buildLatLngFromAddress(place);

                      // List<geoCoding.Location> locations = await geoCoding.locationFromAddress(place);
                      //
                      // source = LatLng(locations.first.latitude, locations.first.longitude);
                      // print(destination);
                      // print('destination');

                      if (markers.length >= 2) {
                        markers.remove(markers.last);
                      }

                      markers.add(Marker(
                        markerId: MarkerId(place),
                        infoWindow: InfoWindow(
                          title: 'Destination: $place',
                        ),
                        position: source,
                        // icon: BitmapDescriptor.fromBytes(markIcons),
                      ));
                      // _getPolyline(source,destination);
                      drawPolyline();

                      myMapController!.animateCamera(
                          CameraUpdate.newCameraPosition(
                              CameraPosition(target: source, zoom: 14)));
                      Navigator.pop(context);
                      setState(() {
                        showdriverlist = true;
                      });
                      showdriverlist?buildRideConfirmationSheet():Container();

                    },
                    child: Container(
                      width: Get.width,
                      height: 50,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              spreadRadius: 4,
                              blurRadius: 10,
                            )
                          ]),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Search for Address",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w600),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ),
                  ),
                ]),
          );
        });
  }

  // buildRideConfirmationSheet() {
  //   Get.bottomSheet(
  //       Container(
  //     width: Get.width,
  //     height: Get.height * 0.4,
  //     padding: EdgeInsets.only(left: 20),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.only(
  //           topRight: Radius.circular(12), topLeft: Radius.circular(12)),
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         const SizedBox(
  //           height: 10,
  //         ),
  //         Center(
  //           child: Container(
  //             width: Get.width * 0.2,
  //             height: 8,
  //             decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.circular(8), color: Colors.grey),
  //           ),
  //         ),
  //         const SizedBox(
  //           height: 20,
  //         ),
  //         textWidget(
  //             text: 'Select on option',
  //             fontsize: 18,
  //             fontWeight: FontWeight.bold,
  //             color: Colors.red,
  //             textWidget: ''),
  //         const SizedBox(
  //           height: 20,
  //         ),
  //         buildDriversList(),
  //         const SizedBox(
  //           height: 20,
  //         ),
  //         Padding(
  //           padding: EdgeInsets.only(right: 20),
  //           child: Divider(),
  //         ),
  //         Padding(
  //           padding: EdgeInsets.only(right: 20),
  //           child: Row(
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             children: [
  //               Expanded(child: buildPaymentCardWidget()),
  //               MaterialButton(
  //                 onPressed: () {},
  //                 child: textWidget(
  //                     text: 'Confirm',
  //                     color: Colors.white,
  //                     fontWeight: FontWeight.normal,
  //                     textWidget: ''),
  //                 color: Color(0xFF7CB342),
  //                 shape: StadiumBorder(),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   )
  //   );
  // }

  void buildRideConfirmationSheet() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            width: Get.width,
            height: Get.height * 0.4,
            padding: EdgeInsets.only(left: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(12), topLeft: Radius.circular(12)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: Container(
                    width: Get.width * 0.2,
                    height: 8,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8), color: Colors.grey),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                textWidget(
                    text: 'Select on option',
                    fontsize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                    textWidget: ''),
                const SizedBox(
                  height: 10,
                ),
                buildDriversList(),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Divider(),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(child: buildPaymentCardWidget()),
                      MaterialButton(
                        onPressed: () {},
                        child: textWidget(
                            text: 'Confirm',
                            color: Colors.redAccent,
                            fontWeight: FontWeight.normal,
                            textWidget: ''
                        ),
                        color: Color(0xFF7CB342),
                        shape: StadiumBorder(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }


  int selectedRide = 0;

  buildDriversList() {
    return Container(
      height: 100,
      width: Get.width,
      child: StatefulBuilder(builder: (context, set) {
        return ListView.builder(
          itemBuilder: (ctx, i) {
            return InkWell(
              onTap: () {
                set(() {
                  selectedRide = i;
                });
              },
              child: buildDriverCard(selectedRide == i),
            );
          },
          itemCount: 3,
          scrollDirection: Axis.horizontal,
        );
      }),
    );
  }

  buildDriverCard(bool selected) {
    return Container(
      margin: EdgeInsets.only(right: 8, left: 8, top: 4, bottom: 4),
      height: 85,
      width: 165,
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: selected
                    ? Color(0xFF00C853).withOpacity(0.2)
                    : Colors.grey.withOpacity(0.2),
                offset: Offset(0, 5),
                blurRadius: 5,
                spreadRadius: 1),
          ],
          borderRadius: BorderRadius.circular(12),
          color: selected ? Color(0xFF00E676) : Colors.grey),
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(left: 10, top: 10, bottom: 10, right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                textWidget(
                    text: 'Standard',
                    color: Color(0xFFFFFFFF),
                    fontWeight: FontWeight.bold,
                    textWidget: ''),
                textWidget(
                    text: '\$9.98',
                    color: Color(0xFFFFFFFF),
                    fontWeight: FontWeight.w500,
                    textWidget: ''),
                textWidget(
                    text: '3 MIN',
                    color: Colors.white.withOpacity(0.8),
                    fontWeight: FontWeight.normal,
                    fontsize: 12,
                    textWidget: ''),
              ],
            ),
          ),
          Positioned(
              right: -40,
              top: 0,
              bottom: 0,
              child: Image.asset('assets/ubercar.png'))
        ],
      ),
    );
  }

  buildPaymentCardWidget() {
    return Container(
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/visa-card.png',
              width: 40,
            ),
            SizedBox(
              width: 10,
            ),
            DropdownButton<String>(
                value: dropdownValue,
                icon: const Icon(Icons.keyboard_arrow_down_rounded),
                elevation: 16,
                style: const TextStyle(color: Colors.deepPurple),
                underline: Container(),
                onChanged: (String? value) {
                  setState(() {
                    dropdownValue = value!;
                  });
                },
                items: list.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                      value: value, child: Text(value));
                }).toList()),
          ]),
    );
  }
}
