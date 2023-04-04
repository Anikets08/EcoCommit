import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecocommit/screens/add_group.dart';
import 'package:ecocommit/screens/group_extended.dart';
import 'package:ecocommit/utils/colors.dart';
import 'package:ecocommit/utils/icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class PersonalDashboard extends StatefulWidget {
  const PersonalDashboard({super.key});

  @override
  State<PersonalDashboard> createState() => _PersonalDashboardState();
}

class _PersonalDashboardState extends State<PersonalDashboard> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: CustomColors.kGreen,
        onPressed: () {
          Navigator.pushNamed(context, '/camera');
        },
        child: const FaIcon(FontAwesomeIcons.leaf),
      ),
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
                      text: 'Personal \n',
                      style: GoogleFonts.poppins(
                        color: CustomColors.kDark,
                        fontSize: 25,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Dashboard',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w900,
                              color: CustomColors.kDark,
                              fontSize: 25,
                              height: 0.9),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  SingleChildScrollView(
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              index = 0;
                            });
                          },
                          child: Chip(
                            backgroundColor:
                                index == 0 ? CustomColors.kGreen : null,
                            label: Text(
                              "Globe",
                              style: TextStyle(
                                color: index == 0 ? Colors.white : null,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              index = 1;
                            });
                          },
                          child: Chip(
                            backgroundColor:
                                index == 1 ? CustomColors.kGreen : null,
                            label: Text(
                              "Country",
                              style: TextStyle(
                                color: index == 1 ? Colors.white : null,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              index = 2;
                            });
                          },
                          child: Chip(
                            backgroundColor:
                                index == 2 ? CustomColors.kGreen : null,
                            label: Text(
                              "City",
                              style: TextStyle(
                                color: index == 2 ? Colors.white : null,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("users")
                          .orderBy(
                            'points',
                            descending: true,
                          )
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return SizedBox(
                            height: MediaQuery.of(context).size.height * 0.5,
                            child: const Center(
                              child: CupertinoActivityIndicator(),
                            ),
                          );
                        }
                        if (snapshot.hasData) {
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 7),
                                child: Card(
                                  clipBehavior: Clip.antiAlias,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ListTile(
                                    subtitle: Text(
                                      "${snapshot.data!.docs[index]['points']} points",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12,
                                      ),
                                    ),
                                    leading: Image.network(
                                      CustomIcon
                                          .customiconsData[Random().nextInt(
                                        CustomIcon.customiconsData.length,
                                      )],
                                    ),
                                    tileColor: index == 0
                                        ? const Color(0xFFEDDA8C)
                                            .withOpacity(0.3)
                                        : index == 1
                                            ? const Color(0xFFE4E4E3)
                                                .withOpacity(0.5)
                                            : index == 2
                                                ? const Color(0xFFCBA279)
                                                    .withOpacity(0.2)
                                                : Colors.transparent,
                                    title: Text(
                                      snapshot.data!.docs[index]['name'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12,
                                      ),
                                    ),
                                    trailing: Text(
                                      index == 0
                                          ? "🥇"
                                          : index == 1
                                              ? "🥈"
                                              : index == 2
                                                  ? "🥉"
                                                  : "${index + 1}th",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
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

class CommunityDashboard extends StatefulWidget {
  const CommunityDashboard({super.key});

  @override
  State<CommunityDashboard> createState() => _CommunityDashboardState();
}

class _CommunityDashboardState extends State<CommunityDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: SizedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: "screen",
              backgroundColor: CustomColors.kGreen,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddGroupScreen(),
                  ),
                );
              },
              child: const FaIcon(
                FontAwesomeIcons.users,
                size: 18,
              ),
            ),
          ],
        ),
      ),
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
                      text: 'Community \n',
                      style: GoogleFonts.poppins(
                        color: CustomColors.kDark,
                        fontSize: 25,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Dashboard',
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
                          .collection("groups")
                          .orderBy(
                            'points',
                            descending: true,
                          )
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return SizedBox(
                            height: MediaQuery.of(context).size.height * 0.5,
                            child: const Center(
                              child: CupertinoActivityIndicator(),
                            ),
                          );
                        }
                        if (snapshot.hasData) {
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 7),
                                child: Card(
                                  clipBehavior: Clip.antiAlias,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      color: snapshot
                                              .data!.docs[index]['members']
                                              .contains(FirebaseAuth
                                                  .instance.currentUser!.email)
                                          ? CustomColors.kGreen
                                          : Colors.transparent,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ListTile(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              GroupExtendedScreen(
                                                  id: snapshot
                                                      .data!.docs[index].id),
                                        ),
                                      );
                                    },
                                    subtitle: Text(
                                      "${snapshot.data!.docs[index]['points']} points",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12,
                                      ),
                                    ),
                                    leading: Image.network(
                                      CustomIcon
                                          .customiconsData[Random().nextInt(
                                        CustomIcon.customiconsData.length,
                                      )],
                                    ),
                                    tileColor: index == 0
                                        ? const Color(0xFFEDDA8C)
                                            .withOpacity(0.3)
                                        : index == 1
                                            ? const Color(0xFFE4E4E3)
                                                .withOpacity(0.5)
                                            : index == 2
                                                ? const Color(0xFFCBA279)
                                                    .withOpacity(0.2)
                                                : Colors.transparent,
                                    title: Text(
                                      snapshot.data!.docs[index]['name'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12,
                                      ),
                                    ),
                                    trailing: Text(
                                      index == 0
                                          ? "🥇"
                                          : index == 1
                                              ? "🥈"
                                              : index == 2
                                                  ? "🥉"
                                                  : "${index + 1}th",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
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
