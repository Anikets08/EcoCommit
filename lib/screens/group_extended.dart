import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecocommit/utils/colors.dart';
import 'package:ecocommit/utils/icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GroupExtendedScreen extends StatefulWidget {
  const GroupExtendedScreen({super.key, required this.id});
  final String id;
  @override
  State<GroupExtendedScreen> createState() => _GroupExtendedScreenState();
}

class _GroupExtendedScreenState extends State<GroupExtendedScreen> {
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
                  StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("groups")
                          .doc(widget.id)
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
                            itemCount: snapshot.data!["members"].length,
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
                                    title: Text(
                                      snapshot.data!["members"][index],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12,
                                      ),
                                    ),

                                    // subtitle: Text(
                                    //   "${snapshot.data!.docs[index]['points']} points",
                                    //   style: const TextStyle(
                                    //     fontWeight: FontWeight.w700,
                                    //     fontSize: 12,
                                    //   ),
                                    // ),
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
                                    // title: Text(
                                    //   snapshot.data!.docs[index]['name'],
                                    //   style: const TextStyle(
                                    //     fontWeight: FontWeight.w700,
                                    //     fontSize: 12,
                                    //   ),
                                    // ),
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
