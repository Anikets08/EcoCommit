// ignore_for_file: prefer_interpolation_to_compose_strings

import "dart:convert";
import "dart:math";

import "package:cloud_firestore/cloud_firestore.dart";
import "package:ecocommit/utils/colors.dart";
import "package:ecocommit/utils/icons.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:google_fonts/google_fonts.dart";

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
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
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      text: 'EcoCommit \n',
                      style: GoogleFonts.poppins(
                        color: CustomColors.kDark,
                        fontSize: 25,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Feed',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w900,
                              color: CustomColors.kDark,
                              fontSize: 25,
                              height: 0.9),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("feed")
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return SizedBox(
                            height: MediaQuery.of(context).size.height * 0.9,
                            child: const Center(
                              child: CupertinoActivityIndicator(),
                            ),
                          );
                        }
                        if (snapshot.hasData) {
                          return ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 7),
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: CustomIcon.bgColors[Random().nextInt(
                                      CustomIcon.bgColors.length,
                                    )],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          CircleAvatar(
                                            child: Image.network(
                                              CustomIcon.customiconsData[
                                                  Random().nextInt(
                                                CustomIcon
                                                    .customiconsData.length,
                                              )],
                                            ),
                                          ),
                                          const SizedBox(width: 20),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                snapshot
                                                    .data!.docs[index]["user"]
                                                    .toString(),
                                                style: const TextStyle(
                                                  color: CustomColors.kDark,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              // ignore: prefer_interpolation_to_compose_strings
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const FaIcon(
                                                    FontAwesomeIcons
                                                        .locationPin,
                                                    size: 16,
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Text(
                                                    "${snapshot.data!.docs[index]["city"]}, " +
                                                        snapshot.data!
                                                                .docs[index]
                                                            ["country"],
                                                    style: const TextStyle(
                                                      color: CustomColors.kDark,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.memory(
                                          base64Decode(snapshot
                                              .data!.docs[index]["image"]),
                                          height: 200,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Text(
                                        snapshot
                                            .data!.docs[index]["description"]
                                            .toString(),
                                        style: const TextStyle(
                                          color: CustomColors.kDark,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }
                        return const Center(
                          child: Text('No data'),
                        );
                      })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
