import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecocommit/functions/auth.dart';
import 'package:ecocommit/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height * 0.9,
            minWidth: MediaQuery.of(context).size.width,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: 'My \n',
                        style: GoogleFonts.poppins(
                          color: CustomColors.kDark,
                          fontSize: 25,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Profile',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w900,
                                color: CustomColors.kDark,
                                fontSize: 25,
                                height: 0.9),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        primary: CustomColors.kGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onPressed: () {
                        Auth().signOut();
                      },
                      child: const Text("Logout"),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  width: MediaQuery.of(context).size.width,
                  child: FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection("plantations")
                        .doc(FirebaseAuth.instance.currentUser!.email)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Text("Something went wrong");
                      }

                      if (snapshot.hasData && !snapshot.data!.exists) {
                        return const Text("Document does not exist");
                      }
                      if (snapshot.connectionState == ConnectionState.done) {
                        Map<String, dynamic> data =
                            snapshot.data!.data() as Map<String, dynamic>;
                        List<dynamic> nData = data["list"];
                        print(data.length);
                        return nData.isEmpty
                            ? const Text("No Data")
                            : ListView.builder(
                                itemCount: nData.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: Card(
                                      child: ListTile(
                                        leading: Image.memory(
                                          base64Decode(
                                              nData[index]["plantImage"]),
                                          fit: BoxFit.cover,
                                        ),
                                        title: Text(
                                          nData[index]["plantName"],
                                          style: const TextStyle(
                                              color: CustomColors.kDark,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        subtitle: Text(nData[index]["address"]),
                                        trailing: Text(
                                            DateTime.parse(nData[index]
                                                        ["plantDate"]
                                                    .toDate()
                                                    .toString())
                                                .toString()
                                                .substring(0, 10),
                                            style: const TextStyle(
                                                color: CustomColors.kDark,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                  );
                                });
                      }
                      return const Center(
                        child: CupertinoActivityIndicator(),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
