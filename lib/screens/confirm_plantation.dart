import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecocommit/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

enum Routine { none, once, twice }

class ConfirmPlantation extends StatefulWidget {
  const ConfirmPlantation({super.key, required this.path});
  final String path;

  @override
  State<ConfirmPlantation> createState() => _ConfirmPlantationState();
}

class _ConfirmPlantationState extends State<ConfirmPlantation> {
  Position? location;
  List<Placemark>? placemarks;
  Routine _selectedRoutine = Routine.once;
  String? plantName;
  double? probability;

  void getLoaction() async {
    await Geolocator.isLocationServiceEnabled();
    await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    List<Placemark> marks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    await checkPlant();
    setState(() {
      location = position;
      placemarks = marks;
    });
  }

  @override
  void initState() {
    super.initState();
    getLoaction();
  }

  Future<void> checkPlant() {
    return http
        .post(
      Uri.parse('https://api.plant.id/v2/identify'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Api-Key": 'Tc6FSLmkXEt74edi4rzsuUosjV4QTGKVmfciuNFJIwqKFLsLhC',
      },
      body: jsonEncode(<String, dynamic>{
        'images': [base64Encode(File(widget.path).readAsBytesSync())],
      }),
    )
        .then((value) {
      var body = jsonDecode(value.body);
      setState(() {
        plantName = body['suggestions'][0]['plant_name'];
        probability = body['suggestions'][0]['probability'];
      });
      debugPrint(body['suggestions'][0]['plant_name']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height * 0.9,
              minWidth: MediaQuery.of(context).size.width,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Column(
                    children: [
                      RichText(
                        text: TextSpan(
                          text: 'Confirm \n',
                          style: GoogleFonts.poppins(
                            color: CustomColors.kDark,
                            fontSize: 25,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Plantation',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w900,
                                color: CustomColors.kDark,
                                fontSize: 25,
                                height: 0.9,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Image.file(
                      File(widget.path),
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 40),
                  ListTile(
                    leading: const FaIcon(FontAwesomeIcons.locationArrow),
                    title: Text(
                      placemarks != null
                          ? "${placemarks![0].street}, ${placemarks![0].locality}, ${placemarks![0].country}"
                          : "Loading...",
                      style: GoogleFonts.poppins(
                        color: CustomColors.kDark,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const FaIcon(FontAwesomeIcons.tree),
                    title: Text(
                      plantName == null || placemarks == null
                          ? "Loading..."
                          : probability != null && probability! < 0.50
                              ? "Wrong Image"
                              : plantName != null
                                  ? "$plantName"
                                  : "Loading...",
                      style: GoogleFonts.poppins(
                        color: CustomColors.kDark,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Plantation Routine Care / Week",
                    style: GoogleFonts.poppins(
                      color: CustomColors.kDark,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "We'll remind you to take care of your plant",
                    style: GoogleFonts.poppins(
                      color: CustomColors.kDark,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      height: 0.95,
                    ),
                  ),
                  const SizedBox(height: 10),
                  FittedBox(
                    child: Container(
                      height: 60,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedRoutine = Routine.once;
                              });
                            },
                            child: Container(
                              height: 40,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                color: _selectedRoutine == Routine.once
                                    ? Colors.white
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Center(
                                child: Text(
                                  "Once",
                                  style: GoogleFonts.poppins(
                                    color: CustomColors.kDark,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedRoutine = Routine.twice;
                              });
                            },
                            child: Container(
                              height: 40,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                color: _selectedRoutine == Routine.twice
                                    ? Colors.white
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Center(
                                child: Text(
                                  "Twice",
                                  style: GoogleFonts.poppins(
                                    color: CustomColors.kDark,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedRoutine = Routine.none;
                              });
                            },
                            child: Container(
                              height: 40,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                color: _selectedRoutine == Routine.none
                                    ? Colors.white
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Center(
                                child: Text(
                                  "None",
                                  style: GoogleFonts.poppins(
                                    color: CustomColors.kDark,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (plantName != null &&
                            placemarks != null &&
                            probability != null &&
                            probability! > 0.50) {
                          try {
                            FirebaseFirestore.instance
                                .collection("plantations")
                                .doc(FirebaseAuth.instance.currentUser!.email)
                                .set({
                              "list": FieldValue.arrayUnion([
                                {
                                  "userId":
                                      FirebaseAuth.instance.currentUser!.email,
                                  "plantName": plantName,
                                  "plantImage": base64Encode(
                                      File(widget.path).readAsBytesSync()),
                                  "city": placemarks![0].locality,
                                  "country": placemarks![0].country,
                                  "address":
                                      "${placemarks![0].street}, ${placemarks![0].locality}, ${placemarks![0].country}",
                                  "plantRoutine": _selectedRoutine.toString(),
                                  "plantDate": DateTime.now(),
                                }
                              ])
                            });

                            FirebaseFirestore.instance
                                .collection("users")
                                .doc(FirebaseAuth.instance.currentUser!.email)
                                .update({
                              "points": FieldValue.increment(10),
                              "city": placemarks![0].locality,
                              "country": placemarks![0].country,
                            });

                            FirebaseFirestore.instance
                                .collection("feed")
                                .doc()
                                .set({
                              "image": base64Encode(
                                  File(widget.path).readAsBytesSync()),
                              "plantName": plantName,
                              "city": placemarks![0].locality,
                              "country": placemarks![0].country,
                              "user": FirebaseAuth.instance.currentUser!.email,
                              "description":
                                  "I just planted a $plantName in ${placemarks![0].locality}, ${placemarks![0].country}",
                            });

                            FirebaseFirestore.instance
                                .collection("groups")
                                .where("members",
                                    arrayContains: FirebaseAuth
                                        .instance.currentUser!.email)
                                .get()
                                .then((value) {
                              value.docs.forEach((element) {
                                FirebaseFirestore.instance
                                    .collection("groups")
                                    .doc(element.id)
                                    .update({
                                  "points": FieldValue.increment(10),
                                });
                              });
                            });

                            Navigator.pushReplacementNamed(
                                context, '/congratulations');
                          } on FirebaseException catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.red,
                                content: Text(e.message!),
                              ),
                            );
                          }
                        } else if (probability != null && probability! < 0.50) {
                          Navigator.pushReplacementNamed(context, '/camera');
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: Colors.red,
                              content: Text("Please wait for the data to load"),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amberAccent[700],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          probability != null && probability! > 0.50
                              ? const FaIcon(
                                  FontAwesomeIcons.coins,
                                  color: Colors.white,
                                )
                              : const SizedBox(),
                          const SizedBox(width: 20),
                          Text(
                            plantName == null || placemarks == null
                                ? "Loading..."
                                : probability != null && probability! > 0.50
                                    ? "Earn 10 points"
                                    : "Wrong Image, Try Again",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
