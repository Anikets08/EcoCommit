import "package:cloud_firestore/cloud_firestore.dart";
import "package:ecocommit/utils/colors.dart";
import "package:ecocommit/utils/widget.dart";
import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

class AddGroupScreen extends StatefulWidget {
  const AddGroupScreen({super.key});

  @override
  State<AddGroupScreen> createState() => _AddGroupScreenState();
}

class _AddGroupScreenState extends State<AddGroupScreen> {
  TextEditingController _groupNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  List<String> _emails = [];

  void _addEmail() {
    setState(() {
      _emails.add(_emailController.text);
      _emailController.clear();
    });
  }

  void _createGroup() {
    if (_groupNameController.text.isNotEmpty && _emails.isNotEmpty) {
      FirebaseFirestore.instance.collection("groups").add({
        "name": _groupNameController.text,
        "members": _emails,
        "points": 0,
      }).then((value) => Navigator.pop(context));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text("Please fill all the fields"),
        ),
      );
    }
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
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      text: 'Create \n',
                      style: GoogleFonts.poppins(
                        color: CustomColors.kDark,
                        fontSize: 25,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Your Group',
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
                  CustomTextFeild(
                    controller: _groupNameController,
                    hintText: "Group Name",
                    type: TextInputType.text,
                    autofillHint: const ["name"],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextFeild(
                          controller: _emailController,
                          hintText: "Add Email",
                          type: TextInputType.emailAddress,
                          autofillHint: const ["email"],
                        ),
                      ),
                      IconButton(
                        onPressed: _addEmail,
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                  const SizedBox(height: 35),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        _createGroup();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CustomColors.kGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: const Text(
                        "Create Group",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _emails.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          dense: true,
                          visualDensity: VisualDensity.compact,
                          title: Text(
                            _emails[index],
                            style: const TextStyle(
                              color: CustomColors.kDark,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              setState(() {
                                _emails.removeAt(index);
                              });
                            },
                            icon: const Icon(Icons.delete),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
